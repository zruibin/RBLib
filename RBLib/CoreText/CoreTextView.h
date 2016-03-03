//
//  CoreTextView.h
//  RBLib
//
//  Created by zhouruibin on 16/3/3.
//  Copyright © 2016年 zruibin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CoreTextShowType) {
    CoreTextBase,
    CoreTextParagraph,
    CoreTextLine,
    CoreTextLineBounds,
    CoreTextBlend
};

@interface CoreTextView : UIView

@property (nonatomic, assign) CoreTextShowType showType;

@end
