//
//  RBUtil.h
//  RBLib
//
//  Created by zruibin on 15/7/22.
//  Copyright (c) 2015年 zruibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RBUtil : NSObject

+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
