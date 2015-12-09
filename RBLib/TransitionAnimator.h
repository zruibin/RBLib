//
//  TransitionAnimator.h
//  RBLib
//
//  Created by zhouruibin on 15/12/9.
//  Copyright © 2015年 zruibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property(nonatomic, assign) UINavigationControllerOperation operation;

@end
