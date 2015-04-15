//
//  UIImage+CircleRadius.h
//  Aipai
//
//  Created by zruibin on 15/4/14.
//  Copyright (c) 2015年 www.aipai.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CircleRadius)

- (UIImage *)circleCorner;



- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end
