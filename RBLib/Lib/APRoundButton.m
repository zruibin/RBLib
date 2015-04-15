//
//  APRoundButton.m
//  APCustomButton
//
//  Created by xiewei on 15/4/15.
//  Copyright (c) 2015年 aipai. All rights reserved.
//

#import "APRoundButton.h"
#import <objc/runtime.h>

@implementation APRoundButton

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    
    if(self)
    {
        _myString = @"label";
        
        _myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
        [self addSubview:_myLabel];
        _myLabel.text = _myString;
        
        
        [self initialiseControl];
    }
    return self;
}

-  (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    
    if (self)
    {
        _myString = @"label";
        
        _myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
        [self addSubview:_myLabel];
        _myLabel.text = _myString;
        
        [self initialiseControl];
    }
    
    return self;
}

- (void)initialiseControl
{
    self.layer.cornerRadius = _cornerRadius;
    self.layer.borderWidth = _borderWidth;
    self.layer.borderColor = _borderColor.CGColor;
    self.layer.masksToBounds = YES;
    
    _myLabel.text = _myString;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    
    [self initialiseControl];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    
    [self initialiseControl];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    
    [self initialiseControl];
}

- (void)setMyString:(NSString *)myString
{
    _myString = myString;
    
    [self initialiseControl];
}

@end

