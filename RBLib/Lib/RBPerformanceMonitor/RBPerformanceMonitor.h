//
//  RBPerformanceMonitor.h
//  RBLib
//
//  Created by zruibin on 15/11/25.
//  Copyright © 2015年 RBCHOW. All rights reserved.
//

/*
 http://www.tanhao.me/code/151113.html/
 */

#import <Foundation/Foundation.h>

@interface RBPerformanceMonitor : NSObject

+ (instancetype)sharedInstance;

- (void)start;
- (void)stop;

@end
