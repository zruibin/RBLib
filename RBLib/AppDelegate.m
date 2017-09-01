//
//  AppDelegate.m
//  RBLib
//
//  Created by zruibin on 15/4/1.
//  Copyright (c) 2015年 zruibin. All rights reserved.
//

#import "AppDelegate.h"
#import "UncaughtExceptionHandler.h"
#import "UIImage+Hook.h"
#import "RBPerformanceMonitor.h"
#import "RBURLProtocol.h"
#import "RBStackDump.h"

static NSInteger count = 10;

@interface AppDelegate ()

@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    InstallUncaughtExceptionHandler();
    
#if DEBUG
    [[RBPerformanceMonitor sharedInstance] start];
//    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(dumpTimer) userInfo:nil repeats:YES];
#endif
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = [UIColor whiteColor];
//    
//    LifeCycleViewController *lifeCycleVC = [[LifeCycleViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lifeCycleVC];
//    
//    self.window.rootViewController = nav;
//    
//    [self.window makeKeyAndVisible];
    
    [UIImage initialize];
//    [[RBPerformanceMonitor sharedInstance] start];
//    [NSURLProtocol registerClass:[RBURLProtocol class]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground...");
    /*
     使用block的另一个用处是可以让程序在后台较长久的运行。
     在以前，当app被按home键退出后，app仅有最多5秒钟的时候做一些保存或清理资源的工作。
     但是应用可以调用UIApplication的beginBackgroundTaskWithExpirationHandler方法，让app最多有10分钟的时间在后台长久运行。这个时间可以用来做清理本地缓存，发送统计数据等工作。
     */
    [self beingBackgroundUpdateTask];
    
    // 在这里加上你需要长久运行的代码
    while (count > 0) {
       NSLog(@"applicationDidEnterBackground task --> %ld", count);
        --count;
        [NSThread sleepForTimeInterval:2.0f];
    }
    
    [self endBackgroundUpdateTask];
}

- (void)beingBackgroundUpdateTask
{
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void)endBackgroundUpdateTask
{
    [[UIApplication sharedApplication] endBackgroundTask: self.backgroundUpdateTask];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
}


- (void)dumpTimer
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        [RBStackDump backtraceOfMainThread];
    });
}


@end
