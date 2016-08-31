//
//  RBStackDump.h
//  RBLib
//
//  Created by Ruibin.Chow on 16/8/26.
//  Copyright © 2016年 zruibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBStackDump : NSObject

+ (instancetype)sharedInstance;

+ (NSString *)backtraceOfAllThread;
+ (NSString *)backtraceOfCurrentThread;
+ (NSString *)backtraceOfMainThread;
+ (NSString *)backtraceOfNSThread:(NSThread *)thread;

@end
