//
//  UncaughtExceptionHandler.h
//  RBLib
//
//  Created by zruibin on 15/4/1.
//  Copyright (c) 2015年 zruibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

void InstallUncaughtExceptionHandler();
void HandleException(NSException *exception);
void SignalHandler(int signal);


@interface UncaughtExceptionHandler : NSObject

@end
