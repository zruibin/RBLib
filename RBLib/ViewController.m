//
//  ViewController.m
//  RBLib
//
//  Created by zruibin on 15/4/1.
//  Copyright (c) 2015年 zruibin. All rights reserved.
//

#import "ViewController.h"
#import "RBMacros.h"
#import "RBChatTimeFormateTool.h"

#import "APRoundButton.h"

#import "ScrollHiddenBarVC.h"
#import "LifeCycle/LifeCycleViewController.h"

#import <pop/POP.h>
#import "ViewController+Test.h"

#import "TransitionAnimator.h"

#import "RBURLProtocol.h"


@interface ViewController () <UINavigationControllerDelegate>

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
    
    [self testAssociatedObject];
    
    self.navigationController.delegate = self;
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
    
    [self myLog:@"312",@"321", nil];//必须有nil
}

- (IBAction)testProtocolAction:(id)sender
{
    DLog(@"test Protocol....");
    
    NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    //MARK:
    /*
     对于NSURLSession的请求，注册NSURLProtocol的方式稍有不同，是通过NSURLSessionConfiguration注册的
     */
    configure.protocolClasses = @[[RBURLProtocol class]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configure];
    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"http://baidu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        DLog(@"response: %@", response);
    }];
    [task resume];
}


#pragma mark -- Object-C中编写省略参数的多参函数

- (void) myLog:(NSString *)str,...NS_REQUIRES_NIL_TERMINATION{//省略参数的写法
    
    va_list list;//创建一个列表指针对象
    va_start(list, str);//进行列表的初始化，第一个参数是va_list对象，第二个参数是参数列表的第一个参数。
    NSString * temStr = str;
    while (temStr!=nil) {//如果不是nil，则继续取值
        NSLog(@"%@",temStr);
        
        //一个用于取出参数的宏，这个宏的第一个参数是va_list对象，第二个参数是要取出的参数类型。
        temStr = va_arg(list, NSString*);//返回取到的值，并且让指针指向下一个参数的地址
    }
    va_end(list);//关闭列表指针
}

#pragma mark - UINavigationControllerDelegate iOS7新增的2个方法
// 动画特效
- (id<UIViewControllerAnimatedTransitioning>) navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    TransitionAnimator *animator = [[TransitionAnimator alloc] init];
    animator.operation = operation;
    if (operation == UINavigationControllerOperationPush) {
        return animator;
    } else if (operation == UINavigationControllerOperationPop) {
        return animator;
    } else{
        return nil;
    }
}

@end





 





