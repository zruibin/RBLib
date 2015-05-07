//
//  LifeCycleViewController.m
//  RBLib
//
//  Created by zruibin on 15/5/5.
//  Copyright (c) 2015年 zruibin. All rights reserved.
//

#import "LifeCycleViewController.h"

@interface LifeCycleViewController ()

@property (nonatomic, strong) UILabel  *label;
@property (nonatomic, strong) UIButton *button;

@end

@implementation LifeCycleViewController

#pragma mark - init

- (instancetype)init
{
     NSLog(@"init");
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
     NSLog(@"initWithCoder");
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
     NSLog(@"initWithNibName");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
     NSLog(@"awakeFromNib");
}

#pragma mark - Life Cycle

- (void)dealloc
{
    NSLog(@"dealloc");
}

//- (void)loadView
//{
//    // This is where subclasses should create their custom view hierarchy if they aren't using a nib. Should never be called directly.
//    NSLog(@"loadView");
//    //无论手写或storyboard或xib，都需设置初始view的大小，否则会每次都重新调用viewDidLoad
//    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
//}

- (void)viewWillUnload
{
    NSLog(@"viewWillUnload");
}

- (void)viewDidUnload
{
    // Called after the view controller's view is released and set to nil. For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
    NSLog(@"viewDidUnload");

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"viewDidLoad...");
    
    [self.view addSubview:self.label];
    [self.view addSubview:self.button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"didReceiveMemoryWarning");
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
    NSLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Called when the view has been fully transitioned onto the screen. Default does nothing
    NSLog(@"viewDidAppear");
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
    NSLog(@"viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
    NSLog(@"viewDidDisappear");
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    // Called just before the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
    NSLog(@"viewWillLayoutSubviews");
    
    self.label.frame = CGRectMake(10, 70, 60, 30);
    self.button.frame = CGRectMake(10, 130, 80, 40);
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    // Called just after the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
    NSLog(@"viewDidLayoutSubviews");
}


#pragma mark - setter and getter

- (UILabel *)label
{
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor yellowColor];
        _label.text = @"label";
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
    }
    return _button;
}

@end


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
 */

// MARK: 
/*
    让viewWillAppear、viewDidAppear调用无数次，而viewDidDisappear一次也不触发，iOS7增加这个手势，从屏幕左边缘往右滑会有个pop的效果，但是不要滑到触发pop
 */





