//
//  RBPerformanceMonitor.h
//  RBLib
//
//  Created by Ruibin.Chow on 15/11/25.
//  Copyright © 2015年 Ruibin.Chow All rights reserved.
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
