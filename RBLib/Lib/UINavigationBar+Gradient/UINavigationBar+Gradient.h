//
//  UINavigationBar+Gradient.h
//  AnimationDemo
//
//  Created by zruibin on 15/4/21.
//  Copyright (c) 2015年 RBCHOW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Gradient)

- (void)rb_setBackgroundColor:(UIColor *)backgroundColor;
- (void)rb_setContentAlpha:(CGFloat)alpha;
- (void)rb_setTranslationY:(CGFloat)translationY;
- (void)rb_reset;

@end
