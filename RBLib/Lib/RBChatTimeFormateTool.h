//
//  RBChatTimeFormateTool.h
//  RBLib
//
//  Created by zruibin on 15/4/1.
//  Copyright (c) 2015年 zruibin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *
 需求详细：
 
 外层选择界面
 
 ·今天显示格式    11：11
 ·昨天显示格式    昨天
 ·一星期内          星期X
 ·一星期前         2015/1/10
 
 聊天界面
 
 ·今天显示格式    11：11
 ·昨天显示格式    昨天 11：11
 ·一星期内       星期X 11：11
 ·一星期前       2015/1/10 11：11
 
 
 实现方法：
 
 主要需要了解NSDateFormatter，NSCalendar，NSDateComponents这三个类的功能
 */
@interface RBChatTimeFormateTool : NSObject



+(NSString *)getMessageDateStringFromTimeInterval:(NSTimeInterval)TimeInterval andNeedTime:(BOOL)needTime;

@end
