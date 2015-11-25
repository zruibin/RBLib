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

@end











