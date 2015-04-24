//
//  APRoundButton.h
//  APCustomButton
//
//  Created by xiewei on 15/4/15.
//  Copyright (c) 2015年 aipai. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface APRoundButton : UIButton

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, strong) IBInspectable NSString *myString;

@property (nonatomic, strong) UILabel *myLabel;

@end

//NSArray *fontNames = @[@"Lato-Regular", @"Lato-Bold", @"Lato-Italic", @"Lato-Light"];