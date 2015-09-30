//
//  ClassPrinter.h
//  RBLib
//
//  Created by zhouruibin on 15/9/30.
//  Copyright © 2015年 zruibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassPrinter : NSObject

@property (nonatomic, strong) Class classer;

- (void)printIvarList;
- (void)printPropertyList;
- (void)printMethodList;

@end
