//
//  RBChatTimeFormateTool.m
//  RBLib
//
//  Created by zruibin on 15/4/1.
//  Copyright (c) 2015年 zruibin. All rights reserved.
//

#import "RBChatTimeFormateTool.h"

@implementation RBChatTimeFormateTool


+(NSString *)getMessageDateStringFromTimeInterval:(NSTimeInterval)TimeInterval andNeedTime:(BOOL)needTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:TimeInterval];
    return [RBChatTimeFormateTool getMessageDateString:date andNeedTime:needTime];
}

+ (NSString*)getMessageDateString:(NSDate*)messageDate andNeedTime:(BOOL)needTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:messageDate];
//    NSDateComponents *components = [cal component:NSCalendarUnitEra fromDate:messageDate];
    NSDate *msgDate = [cal dateFromComponents:components];
    
    NSString *weekday = [RBChatTimeFormateTool getWeekdayWithNumber:components.weekday];
    
    components = [cal components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    
    if([today isEqualToDate:msgDate]){
        if (needTime) {
            [formatter setDateFormat:@"今天 HH:mm"];
        }
        else{
            [formatter setDateFormat:@"今天"];
        }
        return [formatter stringFromDate:messageDate];
    }
    
    components.day -= 1;
    NSDate *yestoday = [cal dateFromComponents:components];
    if([yestoday isEqualToDate:msgDate]){
        if (needTime) {
            [formatter setDateFormat:@"昨天 HH:mm"];
        }
        else{
            [formatter setDateFormat:@"昨天"];
        }
        return [formatter stringFromDate:messageDate];
    }
    
    for (int i = 1; i <= 6; i++) {
        components.day -= 1;
        NSDate *nowdate = [cal dateFromComponents:components];
        if([nowdate isEqualToDate:msgDate]){
            if (needTime) {
                [formatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm",weekday]];
            }
            else{
                [formatter setDateFormat:[NSString stringWithFormat:@"%@",weekday]];
            }
            return [formatter stringFromDate:messageDate];
        }
    }
    
    while (1) {
        components.day -= 1;
        NSDate *nowdate = [cal dateFromComponents:components];
        if ([nowdate isEqualToDate:msgDate]) {
            if (!needTime) {
                [formatter setDateFormat:@"YYYY/MM/dd"];
            }
            return [formatter stringFromDate:messageDate];
            break;
        }
    }
}

//1代表星期日、如此类推
+(NSString *)getWeekdayWithNumber:(NSInteger)number
{
    switch (number) {
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            return @"";
            break;
    }
}



@end
