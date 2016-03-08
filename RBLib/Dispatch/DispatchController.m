//
//  DispatchController.m
//  RBLib
//
//  Created by zruibin on 15/10/11.
//  Copyright © 2015年 zruibin. All rights reserved.
//

#import "DispatchController.h"
#import "RBMacros.h"

@interface DispatchController ()

@end

@implementation DispatchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [NSThread detachNewThreadSelector:@selector(observerRunLoop) toTarget:self withObject:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    usleep(600*1000);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)semaphoreAction:(id)sender
{
    __block dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    static NSInteger number = 20;
    number = 20;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i=0; i<15; i++) {
            DLog(@"1---number:%ld", (long)number);
            
            --number;
            
            if (number == 0) {
                dispatch_semaphore_signal(sem);
            }
        }
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i=0; i<5; i++) {
            DLog(@"2---number:%ld", (long)number);
            
            --number;
            
            if (number == 0) {
                dispatch_semaphore_signal(sem);
            }
        }
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        for(int j=0;j<5;j++)
        {
            DLog(@">> Main Data: %d",j);
        }
    });
    /*
     1. 创建信号量，可以设置信号量的资源数。0表示没有资源，调用dispatch_semaphore_wait会立即等待。
     dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
     
     2. 等待信号，可以设置超时参数。该函数返回0表示得到通知，非0表示超时。
     dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
     
     3. 通知信号，如果等待线程被唤醒则返回非0，否则返回0。
     dispatch_semaphore_signal(semaphore);
     */
}

- (IBAction)barrierAction:(id)sender
{
    //MARK:使用dispatch_get_global_queue的话，barrier调用顺序有误，只能用于自行创建的DISPATCH_QUEUE_CONCURRENT上才有作用
    dispatch_queue_t queue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        DLog(@"queue--1");
    });
    dispatch_async(queue, ^{
        DLog(@"queue--2");
    });
    
    dispatch_barrier_async(queue, ^{
        DLog(@"queue--barrier");
    });
    
    dispatch_async(queue, ^{
        DLog(@"queue--3");
    });
    dispatch_async(queue, ^{
        DLog(@"queue--4");
    });
}

- (IBAction)group1Action:(id)sender
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger i=0; i<10; i++) {
        dispatch_group_async(group, queue, ^{
            DLog(@"group-->%ld", (long)i);
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    DLog(@"group end...");
}

- (IBAction)group2Action:(id)sender
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger i=0; i<10; i++) {
        dispatch_group_async(group, queue, ^{
            DLog(@"group-->%ld", (long)i);
        });
    }
    
    dispatch_group_notify(group, queue, ^{
        DLog(@"group end...");
    });
    
}

- (IBAction)group3Action:(id)sender
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    for(int i = 0; i < 10; i++) {
        dispatch_group_enter(group);
        dispatch_async(queue, ^{
            DLog(@"group-->%d", i);
            dispatch_group_leave(group);
        });
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    DLog(@"group end...");
}

#pragma mark - RunLoop

static NSInteger loopCount = 5;

- (void)observerRunLoop
{
    [[NSThread currentThread] setName:@"ObserverRunLoop Thread"];
    //获得当前thread的Run loop
    NSRunLoop *myRunLoop = [NSRunLoop currentRunLoop];
    
    //由于在run loop添加了observer且设置observer对所有的run loop行为都感兴趣。
    //当调用runUnitDate方法时，observer检测到run loop启动并进入循环，observer会调用其回调函数，第二个参数所传递的行为是kCFRunLoopEntry。
    //observer检测到run loop的其它行为并调用回调函数的操作与上面的描述相类似。
    //当run loop的运行时间到达时，会退出当前的run loop。observer同样会检测到run loop的退出行为并调用其回调函数，第二个参数所传递的行为是kCFRunLoopExit。
    [myRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    
    //设置Run loop observer的运行环境
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    //创建Run loop observer对象
    //第一个参数用于分配observer对象的内存
    //第二个参数用以设置observer所要关注的事件，详见回调函数myRunLoopObserver中注释
    //第三个参数用于标识该observer是在第一次进入run loop时执行还是每次进入run loop处理时均执行
    //第四个参数用于设置该observer的优先级
    //第五个参数用于设置该observer的回调函数
    //第六个参数用于设置该observer的运行环境
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
    
    if (observer) {
        //将Cocoa的NSRunLoop类型转换成Core Foundation的CFRunLoopRef类型
        CFRunLoopRef cfRunLoop = [myRunLoop getCFRunLoop];
        //将新建的observer加入到当前thread的run loop
        CFRunLoopAddObserver(cfRunLoop, observer, kCFRunLoopDefaultMode);
    }
    
    //启动当前thread的loop直到所指定的时间到达，在loop运行时，run loop会处理所有来自与该run loop联系的input source的数据
    //对于本例与当前run loop联系的input source只有一个Timer类型的source。
    //该Timer每隔2.0秒发送触发事件给run loop，run loop检测到该事件时会调用相应的处理方法。
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(doFireTimer) userInfo:nil repeats:YES];
    
    while (YES) {
        SInt32 result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 2, YES);
        if (result == kCFRunLoopRunStopped) {
            NSLog(@"exit run loop.........: %d", (int)result);
            break ;
        }
    }
    
    NSLog(@"finishing thread.........");
}

- (void)doFireTimer
{
    DLog(@"doFireTimer...");
    loopCount--;
    if (loopCount < 0) {
        CFRunLoopStop(CFRunLoopGetCurrent());
    }
}

void myRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
            //The entrance of the run loop, before entering the event processing loop.
            //This activity occurs once for each call to CFRunLoopRun and CFRunLoopRunInMode
        case kCFRunLoopEntry:
            NSLog(@"run loop entry");
            break;
            //Inside the event processing loop before any timers are processed
        case kCFRunLoopBeforeTimers:
            NSLog(@"run loop before timers");
            break;
            //Inside the event processing loop before any sources are processed
        case kCFRunLoopBeforeSources:
            NSLog(@"run loop before sources");
            break;
            //Inside the event processing loop before the run loop sleeps, waiting for a source or timer to fire.
            //This activity does not occur if CFRunLoopRunInMode is called with a timeout of 0 seconds.
            //It also does not occur in a particular iteration of the event processing loop if a version 0 source fires
        case kCFRunLoopBeforeWaiting:
            NSLog(@"run loop before waiting");
            break;
            //Inside the event processing loop after the run loop wakes up, but before processing the event that woke it up.
            //This activity occurs only if the run loop did in fact go to sleep during the current loop
        case kCFRunLoopAfterWaiting:
            NSLog(@"run loop after waiting");
            break;
            //The exit of the run loop, after exiting the event processing loop.
            //This activity occurs once for each call to CFRunLoopRun and CFRunLoopRunInMode
        case kCFRunLoopExit:
            NSLog(@"run loop exit");
            break;
            /*
             A combination of all the preceding stages
             case kCFRunLoopAllActivities:
             break;
             */
        default:
            break;
    }
}

@end











