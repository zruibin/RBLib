//
//  LifeCycleView.m
//  RBLib
//
//  Created by zruibin on 15/5/8.
//  Copyright (c) 2015年 zruibin. All rights reserved.
//

#import "LifeCycleView.h"
#import "RBMarco.h"

@implementation LifeCycleView

- (instancetype)init
{
    DLog(@"view init...");
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    DLog(@"view initWithCoder...");
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    DLog(@"view awakeFromNib...");
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    DLog(@"view drawRect...");
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    DLog(@"view layoutSublayersOfLayer...");
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    DLog(@"view layoutSubviews...");
}

- (void)setNeedsUpdateConstraints
{
    DLog(@"view setNeedsUpdateConstraints...")
}

- (void)updateConstraints
{
    [super updateConstraints];
    DLog(@"view updateConstraints...");
}

- (BOOL)needsUpdateConstraints
{
    DLog(@"view needsUpdateConstraints...")
    return YES;
}

- (void)updateConstraintsIfNeeded
{
    DLog(@"view updateConstraintsIfNeeded...")
}

- (void)layoutIfNeeded
{
    DLog(@"view layoutIfNeeded...")
}

@end



/*
 
 setNeedsUpdateConstraints:当一个自定义的View某一个属性的改变可能影响到界面布局，我们应该调用这个方法来告诉布局系统在未来某个时刻需要更新。
                            系统会调用updateConstraints去更新布局。
 
 updateConstraints:自定义View时，我们应该重写这个方法来设置当前view局部的布局约束。
                    重写这个方法时，一定要调用[super updateConstraints]。
 
 needsUpdateConstraints:布局系统使用这个返回值来确定是否调用updateConstraints
 
 updateConstraintsIfNeeded:我们可以调用这个方法触发update Constraints的操作。在needsUpdateConstraints返回YES时，才能成功触发update Constraints的操作。
                            我们不应该重写这个方法。
 
layoutIfNeeded:使用此方法强制立即进行layout,从当前view开始，此方法会遍历整个view层次(包括superviews)请求layout。因此，调用此方法会强制整个view层次布局。
 
 Auto Layout的布局过程是 update constraints(updateConstraints)-> layout Subviews(layoutSubViews)-> display(drawRect) 这三步不是单向的，
 如果layout的过程中改变了constrait, 就会触发update constraints，进行新的一轮迭代。我们在实际代码中，应该避免在此造成死循环。
 
 1、任何原因引起View的尺寸被改变
 2、调用ViewController的“viewWillLayoutSubviews”方法
 3、未启用Autolayout情况，调用“layoutSubviews”
 4、启用Autolayout情况，调用ViewController的"updateViewConstraints"方法。在这个方法里，会调用所有subview的“updateConstraints”方法。
 5、当界面被刷新后，调用ViewController的“viewDidLayoutSubviews”
 */








