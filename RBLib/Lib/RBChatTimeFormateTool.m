//
//  RBChatTimeFormateTool.m
//  RBLib
//
//  Created by zruibin on 15/4/1.
//  Copyright (c) 2015年 zruibin. All rights reserved.
//

#import "RBChatTimeFormateTool.h"

@interface RBChatTimeFormateTool ()

+ (NSString*)getMessageDateString:(NSDate*)messageDate andNeedTime:(BOOL)needTime;
+(NSString *)getWeekdayWithNumber:(NSInteger)number;

@end

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


//苹果官方不推荐使用week
//NSLog(@"week(该年第几周):%i", dateComponents.week);
//NSLog(@"weekOfYear(该年第几周):%i", dateComponents.weekOfYear);
//NSLog(@"weekOfMonth(该月第几周):%i", dateComponents.weekOfMonth);
+ (NSString *)stringFrom1970TimeInterval:(NSString *)timeInterval
{
    long long time = [timeInterval longLongValue];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
                                                         NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond |
                                                         NSCalendarUnitWeekday)
                                               fromDate:timeDate
                                                 toDate:[NSDate date]
                                                options:0];
    if ([components year] != 0) {
        return [NSString stringWithFormat:@"%ld年前", (long)[components year]];
    }
    else if ([components month] != 0) {
        return [NSString stringWithFormat:@"%ld个月前", (long)[components month]];
    }
    else if ([components weekOfMonth] != 0) {
        return [NSString stringWithFormat:@"%ld周前", (long)[components weekOfMonth]];
    }
    else if ([components day] != 0) {
        return [NSString stringWithFormat:@"%ld天前", (long)[components day]];
    }
    else if ([components hour] != 0) {
        return [NSString stringWithFormat:@"%ld小时前", (long)[components hour]];
    }
    else if ([components minute] != 0) {
        return [NSString stringWithFormat:@"%ld分钟前", (long)[components minute]];
    }
    else {
        return @"刚刚";
    }
    
    return nil;
}

@end
