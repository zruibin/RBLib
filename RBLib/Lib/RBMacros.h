//
//  RBMacros.h
//  RBLib
//
//  Created by zruibin on 15/4/1.
//  Copyright (c) 2015年 zruibin. All rights reserved.
//

#ifndef RBLib_RBMacros_h
#define RBLib_RBMacros_h

#ifdef	DEBUG

//#define DLog(...);	NSLog(__VA_ARGS__);
#define	DLog(FORMAT, ...) fprintf(stderr,"[%s:%d]\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define DLogMethod()	 DLog(@"[%s] %@", class_getName([self class]), NSStringFromSelector(_cmd));
#define DLogPoint(point) DLog(@"%f,%f", point.x, point.y);
#define DLogSize(size)   DLog(@"%f,%f", size.width, size.height);
#define DLogRect(rect)   DLog(@"%f,%f %f,%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);

#else

#define DLog(...);
#define DLogMethod()
#define DLogPoint(point)
#define DLogSize(size)
#define DLogRect(rect)

#endif

#pragma mark ---objc_arc

#if __has_feature(objc_arc)
#define __AUTORELEASE(x)   (x)
#define __RELEASE(x)       (x) = nil;
#define __RETAIN(x)        (x)
#define __SUPER_DEALLOC    ;
#else
#define __RETAIN(x)      [(x) retain];
#define __AUTORELEASE(x) [(x) autorelease];

#define __RELEASE(x) \
if(nil != (x)) \
{\
[(x) release];\
(x) = nil;\
}
#define __SUPER_DEALLOC    [super dealloc];
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

#pragma mark --- 用宏在category里给对象添加属性

// eg: _PROPERTY_ASSOCIATEDOBJECT(UIButton *, downloadBtn, strong);
#define _PROPERTY_ASSOCIATEDOBJECT( __type, __name, __association_type)  \
            @property (nonatomic, __association_type, setter=set__##__name:, getter=__##__name) __type __name;

//在申明属性的时候用setter来修改属性的set方法,在前面加 __ 避开大小写.
// eg: _MAKE_ASSOCIATEDOBJECT(UIButton *, downloadBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
#define _MAKE_ASSOCIATEDOBJECT( __type, __name, __association_type)  \
            @dynamic __name;  \
            \
            - (__type)__##__name   \
            {   \
                const char * propName = #__name; \
                __type name = objc_getAssociatedObject(self, propName);    \
                return name; \
            }   \
            \
            - (void)set__##__name:(__type)__name   \
            { \
                const char * propName = #__name;    \
                objc_setAssociatedObject(self, propName, __name, __association_type); \
            }


/*
 // 宏定义之前的用法
 if (completionBlock)
 {
    completionBlock(arg1, arg2);
 }

// 宏定义之后的用
BLOCK_EXEC(completionBlock, arg1, arg2);
 */
#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


//waitForExpectationsWithTimeout是等待时间，超过了就不再等待往下执行。
#define RB_TEST_WAIT do {  \
    [self expectationForNotification:@"RBBaseTest" object:nil handler:nil]; \
    [self waitForExpectationsWithTimeout:30 handler:nil]; \
} while (0);

#define RB_TEST_NOTIFY  \
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RBBaseTest" object:nil];


#pragma mark --- 序列化与反序列集成方案

/*
 *  (CN)本文件提供iOS下的序列化与反序列集成方案，几行代码即可轻松实现。
 *  在传统方式中当你需要对某个对象进行序列化与反序列化时，往往需要实现<NSCoding>协议以及<NSCopying>协议(非必须)，
 *  在协议方法中对需要序列化的变量执行encode&decode操作。当变量较多并且需要序列化的自定义对象较多时容易出现过多冗余代码，稍有不慎容易出错。
 *  RBSerializeKit在运行时对类以及所有层级父类的变量进行遍历，避免遗漏。属性越多，优势越明显。
 */

