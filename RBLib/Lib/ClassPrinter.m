//
//  ClassPrinter.m
//  RBLib
//
//  Created by zhouruibin on 15/9/30.
//  Copyright © 2015年 zruibin. All rights reserved.
//

#import "ClassPrinter.h"
#import <objc/runtime.h>
#import "RBMarco.h"

@implementation ClassPrinter

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



