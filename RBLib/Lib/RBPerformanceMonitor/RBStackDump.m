//
//  RBStackDump.m
//  RBLib
//
//  Created by Ruibin.Chow on 16/8/26.
//  Copyright © 2016年 zruibin. All rights reserved.
//

#import "RBStackDump.h"

#import <execinfo.h>
#import <unistd.h>
#import <mach/mach_types.h>
#import <mach/mach_traps.h>
#import <mach/mach.h>
#import <pthread/pthread.h>
#import <sys/mman.h>

@implementation RBStackDump

+ (instancetype)sharedInstance
{
    static RBStackDump *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [RBStackDump sharedInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [RBStackDump sharedInstance];
}

- (void)dump
{
    DLog(@"--------------------------------------------------------------------------------------------------------------");
    dumpThreads();
//    PrintStackTrace();
    DLog(@"--------------------------------------------------------------------------------------------------------------");
}


static void PrintStackTrace()
{
    void *stackAdresses[32];
    int stackSize = backtrace(stackAdresses, 32);
    backtrace_symbols_fd(stackAdresses, stackSize, STDOUT_FILENO);
    
    DLog(@"--------");
    DLog(@"%@", [NSThread callStackSymbols]);
}

/**
 *  所有存活线程
 */
static void dumpThreads(void)
{
    char name[256];
    mach_msg_type_number_t count;
    thread_act_array_t list;
    task_threads(mach_task_self(), &list, &count);
    for (int i = 0; i < count; ++i) {
        pthread_t pt = pthread_from_mach_thread_np(list[i]);
        if (pt) {
            name[0] = '\0';
            int rc = pthread_getname_np(pt, name, sizeof name);
            DLog(@"mach thread %u: getname returned %d: %s", list[i], rc, name);
            
            void*  stack_base = pthread_get_stackaddr_np(pt);
            size_t stack_size = pthread_get_stacksize_np(pt);
            DLog(@"Thread: base:%p / size:%zu", stack_base, stack_size);
            
        } else {
            DLog(@"mach thread %u: no pthread found", list[i]);
        }
    }
}

@end
