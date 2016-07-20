//
//  UncaughtExceptionHandler.m
//  RBLib
//
//  Created by zruibin on 15/4/1.
//  Copyright (c) 2015年 zruibin. All rights reserved.
//

#import "UncaughtExceptionHandler.h"

#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <sys/utsname.h>

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
NSString * const UncaughtExceptionHandlerAppInfo = @"UncaughtExceptionHandlerAppInfo";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;
const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

NSString* getAppInfo();

@implementation UncaughtExceptionHandler


+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    
    for (
         i = UncaughtExceptionHandlerSkipAddressCount;
         i < UncaughtExceptionHandlerSkipAddressCount + UncaughtExceptionHandlerReportAddressCount;
         i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;
}


- (void)handleException:(NSException *)exception
{
    DLog(@" %@", getAppInfo());
    
    DLog(@"异常原因如下:\n%@\n%@", [exception reason],
            [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]);

    
    NSSetUncaughtExceptionHandler(NULL);
    
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
    {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    }
    else
    {
        [exception raise];
    }
}

@end


NSString* getAppInfo()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSString *appInfo = [NSString stringWithFormat:@"\nApp : %@ %@(%@) \nDevice : %@\nOS Version : %@ %@\nUDID : %@\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         deviceString,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion,
                         [UIDevice currentDevice].identifierForVendor.UUIDString];
//    DLog(@"Crash!!!! %@", [[NSBundle mainBundle] infoDictionary]);
    return appInfo;
}

void HandleException(NSException *exception)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    NSArray *callStack = [UncaughtExceptionHandler backtrace];
    NSMutableDictionary *userInfo =
    [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo
     setObject:callStack
     forKey:UncaughtExceptionHandlerAddressesKey];
    
    [[[UncaughtExceptionHandler alloc] init]
        performSelectorOnMainThread:@selector(handleException:)
        withObject: [NSException exceptionWithName:[exception name] reason:[exception reason]
                                          userInfo:userInfo]
        waitUntilDone:YES];
}

void SignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal]
                                                                       forKey:UncaughtExceptionHandlerSignalKey];
    [userInfo setObject:getAppInfo() forKey:UncaughtExceptionHandlerAppInfo];
    
    NSArray *callStack = [UncaughtExceptionHandler backtrace];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    
    UncaughtExceptionHandler *handler = [[UncaughtExceptionHandler alloc] init];
    [handler performSelectorOnMainThread:@selector(handleException:)
             withObject:[NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
                                                                 reason:[NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.\n" @"%@", nil),
                                                                         signal, getAppInfo()]
                                                               userInfo: userInfo]
             waitUntilDone:YES];

}

void InstallUncaughtExceptionHandler()
{
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}








