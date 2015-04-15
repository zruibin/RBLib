//
//  ViewController.m
//  RBLib
//
//  Created by zruibin on 15/4/1.
//  Copyright (c) 2015年 zruibin. All rights reserved.
//

#import "ViewController.h"
#import "RBMarco.h"

#import "RBChatTimeFormateTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    RBLog(@"RBLog...");
    RBLogMethod();
    
    NSTimeInterval time1970 = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeNow  = [[NSDate date] timeIntervalSinceNow];
    NSString *time1970Str = [RBChatTimeFormateTool getMessageDateStringFromTimeInterval:time1970 andNeedTime:YES];
    NSString *timeNowStr  = [RBChatTimeFormateTool getMessageDateStringFromTimeInterval:timeNow andNeedTime:YES];
    RBLog(@"time1970:%@", time1970Str);
    RBLog(@"timeNow:%@", timeNowStr);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end