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

#pragma mark -

NSDictionary *GetPropertyListOfObject(NSObject *object){
    return GetPropertyListOfClass([object class]);
}

NSDictionary *GetPropertyListOfClass(Class cls){
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        const char *propType = property_getAttributes(property);
        if(propType&&propName) {
            NSArray *anAttribute = [[NSString stringWithUTF8String:propType]componentsSeparatedByString:@","];
            NSString *aType = anAttribute[0];
            //暂时不能去掉前缀T@\"和后缀"，需要用以区分标量与否
//            if ([aType hasPrefix:@"T@\""]) {
//                aType = [aType substringWithRange:NSMakeRange(3, [aType length]-4)];
//            }else{
//                aType = [aType substringFromIndex:1];
//            }
            [dict setObject:aType forKey:[NSString stringWithUTF8String:propName]];
        }
    }
    free(properties);
    
    return dict;
}

//静态就交换静态，实例方法就交换实例方法
void Swizzle(Class c, SEL origSEL, SEL newSEL)
{
    Method origMethod = class_getInstanceMethod(c, origSEL);
    Method newMethod = nil;
    if (!origMethod) {
        origMethod = class_getClassMethod(c, origSEL);
        if (!origMethod) {
            return;
        }
        newMethod = class_getClassMethod(c, newSEL);
        if (!newMethod) {
            return;
        }
    }else{
        newMethod = class_getInstanceMethod(c, newSEL);
        if (!newMethod) {
            return;
        }
    }
    
    //自身已经有了就添加不成功，直接交换即可
    if(class_addMethod(c, origSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))){
        class_replaceMethod(c, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else{
        method_exchangeImplementations(origMethod, newMethod);
    }
}

@end








