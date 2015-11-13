//
//  UIImage+Hook.m
//  RBLib
//
//  Created by zhouruibin on 15/11/13.
//  Copyright © 2015年 zruibin. All rights reserved.
//

#import "UIImage+Hook.h"
#import <objc/objc.h>
#import <objc/runtime.h>

@implementation UIImage (Hook)

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self adeanImageHook];
    });
}

+ (void)adeanImageHook
{
    [self imageNameHook];
}

+ (void)imageNameHook  // 类方法调用方式
{
    Class class = object_getClass((id)self);
    SEL originalSelector = @selector(imageNamed:);
    SEL swizzledSelector = @selector(adean_imageNamed:);
    
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod)
    {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (UIImage *)adean_imageNamed:(NSString *)name
{
    UIImage *image = [self adean_imageNamed:name];
    [self printImageNameToLocalWithImageName:name];
    return image;
}

+ (void)printImageNameToLocalWithImageName:(NSString *)name
{
#ifdef DEBUG
    {
        // 打印图片地址
        NSLog(@"adean_msg->imagefile: %@.png", name);
//        FILE *fp;
//        const char *imageFilePath =[name UTF8String];
//        const char *cImageName = [[NSString stringWithFormat:@"%@\n", name] UTF8String];
//        /*打开文件*/
//        if((fp = fopen(imageFilePath, "a")) == NULL)
//        {
//            NSLog(@"文件打开出错，请检查文件是否存在\n");
//        }
//        else
//        {
//        }
//        fputs(cImageName,fp);
//        fclose(fp);
    }
#endif
}



@end



