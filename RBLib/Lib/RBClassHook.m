//
//  RBClassHook.m
//  RBLib
//
//  Created by zruibin on 15/10/9.
//  Copyright © 2015年 RBCHOW. All rights reserved.
//

#import "RBClassHook.h"
#import <objc/runtime.h>
#import "RBMacros.h"

@implementation RBClassHook

#pragma mark - Printer

- (void)printIvarList
{
    u_int count;
    Ivar *ivarList = class_copyIvarList(self.classer, &count);
    for (int i=0; i<count; i++) {
        const char *ivarName = ivar_getName(ivarList[i]);
        NSString *strName = [NSString stringWithCString:ivarName encoding:NSUTF8StringEncoding];
        DLog(@"ivar:%@", strName);
    }
}

- (void)printPropertyList
{
    u_int count;
    objc_property_t *properties = class_copyPropertyList(self.classer, &count);
    for (int i=0; i<count; i++) {
        const char *propertyName = property_getName(properties[i]);
        NSString *strName = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        DLog(@"property:%@", strName);
    }
}

- (void)printMethodList
{
    u_int count;
    Method *methods = class_copyMethodList(self.classer, &count);
    for (int i=0; i<count; i++) {
        SEL methodName = method_getName(methods[i]);
        NSString *strName = [NSString stringWithCString:sel_getName(methodName) encoding:NSUTF8StringEncoding];
        DLog(@"method:%@", strName);
    }
}

@end
