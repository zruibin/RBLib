//
//  RBMarco.h
//  RBLib
//
//  Created by zruibin on 15/4/1.
//  Copyright (c) 2015年 zruibin. All rights reserved.
//

#ifndef RBLib_RBMarco_h
#define RBLib_RBMarco_h

#define _DEBUG 1
#ifdef	_DEBUG

//#define RBLog(...);	NSLog(__VA_ARGS__);
#define	RBLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define RBLogMethod()	NSLog(@"[%s] %@", class_getName([self class]), NSStringFromSelector(_cmd));
#define RBLogPoint(point)  NSLog(@"%f,%f", point.x, point.y);
#define RBLogSize(size)   NSLog(@"%f,%f", size.width, size.height);
#define RBLogRect(rect)   NSLog(@"%f,%f %f,%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);

#else

#define RBLog(...);
#define RBLogMethod()
#define RBLogPoint(point)
#define RBLogSize(size)
#define RBLogRect(rect)

#endif

#pragma mark ---log  flag

#define LogFrame(frame) NSLog(@"frame[X=%.1f,Y=%.1f,W=%.1f,H=%.1f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height)
#define LogPoint(point) NSLog(@"Point[X=%.1f,Y=%.1f]",point.x,point.y)

#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#endif

//#define SAFE_FREE(p) { if(p) { free(p); (p)=NULL; } }

//#pragma mark ---- AppDelegate
////AppDelegate
//#define APPDELEGATE [(AppDelegate*)[UIApplication sharedApplication]  delegate]
//UIApplication
#define APPD  [UIApplication sharedApplication]
#define rootNavVC (UINavigationController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController]

#define isPad  ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define isiPhone5 ([[UIScreen mainScreen]bounds].size.height == 568)

#pragma mark ---- String  functions
#define EMPTY_STRING        @""
#define STR(key)            NSLocalizedString(key, nil)


#pragma mark ---- UIImage  UIImageView  functions
#define IMG(name) [UIImage imageNamed:name]
#define IMGF(name) [UIImage imageNamedFixed:name]

#pragma mark ---- File  functions
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


#pragma mark ---- color functions
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HEXCOLORRGB(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
#define HEXCOLORRGBA(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:(a)]


#pragma mark ----Size ,X,Y, View ,Frame
//get the  size of the Screen
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT_SCALE  ([[UIScreen mainScreen] bounds].size.height/480.0)

//get the  size of the Application
#define APP_HEIGHT [[UIScreen mainScreen] applicationFrame].size.height
#define APP_WIDTH  [[UIScreen mainScreen] applicationFrame].size.width

#define APP_SCALE_H  ([[UIScreen mainScreen] applicationFrame].size.height/480.0)
#define APP_SCALE_W  ([[UIScreen mainScreen] applicationFrame].size.width/320.0)

//get the left top origin's x,y of a view
#define VIEW_TX(view) (view.frame.origin.x)
#define VIEW_TY(view) (view.frame.origin.y)

//get the width size of the view:width,height
#define VIEW_W(view)  (view.frame.size.width)
#define VIEW_H(view)  (view.frame.size.height)

//get the right bottom origin's x,y of a view
#define VIEW_BX(view) (view.frame.origin.x + view.frame.size.width)
#define VIEW_BY(view) (view.frame.origin.y + view.frame.size.height )

//get the x,y of the frame
#define FRAME_TX(frame)  (frame.origin.x)
#define FRAME_TY(frame)  (frame.origin.y)
//get the size of the frame
#define FRAME_W(frame)  (frame.size.width)
#define FRAME_H(frame)  (frame.size.height)

#define DistanceFloat(PointA,PointB) sqrtf((PointA.x - PointB.x) * (PointA.x - PointB.x) + (PointA.y - PointB.y) * (PointA.y - PointB.y))


#endif
