//
//  UIView+Material.h
//  RBLib
//
//  Created by zuibin on 15/11/27.
//  Copyright © 2015年 RBCHOW. All rights reserved.
//

/*
    https://github.com/moqod/ios-material-design
 */

#import <UIKit/UIKit.h>

#define DEFAULT_COLOR [UIColor colorWithRed:((float)((0xFAFAFA & 0xFF0000) >> 16))/255.0 green:((float)((0xFAFAFA & 0xFF00) >> 8))/255.0 blue:((float)(0xFAFAFA & 0xFF))/255.0 alpha:(0.6f)]
#define DEFAULT_DURATION 1.0f

@interface UIView (Material)

/**
 These methods animate background color of a view using shape animation.
 */
- (void)mdInflateAnimatedFromPoint:(CGPoint)point
                             backgroundColor:(UIColor *)backgroundColor
                                           duration:(NSTimeInterval)duration
                                            filling:(BOOL)filling
                                       completion:(void (^)(void))block;
- (void)mdDeflateAnimatedToPoint:(CGPoint)point
                           backgroundColor:(UIColor *)backgroundColor
                                         duration:(NSTimeInterval)duration
                                        filling:(BOOL)filling
                                     completion:(void (^)(void))block;


/**
 Some notes:
 - original point in fromView coordinate system
 - transition uses fromView.superview as containerView
 - transition set toView frame equal to fromView frame
 - transtion uses duration * 0.65 for shape transition and (duration - duration * 0.65) for fade animation, change it if you want
 */
+ (void)mdInflateTransitionFromView:(UIView *)fromView
                             toView:(UIView *)toView
                      originalPoint:(CGPoint)originalPoint
                           duration:(NSTimeInterval)duration
                         completion:(void (^)(void))block;

+ (void)mdDeflateTransitionFromView:(UIView *)fromView
                             toView:(UIView *)toView
                      originalPoint:(CGPoint)originalPoint
                           duration:(NSTimeInterval)duration
                         completion:(void (^)(void))block;

@end
