//
//  RBChatTimeFormateTool.h
//  RBLib
//
//  Created by zruibin on 15/4/1.
//  Copyright (c) 2015年 zruibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBChatTimeFormateTool : NSObject


/**
 *  
 需求详细：
 
 外层选择界面
 
 ·今天显示格式    11：11
 ·昨天显示格式    昨天
 ·一星期内       星期X
 ·一星期前       2015/1/10
 
 聊天界面
 
 ·今天显示格式    11：11
 ·昨天显示格式    昨天 11：11
 ·一星期内       星期X 11：11
 ·一星期前       2015/1/10 11：11
 
 实现方法：
 
 主要需要了解NSDateFormatter，NSCalendar，NSDateComponents这三个类的功能

 *
 *  @param TimeInterval 时间戳
 *  @param needTime     是否精确到时与分
 *
 *  @return 时间戳的聊天显示形式字符串
 */
+(NSString *)getMessageDateStringFromTimeInterval:(NSTimeInterval)TimeInterval andNeedTime:(BOOL)needTime;


+ (NSString *)stringFrom1970TimeInterval:(NSString *)timeInterval;

/**
 *  判断是否为当天
 *
 *  @param date  新的时间
 *  @param toDate 旧的时间
 *
 *  @return 0 为当天
 */
+ (NSInteger)daysSinceReferenceDate:(NSDate *)date toDate:(NSDate *)toDate;

@end
