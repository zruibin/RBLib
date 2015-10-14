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

//根据类名称获取类
//系统就提供 NSClassFromString(NSString *clsname)
//获取一个类的所有属性名字:类型的名字，具有@property的, 父类的获取不了！
NSDictionary *GetPropertyListOfObject(NSObject *object);
NSDictionary *GetPropertyListOfClass(Class cls);

void Swizzle(Class c, SEL origSEL, SEL newSEL);

@end
