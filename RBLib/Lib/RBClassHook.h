//
//  RBClassHook.h
//  RBLib
//
//  Created by zruibin on 15/10/9.
//  Copyright © 2015年 RBCHOW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBClassHook : NSObject

@property (nonatomic, strong) Class classer;

- (void)printIvarList;
- (void)printPropertyList;
- (void)printMethodList;

@end