#define RBSERIALIZE_CODER_DECODER()     \
\
- (id)initWithCoder:(NSCoder *)coder    \
{   \
    DLog(@"%s",__func__);  \
    Class cls = [self class];   \
    while (cls != [NSObject class]) {   \
        /*判断是自身类还是父类*/    \
        BOOL bIsSelfClass = (cls == [self class]);  \
        unsigned int iVarCount = 0; \
        unsigned int propVarCount = 0;  \
        unsigned int sharedVarCount = 0;    \
        Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/   \
        objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/   \
        sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;   \
        \
        for (int i = 0; i < sharedVarCount; i++) {  \
            const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
            NSString *key = [NSString stringWithUTF8String:varName];   \
            id varValue = [coder decodeObjectForKey:key];   \
            if (varValue) { \
                [self setValue:varValue forKey:key];    \
            }   \
        }   \
        free(ivarList); \
        free(propList); \
        cls = class_getSuperclass(cls); \
    }   \
    return self;    \
}   \
\
- (void)encodeWithCoder:(NSCoder *)coder    \
{   \
    DLog(@"%s",__func__);  \
    Class cls = [self class];   \
    while (cls != [NSObject class]) {   \
        /*判断是自身类还是父类*/    \
        BOOL bIsSelfClass = (cls == [self class]);  \
        unsigned int iVarCount = 0; \
        unsigned int propVarCount = 0;  \
        unsigned int sharedVarCount = 0;    \
        Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/   \
        objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/ \
        sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;   \
        \
        for (int i = 0; i < sharedVarCount; i++) {  \
            const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
            NSString *key = [NSString stringWithUTF8String:varName];    \
            /*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/  \
            id varValue = [self valueForKey:key];   \
            if (varValue) { \
                [coder encodeObject:varValue forKey:key];   \
            }   \
        }   \
        free(ivarList); \
        free(propList); \
        cls = class_getSuperclass(cls); \
    }   \
}


#define RBSERIALIZE_COPY_WITH_ZONE()  \
\
/*如果不实现copyWithZone:方法，则[personObject copy]时会崩溃*/   \
- (id)copyWithZone:(NSZone *)zone   \
{   \
    DLog(@"%s",__func__);  \
    id copy = [[[self class] allocWithZone:zone] init];    \
    Class cls = [self class];   \
    while (cls != [NSObject class]) {  \
        /*判断是自身类还是父类*/    \
        BOOL bIsSelfClass = (cls == [self class]);  \
        unsigned int iVarCount = 0; \
        unsigned int propVarCount = 0;  \
        unsigned int sharedVarCount = 0;    \
        Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/   \
        objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/   \
        sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;   \
        \
        for (int i = 0; i < sharedVarCount; i++) {  \
            const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
            NSString *key = [NSString stringWithUTF8String:varName];    \
            /*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/  \
            id varValue = [self valueForKey:key];   \
            if (varValue) { \
                [copy setValue:varValue forKey:key];    \
            }   \
        }   \
        free(ivarList); \
        free(propList); \
        cls = class_getSuperclass(cls); \
    }   \
    return copy;    \
}


#define RBSERIALIZE_DESCRIPTION() \
\
/* 用来打印本类的所有变量(成员变量+属性变量)，所有层级父类的属性变量及其对应的值 */  \
- (NSString *)description   \
{   \
    NSString  *despStr = @"";   \
    Class cls = [self class];   \
    while (cls != [NSObject class]) {   \
        /*判断是自身类还是父类*/  \
        BOOL bIsSelfClass = (cls == [self class]);  \
        unsigned int iVarCount = 0; \
        unsigned int propVarCount = 0;  \
        unsigned int sharedVarCount = 0;    \
        Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/   \
        objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/   \
        sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;   \
        \
        for (int i = 0; i < sharedVarCount; i++) {  \
            const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
            NSString *key = [NSString stringWithUTF8String:varName];    \
            /*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/  \
            id varValue = [self valueForKey:key];   \
            if (varValue) { \
                despStr = [despStr stringByAppendingString:[NSString stringWithFormat:@"%@: %@\n", key, varValue]]; \
            }   \
        }   \
        free(ivarList); \
        free(propList); \
        cls = class_getSuperclass(cls); \
    }   \
    return despStr; \
}


/* 封装归档keyedArchiver操作 */
#define RBSERIALIZE_ARCHIVE(__objToBeArchived__, __key__, __filePath__)    \
\
NSMutableData *data = [NSMutableData data]; \
NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];   \
[archiver encodeObject:__objToBeArchived__ forKey:__key__];    \
[archiver finishEncoding];  \
[data writeToFile:__filePath__ atomically:YES]


/* 封装反归档keyedUnarchiver操作 */
#define RBSERIALIZE_UNARCHIVE(__objToStoreData__, __key__, __filePath__)   \
NSMutableData *dedata = [NSMutableData dataWithContentsOfFile:__filePath__]; \
NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dedata];  \
__objToStoreData__ = [unarchiver decodeObjectForKey:__key__];  \
[unarchiver finishDecoding]













#endif





