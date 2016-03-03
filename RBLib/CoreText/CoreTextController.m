//
//  CoreTextController.m
//  RBLib
//
//  Created by zhouruibin on 16/3/3.
//  Copyright © 2016年 zruibin. All rights reserved.
//

#import "CoreTextController.h"
#import "CoreTextView.h"

@interface CoreTextController ()

@property (nonatomic, strong) CoreTextView *coreTextView;

@end

@implementation CoreTextController


- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSArray *titles = @[@"CoreTextBase", @"CoreTextParagraph", @"CoreTextLine", @"CoreTextLineBounds", @"CoreTextBlend"];
    NSInteger index = 0;
    for (NSString *title in titles) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 70 + index*45, CGRectGetWidth(self.view.frame)-20, 40);
        button.tag = index;
        [button setTitle:title forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor grayColor]];
        [button addTarget:self action:@selector(buttonActionEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        ++index;
    }
   
    CGFloat y = 70 + index*45;
    self.coreTextView = [[CoreTextView alloc] init];
    self.coreTextView.frame = CGRectMake(0, y, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-y);
    self.coreTextView.backgroundColor = [UIColor whiteColor];
    self.coreTextView.layer.borderWidth = 0.5f;
    self.coreTextView.layer.borderColor = [[UIColor redColor] CGColor];
    [self.view addSubview:self.coreTextView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

- (void)buttonActionEvent:(UIButton *)sender
{
    self.coreTextView.showType = sender.tag;
}


@end
