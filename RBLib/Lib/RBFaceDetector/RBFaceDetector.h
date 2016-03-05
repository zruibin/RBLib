//
//  RBFaceDetector.h
//  RBLib
//
//  Created by zruibin on 16/3/5.
//  Copyright © 2016年 zruibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RBFaceDetector : NSObject

+ (void)getImageWithFaceForImage:(UIImage *)image withSize:(CGSize)imgSize shouldFast:(BOOL)shouldFastDetect completionHandler:(void (^)(UIImage * imgWithFace))completion;

+ (void)getImageWithFaceForImage:(UIImage *)image withSize:(CGSize)imgSize completionHandler:(void (^)(UIImage * imgWithFace))completion;

@end
