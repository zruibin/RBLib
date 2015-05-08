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
#import "SDBrowserImageView.h"
#import "APRoundButton.h"

#import "ScrollHiddenBarVC.h"
#import "LifeCycle/LifeCycleViewController.h"

#import <pop/POP.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet APRoundButton *popAnimation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    DLog(@"RBLog...");
    DLogMethod();
    
    NSTimeInterval time1970 = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeNow  = [[NSDate date] timeIntervalSinceNow];
    NSString *time1970Str = [RBChatTimeFormateTool getMessageDateStringFromTimeInterval:time1970 andNeedTime:YES];
    NSString *timeNowStr  = [RBChatTimeFormateTool getMessageDateStringFromTimeInterval:timeNow andNeedTime:YES];
    DLog(@"time1970:%@", time1970Str);
    DLog(@"timeNow:%@", timeNowStr);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gradientBarAction:(id)sender {
    ScrollHiddenBarVC *vc = [[ScrollHiddenBarVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)popAnimationEvent:(id)sender {
    
    POPSpringAnimation *animation = [POPSpringAnimation animation];
    animation.property = [POPAnimatableProperty propertyWithName:kPOPLayerTranslationY];
    animation.fromValue = @-15.0;
    animation.toValue = @0.0;
    animation.springBounciness = 30.0;
    animation.springSpeed = 12.0;
    [self.popAnimation.layer pop_addAnimation:animation forKey:@"pop"];
}

//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    // Called just before the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
//    NSLog(@"viewWillLayoutSubviews");
//}
//
//- (void)updateViewConstraints
//{
//    NSLog(@"updateViewConstraints...");
//    [super updateViewConstraints];
//}


@end


// MARK: 
/**
 要开始使用AutoLayout，请先设置要约束的view的translatesAutoresizingMaskIntoConstraints属性为NO。
 在xib或者sb中勾选Use Auto Layout，那么所有在xib或者sb中出现的view都已经默认将translatesAutoresizingMaskIntoConstraints设置为NO
 */


 





