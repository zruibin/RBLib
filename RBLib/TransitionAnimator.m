//
//  TransitionAnimator.m
//  RBLib
//
//  Created by zhouruibin on 15/12/9.
//  Copyright © 2015年 zruibin. All rights reserved.
//

#import "TransitionAnimator.h"

@implementation TransitionAnimator

// 系统给出一个切换上下文，我们根据上下文环境返回这个切换所需要的花费时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

// 完成容器转场动画的主要方法，我们对于切换时的UIView的设置和动画都在这个方法中完成
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 可以看做为destination ViewController
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // 可以看做为source ViewController
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    // 添加toView到容器上
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0.0;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        // 动画效果有很多
        if (self.operation == UINavigationControllerOperationPush) {
            fromViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);//CGAffineTransformMakeTranslation(-320, 0);
        } else {
            fromViewController.view.transform = CGAffineTransformMakeRotation(2.5);
        }
        toViewController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        // 声明过渡结束-->记住，一定别忘了在过渡结束时调用 completeTransition: 这个方法
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
