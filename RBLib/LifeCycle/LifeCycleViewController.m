//
//  LifeCycleViewController.m
//  RBLib
//
//  Created by zruibin on 15/5/5.
//  Copyright (c) 2015年 zruibin. All rights reserved.
//

#import "LifeCycleViewController.h"
#import "LifeCycleView.h"
#import "RBMacros.h"
#import <Masonry/Masonry.h>
#import "RBClassHook.h"

@interface LifeCycleViewController ()

@property (nonatomic, strong) UILabel  *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) LifeCycleView *lifeCycleView;

@end

@implementation LifeCycleViewController

#pragma mark - init

- (instancetype)init
{
    DLog(@"init");
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    DLog(@"initWithCoder");
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    DLog(@"initWithNibName");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
     DLog(@"awakeFromNib");
}

#pragma mark - Life Cycle

- (void)dealloc
{
    DLog(@"dealloc");
}

//- (void)loadView
//{
//    // This is where subclasses should create their custom view hierarchy if they aren't using a nib. Should never be called directly.
//    DLog(@"loadView");
//    //无论手写或storyboard或xib，都需设置初始view的大小，否则会每次都重新调用viewDidLoad
//    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
//}

- (void)viewWillUnload
{
    DLog(@"viewWillUnload");
}

- (void)viewDidUnload
{
    // Called after the view controller's view is released and set to nil. For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
    DLog(@"viewDidUnload");

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DLog(@"viewDidLoad...");
    
    [self.view addSubview:self.label];
    [self.view addSubview:self.button];
    [self.view addSubview:self.lifeCycleView];
    
    self.label.frame = CGRectMake(10, 70, 60, 30);
    self.button.frame = CGRectMake(10, 130, 80, 40);
    
    // MARK: 不能设置，否则会出错
//    self.view.translatesAutoresizingMaskIntoConstraints = NO; 
    
    [self layoutPageSubviews];
    
    RBClassHook *classHook = [[RBClassHook alloc] init];
    classHook.classer = [UIViewController class];
    [classHook printIvarList];
    [classHook printPropertyList];
    [classHook printMethodList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    DLog(@"didReceiveMemoryWarning");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Called when the view is about to made visible. Default does nothing
    DLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Called when the view has been fully transitioned onto the screen. Default does nothing
    DLog(@"viewDidAppear");
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
    DLog(@"viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
    DLog(@"viewDidDisappear");
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    // Called just before the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
    DLog(@"viewWillLayoutSubviews");
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    // Called just after the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
    DLog(@"viewDidLayoutSubviews");
}

- (void)updateViewConstraints
{
    DLog(@"updateViewConstraints");
    [super updateViewConstraints];
}

- (void)layoutPageSubviews
{
    // MARK: Default
//    UIEdgeInsets padding = UIEdgeInsetsMake(20, 10, 10, 10);
//    [self.view addConstraints:@[
//                                [NSLayoutConstraint constraintWithItem:self.lifeCycleView
//                                                             attribute:NSLayoutAttributeTop
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:self.button
//                                                             attribute:NSLayoutAttributeBottom  //参照self.button的底部
//                                                            multiplier:1.0
//                                                              constant:padding.top],
////                                [NSLayoutConstraint constraintWithItem:self.lifeCycleView
////                                                             attribute:NSLayoutAttributeBottom
////                                                             relatedBy:NSLayoutRelationEqual
////                                                                toItem:self.view
////                                                             attribute:NSLayoutAttributeBottom
////                                                            multiplier:1.0
////                                                              constant:-padding.bottom],
//                                
//                                [NSLayoutConstraint constraintWithItem:self.lifeCycleView
//                                                             attribute:NSLayoutAttributeLeft
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:self.view
//                                                             attribute:NSLayoutAttributeLeft
//                                                            multiplier:1.0
//                                                              constant:padding.left],
//                                [NSLayoutConstraint constraintWithItem:self.lifeCycleView
//                                                             attribute:NSLayoutAttributeRight
//                                                             relatedBy:NSLayoutRelationEqual
//                                                                toItem:self.view
//                                                             attribute:NSLayoutAttributeRight
//                                                            multiplier:1
//                                                              constant:-padding.right],
//                                
//                                //相当于父view的三分之一
////                                [NSLayoutConstraint constraintWithItem:self.lifeCycleView
////                                                             attribute:NSLayoutAttributeHeight
////                                                             relatedBy:NSLayoutRelationEqual
////                                                                toItem:self.view
////                                                             attribute:NSLayoutAttributeHeight
////                                                            multiplier:0.3
////                                                              constant:0],
//                                ]];
//    [self.lifeCycleView addConstraint:[NSLayoutConstraint
//                                       constraintWithItem:self.lifeCycleView
//                                       attribute:NSLayoutAttributeHeight
//                                       relatedBy:NSLayoutRelationGreaterThanOrEqual
//                                       toItem:nil
//                                       attribute:NSLayoutAttributeNotAnAttribute
//                                       multiplier:1
//                                       constant:60]];
    
    // MARK: VFL
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_button]-20-[_lifeCycleView(60)]"
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:NSDictionaryOfVariableBindings(_lifeCycleView, _button)]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_lifeCycleView(>=100)]-10-|"
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:NSDictionaryOfVariableBindings(_lifeCycleView)]];
    
    // MARK: Masonry
    UIEdgeInsets padding = UIEdgeInsetsMake(20, 10, 10, 10);
    [self.lifeCycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button.mas_bottom).with.offset(padding.top); //with is an optional semantic filler
        make.left.equalTo(self.view.mas_left).with.offset(padding.left);
        //        make.bottom.equalTo(self.view.mas_bottom).with.offset(-padding.bottom);
        make.right.equalTo(self.view.mas_right).with.offset(-padding.right);
        make.width.greaterThanOrEqualTo(@100);
        make.height.equalTo(@60);
    }];

}

