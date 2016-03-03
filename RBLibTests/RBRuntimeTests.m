//
//  RBRuntimeTests.m
//  RBLib
//
//  Created by zhouruibin on 16/3/3.
//  Copyright © 2016年 zruibin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "RBMacros.h"

@interface Woman : NSObject
- (void)stady;
@end

@implementation Woman
- (void)stady
{
    DLog(@"Woman:%s...\n", "stady");
}
@end

@interface Man : NSObject
- (void)walk;
@end

@implementation Man
- (void)walk
{
    DLog(@"Man:%s...", "walk");
}
@end


void dynamicMethodIMP(id self, SEL _cmd)
{
    DLog(@"%@", self);
}


@interface Person : NSObject

@end

@implementation Person

#pragma mark - 1、动态方法解析

//+ (BOOL)resolveClassMethod:(SEL)sel d
+ (BOOL)resolveInstanceMethod:(SEL)aSEL
{
    if (aSEL == @selector(show)) {
        class_addMethod([self class], aSEL, (IMP)dynamicMethodIMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:aSEL];
}

#pragma mark - 2、消息转发 重定向

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if(aSelector == @selector(walk)){
        return [[Man alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark - 3、消息转发 转发

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [NSMethodSignature signatureWithObjCTypes:"v@:*"];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    Woman *messageForwarding = [Woman new];
    if ([messageForwarding respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:messageForwarding];
    }
}

@end


@interface RBRuntimeTests : XCTestCase

@end

@implementation RBRuntimeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testRuntime
{
    Person *p = [[Person alloc] init];
    [p performSelector:@selector(show)];
    [p performSelector:@selector(walk)];
    [p performSelector:@selector(stady)];
}

@end





