//
//  UIImage+RBImage.h
//  RBLib
//
//  Created by zruibin on 16/1/12.
//  Copyright © 2016年 zruibin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RBImageType) {
    RBImageTypeNone,
    RBImageTypePNG,
    RBImageTypeJPEG,
    RBImageTypeGIF,
    RBImageTypeTIFF,
    RBImageTypeWEBP
};

@interface UIImage (RBImage)

- (UIImage*)circleImage:(UIImage*)image withParam:(CGFloat) inset;

- (UIImage *)circleCorner;

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;

+ (UIImage*)createImageWithColor:(UIColor*)color;

- (UIImage *)blurFilterImage;
- (UIImage *)blurFilterImageWithInputRadius:(CGFloat)inputRadius;

@end