#pragma mark - Event

- (void)changeRect:(UIButton *)btn
{
    CGRect rect = btn.frame;
    rect.origin.y += 50;
    btn.frame = rect;
    
    // MARK: 修改lifeCycleView的Top约束
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        // MARK: self.lifeCycleView.superview可能不止只有对一个view的约束，可以还有其他view的约束，所以要注意
        if (constraint.firstItem == self.lifeCycleView && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = 100;
            DLog(@"constraint.constant:%f", constraint.constant);

            [UIView animateWithDuration:2 animations:^{
                [self.lifeCycleView.superview layoutIfNeeded];
            }];
        };
    }
    
    // MARK: 删除lifeCycleView的所有约束
//    for (NSLayoutConstraint *constraint in self.lifeCycleView.superview.constraints) {
//        if (constraint.firstItem == self.lifeCycleView) {
//            [self.view removeConstraint:constraint];
//        }
//    }
}


#pragma mark - setter and getter

- (UILabel *)label
{
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor yellowColor];
        _label.text = @"label";
//        _label.preferredMaxLayoutWidth
    }
    return _label;
}

- (UIButton *)button
{
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"button" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        _button.backgroundColor = [UIColor greenColor];
        [_button addTarget:self action:@selector(changeRect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (LifeCycleView *)lifeCycleView
{
    if (_lifeCycleView == nil) {
        _lifeCycleView = [[LifeCycleView alloc] init];
        _lifeCycleView.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    return _lifeCycleView;
}

@end

// MARK: 
/*
 layoutSubviews在以下情况下会被调用：
 
 1、init初始化不会触发layoutSubviews
 2、addSubview会触发layoutSubviews
 3、设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化
 4、滚动一个UIScrollView会触发layoutSubviews
 5、旋转Screen会触发父UIView上的layoutSubviews事件
 6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
 
 
 在viewDidLoad里面开一个layoutPageSubviews的方法，然后在这个里面创建Constraints并添加
 
 其实在viewWillAppear这里改变UI元素不是很可靠，Autolayout发生在viewWillAppear之后，严格来说这里通常不做视图位置的修改，而用来更新Form数据。
 改变位置可以放在viewWilllayoutSubview或者didLayoutSubview里，而且在viewDidLayoutSubview确定UI位置关系之后设置autoLayout比较稳妥。
 另外，viewWillAppear在每次页面即将显示都会调用，viewWillLayoutSubviews虽然在lifeCycle里调用顺序在viewWillAppear之后，
 但是只有在页面元素需要调整时才会调用，避免了Constraints的重复添加。
 
 添加约束于viewDidLoad中添加，修改与删除则于viewWillLayoutSubviews或viewDidLayoutSubviews中(viewWillLayoutSubviews->updateViewConstraints->viewDidLayoutSubviews)
 
 要开始使用AutoLayout，请先设置要约束的view的translatesAutoresizingMaskIntoConstraints属性为NO。
 在xib或者sb中勾选Use Auto Layout，那么所有在xib或者sb中出现的view都已经默认将translatesAutoresizingMaskIntoConstraints设置为NO
 通过代码为xib或sb中view增加约束时，尽量避免在viewDidLoad中执行，最好放在updateViewConstraints[UIViewController]或者updateConstraints[UIView]中，
 记得调用[super updateViewConstraints]或者[super updateConstraints];
 
 */

// MARK: 
/*
    让viewWillAppear、viewDidAppear调用无数次，而viewDidDisappear一次也不触发，iOS7增加这个手势，从屏幕左边缘往右滑会有个pop的效果，但是不要滑到触发pop
 */





