//
//  ViewController+Test.h
//  RBLib
//
//  Created by zruibin on 15/10/10.
//  Copyright © 2015年 zruibin. All rights reserved.
//

#import "ViewController.h"
#import "RBMacros.h"

@interface ViewController (Test)

_PROPERTY_ASSOCIATEDOBJECT(NSString*, age);
_PROPERTY_ASSOCIATEDOBJECT(NSString*, test);

- (void)testAssociatedObject;

@end
