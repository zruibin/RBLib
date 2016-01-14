//
//  SwizzlingController.m
//  RBLib
//
//  Created by zhouruibin on 16/1/13.
//  Copyright © 2016年 RBCHOW. All rights reserved.
//

#import "SwizzlingController.h"
#import <objc/runtime.h>

#import "RBMacros.h"
#import "UIImage+RBImage.h"

@interface SwizzlingController ()

@end

@implementation SwizzlingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(void)load
{
    SEL origin = @selector(original);
    SEL swizzling = @selector(swizzling);
    swizzlingInstanceMethod([self class], origin, swizzling);
   
    SEL originalT = @selector(originalT);
    SEL swizzlingT = @selector(swizzlingT);
    Class class = object_getClass((id)self); /*类方法置换*/
    swizzlingClassMethod(class, originalT, swizzlingT);
}


- (IBAction)saveScreenAction:(id)sender
{
    [self ScreenShot];
}

- (IBAction)instanceSwizzlingAction:(id)sender
{
    [self original];
}

- (IBAction)classSwizzlingAction:(id)sender
{
    [[self class] originalT];
}



- (void)original
{
    DLog(@"original....");
}

- (void)swizzling
{
    [self swizzling];
   DLog(@"swizzling....");
}


+ (void)originalT
{
    DLog(@"original T ....");
}

+ (void)swizzlingT
{
    [[self class] swizzlingT];
    DLog(@"swizzling T ....");
}


#pragma mark -


void swizzlingClassMethod(Class cls, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getClassMethod(cls, originalSelector);
    Method swizzledMethod = class_getClassMethod(cls, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(cls, originalSelector,
                                                                method_getImplementation(swizzledMethod),
                                                                method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}


void swizzlingInstanceMethod(Class cls, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(cls, originalSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


#pragma mark -=====自定义截屏位置大小的逻辑代码=====-

static int ScreenshotIndex=0; //这里的逻辑直接采用上面博主的逻辑了

-(void)ScreenShot
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);     //设置截屏大小

    [[[UIApplication sharedApplication].keyWindow layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
//    UIGraphicsEndImageContext();
//    CGImageRef imageRef = viewImage.CGImage;
//    //    CGRect rect = CGRectMake(166, 211, 426, 320);//这里可以设置想要截图的区域
//    CGRect rect = CGRectMake(0, 0, size.width, size.height);//这里可以设置想要截图的区域
//    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
//    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    /*模糊效果*/
    viewImage = [viewImage blurFilterImage];
    
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//保存图片到照片库
    
//    NSData *imageViewData = UIImagePNGRepresentation(sendImage);
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *pictureName= [NSString stringWithFormat:@"screenShow_%d.png",ScreenshotIndex];
//    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:pictureName];
    
//    NSLog(@"截屏路径打印: %@", savedImagePath);
    
//    [imageViewData writeToFile:savedImagePath atomically:YES];//保存照片到沙盒目录
    
//    CGImageRelease(imageRefRect);
    
    /*图片上下文开启后要有关闭操作，否则，会由于来自于绘图和位图的创建的内存没释放而导致内存逐渐变大*/
    UIGraphicsEndImageContext();
    
    ScreenshotIndex++;
}

@end

