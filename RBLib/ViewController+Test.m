//
//  ViewController+Test.m
//  RBLib
//
//  Created by zruibin on 15/10/10.
//  Copyright © 2015年 zruibin. All rights reserved.
//

#import "ViewController+Test.h"

@implementation ViewController (Test)

_MAKE_ASSOCIATEDOBJECT(NSString*, age, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
_MAKE_ASSOCIATEDOBJECT(NSString*, test, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
_MAKE_ASSOCIATEDOBJECT(NSNumber *, num, OBJC_ASSOCIATION_ASSIGN);

- (void)testAssociatedObject
{
    DLog(@"testAssociatedObject....");
    self.age = @"89...";
    self.test = @"test";
    self.num = [NSNumber numberWithInt:22];
    DLog(@"AssociatedObject:%@-%@-%@", self.age, self.test, self.num);
}

@end






