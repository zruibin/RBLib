//
//  ScrollHiddenBarVC.m
//  AnimationDemo
//
//  Created by zruibin on 15/4/21.
//  Copyright (c) 2015年 RBCHOW. All rights reserved.
//

#import "ScrollHiddenBarVC.h"
#import "RBMacros.h"
#import "UINavigationBar+Gradient.h"


@interface ScrollHiddenBarVC () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation ScrollHiddenBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"ScrollHiddenBarVC";
    // Do any additional setup after loading the view.
    [NSThread sleepForTimeInterval:2.0f];
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
//        self.navigationController.navigationBar.translucent = NO;
        self.automaticallyAdjustsScrollViewInsets           = NO;
    }

    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.contentSize = CGSizeMake(320, 2000);
    _scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg.png"] forBarMetrics:UIBarMetricsCompact];
    
//    [self.navigationController.navigationBar rb_setBackgroundColor:[UIColor clearColor]];
//    self
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"y:%f", scrollView.contentOffset.y);
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 50) {
        CGFloat alpha = 1 - ((50 + 64 - offsetY) / 64);
        
        [self.navigationController.navigationBar rb_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar rb_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

@end
