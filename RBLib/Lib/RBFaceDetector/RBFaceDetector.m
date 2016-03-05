//
//  RBFaceDetector.m
//  RBLib
//
//  Created by zruibin on 16/3/5.
//  Copyright © 2016年 zruibin. All rights reserved.
//

#import "RBFaceDetector.h"
#import <QuartzCore/QuartzCore.h>

@implementation RBFaceDetector

#pragma mark - Private

+ (CIFaceFeature *)bestFaceFeaturesInFeatherArray:(NSArray *)featureArray {
    //get the bestFaceFeature by the maxnum bounds Square size
    CGFloat maxFaceSquare = 0.0;
    CIFaceFeature * chooseFaceFeature = nil;
    for (CIFaceFeature * faceFeathre in featureArray) {
        CGRect bounds = faceFeathre.bounds;
        CGFloat  currentFaceSqu = CGRectGetWidth(bounds)*CGRectGetHeight(bounds);
        if (currentFaceSqu > maxFaceSquare) {
            maxFaceSquare = currentFaceSqu;
            chooseFaceFeature = faceFeathre;
        }
    }
    return chooseFaceFeature;
}

+ (CGSize)acceptableSize:(CGSize)size maxSize:(CGSize)maxSize {
    CGFloat xScale = size.width / maxSize.width;
    CGFloat yScale = size.height / maxSize.height;
    CGFloat maxScale = MAX(xScale, yScale);
    if (maxScale > 1.0) {
        return CGSizeMake(size.width/maxScale, size.height/maxScale);
    }
    return size;
}

+ (CGSize)bestImgSizeForFaceFrame:(CGRect)faceFrame imgSize:(CGSize)imgSize {
    CGFloat xScale = faceFrame.size.width/imgSize.width;
    CGFloat yScale = faceFrame.size.height/imgSize.height;
    CGFloat maxScale = MAX(xScale, yScale);
    if (maxScale > 1.0) {
        return CGSizeMake(imgSize.width*maxScale, imgSize.height*maxScale);
    }
    return imgSize;
}

+ (CGRect)frameForSuggestSize:(CGSize)imgSize faceFrame:(CGRect)faceFrame imageFrame:(CGRect)imgFrame {
    imgSize = [self bestImgSizeForFaceFrame:faceFrame imgSize:imgSize];
    CGSize acceptableImgSize = [self acceptableSize:imgSize maxSize:imgFrame.size];
    CGPoint faceCenter = CGPointMake(CGRectGetMidX(faceFrame), CGRectGetMidY(faceFrame));
    CGFloat xPos = faceCenter.x >= acceptableImgSize.width/2.0 ? (faceCenter.x-acceptableImgSize.width/2.0) : 0.0;
    CGFloat yPos = faceCenter.y >= acceptableImgSize.height/2.0 ? (faceCenter.y-acceptableImgSize.height/2.0) : 0.0;
    return CGRectMake(xPos, yPos, acceptableImgSize.width, acceptableImgSize.height);
}

+ (CGRect)centerFrameForSize:(CGSize)size inFrame:(CGRect)frame {
    CGSize acceptableImgSize = [self acceptableSize:size maxSize:frame.size];
    CGFloat xPos = (frame.size.width-acceptableImgSize.width)/2.0;
    CGFloat yPos = (frame.size.height-acceptableImgSize.height)/2.0;
    return CGRectMake(xPos, yPos, size.width, size.height);
}

+ (UIImage *)normalizedImage:(UIImage *)img {
    if (img.imageOrientation == UIImageOrientationUp) return img;
    
    UIGraphicsBeginImageContextWithOptions(img.size, NO, img.scale);
    [img drawInRect:(CGRect){0, 0, img.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}
#pragma mark - Interface

+ (void)getImageWithFaceForImage:(UIImage *)image withSize:(CGSize)imgSize shouldFast:(BOOL)shouldFastDetect completionHandler:(void (^)(UIImage * imgWithFace))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block UIImage * img = [self normalizedImage:image];
        if (img) {
            CIImage *ciImage = [[CIImage alloc] initWithImage:img];
            NSString *accuracy = shouldFastDetect ? CIDetectorAccuracyLow : CIDetectorAccuracyHigh;
            NSDictionary *options = [NSDictionary dictionaryWithObject:accuracy forKey:CIDetectorAccuracy];
            CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
            NSArray *featuresArray = [detector featuresInImage:ciImage];
            CIFaceFeature * choosenFaceFeature = [self bestFaceFeaturesInFeatherArray:featuresArray];
            if (choosenFaceFeature) {
                CGRect bounds = [choosenFaceFeature bounds];
                CGFloat xPos = bounds.origin.x;
                CGFloat yPos = img.size.height - bounds.origin.y - bounds.size.height;
                CGRect faceFrame = CGRectMake(xPos, yPos, bounds.size.width, bounds.size.height);
                CGRect fixedFrame = [self frameForSuggestSize:imgSize faceFrame:faceFrame imageFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
                CGImageRef subImageRef = CGImageCreateWithImageInRect(img.CGImage, fixedFrame);
                UIImage * resultImg = [UIImage imageWithCGImage:(__bridge CGImageRef)CFBridgingRelease(subImageRef)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(resultImg);
                });
            }else {
                CGRect centerFrame = [self centerFrameForSize:imgSize inFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
                CGImageRef subImageRef = CGImageCreateWithImageInRect(img.CGImage, centerFrame);
                UIImage * resultImg = [UIImage imageWithCGImage:(__bridge CGImageRef)CFBridgingRelease(subImageRef)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(resultImg);
                });
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil);
            });
        }
    });
    
}

+ (void)getImageWithFaceForImage:(UIImage *)image withSize:(CGSize)imgSize completionHandler:(void (^)(UIImage * imgWithFace))completion {
    [self getImageWithFaceForImage:image withSize:imgSize shouldFast:NO completionHandler:completion];
}

@end
