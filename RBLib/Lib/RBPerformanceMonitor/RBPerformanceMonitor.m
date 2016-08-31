//
//  RBPerformanceMonitor.m
//  RBLib
//
//  Created by Ruibin.Chow on 15/11/25.
//  Copyright © 2015年 Ruibin.Chow All rights reserved.
//

#import "RBPerformanceMonitor.h"
#import <QuartzCore/CADisplayLink.h>
#import <libkern/OSAtomic.h>
#import "RBStackDump.h"

#ifdef DEBUG
#define Report(FORMAT, ...) fprintf(stderr,"[%s:%d]\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define Report(...)
#endif

@interface RBPerformanceMonitor ()
{
    int timeoutCount;
    CFRunLoopObserverRef observer;
    
@public
    dispatch_semaphore_t semaphore;
    CFRunLoopActivity activity;
}

@property(nonatomic, strong) CADisplayLink *displayLink;
@property(nonatomic, assign) OSSpinLock spinLock;
@property(nonatomic, assign) NSUInteger frameStep;
@property(nonatomic, assign) CFAbsoluteTime startFPSTime;
@property(nonatomic, assign) CFAbsoluteTime stepBeginTime;

- (void)startFPSMonitor;
- (void)stopFPSMonitor;

@end

@implementation RBPerformanceMonitor

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    RBPerformanceMonitor *moniotr = (__bridge RBPerformanceMonitor*)info;
    
    moniotr->activity = activity;
    
    dispatch_semaphore_t semaphore = moniotr->semaphore;
    dispatch_semaphore_signal(semaphore);
}

- (void)stop
{
    [self stopFPSMonitor];
    
    if (!observer)
        return;
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
    observer = NULL;
}

- (void)start
{
    [self startFPSMonitor];
    
    if (observer)
        return;
    
    // 信号
    semaphore = dispatch_semaphore_create(0);
    
    // 注册RunLoop状态观察
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                       kCFRunLoopAllActivities,
                                       YES,
                                       0,
                                       &runLoopObserverCallBack,
                                       &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    
    dispatch_queue_t queue = dispatch_queue_create("RBPerformanceMonitor Thread", DISPATCH_QUEUE_CONCURRENT);
    // 在子线程监控时长
    dispatch_async(queue, ^{
        [[NSThread currentThread] setName:@"RBPerformanceMonitor Thread"];
        while (YES) {
//            [self displayFPS];
            long st = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_MSEC));
            if (st != 0) {
                if (!observer) {
                    timeoutCount = 0;
                    semaphore = 0;
                    activity = 0;
                    return;
                }
                
                if (activity==kCFRunLoopBeforeSources || activity==kCFRunLoopAfterWaiting) {
//                    if (++timeoutCount < 5)
//                        continue;
                    
                    Report(@"Report:\n------------\n%@\n------------\n", [RBStackDump backtraceOfMainThread]);
                    timeoutCount = 0;
                }
            }
        }
    });
}

#pragma makr - FPS

- (void)startFPSMonitor
{
    if (self.displayLink) return ;
    
    self.startFPSTime = CFAbsoluteTimeGetCurrent();
    self.stepBeginTime = CFAbsoluteTimeGetCurrent();
    _spinLock = OS_SPINLOCK_INIT;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallback)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopFPSMonitor
{
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)displayLinkCallback
{
    OSSpinLockLock(&_spinLock);
    ++self.frameStep;
    OSSpinLockUnlock(&_spinLock);
}

- (void)displayFPS
{
    CFAbsoluteTime nowTime = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime duration = nowTime - self.stepBeginTime;
    if (duration > 1.0f) {
        NSUInteger frame = self.frameStep / round(duration);
        Report(@"%0.0f sec FPS: \t %ld", round(nowTime-self.startFPSTime), frame);
        self.stepBeginTime = nowTime;
        
        OSSpinLockLock(&_spinLock);
        self.frameStep = 0;
        OSSpinLockUnlock(&_spinLock);
    }
}


@end
