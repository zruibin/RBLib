//
//  ViewController+Test.m
//  RBLib
//
//  Created by zruibin on 15/10/10.
//  Copyright © 2015年 zruibin. All rights reserved.
//

#import "ViewController+Test.h"

@implementation ViewController (Test)

_MAKE_ASSOCIATEDOBJECT(NSString*, age);
_MAKE_ASSOCIATEDOBJECT(NSString*, test);

- (void)testAssociatedObject
{
    DLog(@"testAssociatedObject....");
    self.age = @"89...";
    self.test = @"test";
    DLog(@"AssociatedObject:%@-%@-%@", self.age, self.test, self.age);
}

@end






