//
//  YMShowImageView.m
//  RBLib
//
//  Created by zruibin on 15/4/14.
//  Copyright (c) 2015年 zruibin. All rights reserved.
//

#import "RBShowImageView.h"

#define kMainScreen [[UIScreen mainScreen] bounds]

@interface RBShowImageView () {
    UIScrollView *_scrollView;
    CGRect       self_Frame;
    NSInteger    page;
    BOOL         doubleClick;
}

- (void)configScrollViewWithImages:(NSArray *)imags;

@end

@implementation RBShowImageView

- (instancetype)initWithImages:(NSArray *)imgs
{
    self = [super init];
    if (self) {
        self.frame = kMainScreen;
        self_Frame = kMainScreen;
        self.backgroundColor = [UIColor whiteColor];
        self.alpha  = 0.0f;
        page        = 0;
        doubleClick = YES;
        
        UITapGestureRecognizer *tapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        tapGser.numberOfTouchesRequired = 1;
        tapGser.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGser];
        
        UITapGestureRecognizer *doubleTapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBig:)];
        doubleTapGser.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGser];

        [self configScrollViewWithImages:imgs];
    }
    return self;
}

- (void)configScrollViewWithImages:(NSArray *)imags
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self_Frame];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = true;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * imags.count, 0);
    [self addSubview:_scrollView];
    
    for (int i = 0; i < imags.count; i ++) {
        
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageScrollView.backgroundColor = [UIColor blackColor];
        imageScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        imageScrollView.delegate = self;
        imageScrollView.maximumZoomScale = 4;
        imageScrollView.minimumZoomScale = 1;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage *img = (UIImage *)[imags objectAtIndex:i];//[UIImage imageNamed:[NSString stringWithFormat:@"%@",[appendArray objectAtIndex:i]]];
        imageView.image = img;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageScrollView addSubview:imageView];
        [_scrollView addSubview:imageScrollView];
        
        imageScrollView.tag = 100 + i ;
        imageView.tag = 1000 + i;
    }
    page = 0;
}

- (void)disappear{
    [UIView animateWithDuration:.4f animations:^(){
        self.alpha = .0f;
    } completion:^(BOOL finished) {
       [self removeFromSuperview];
    }];
}


- (void)changeBig:(UITapGestureRecognizer *)tapGes{

    CGFloat newscale = 1.9;
    UIScrollView *currentScrollView = (UIScrollView *)[self viewWithTag:page + 100];
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[tapGes locationInView:tapGes.view] andScrollView:currentScrollView];
    
    if (doubleClick == YES)  {
        
        [currentScrollView zoomToRect:zoomRect animated:YES];
        
    }else {
      
        [currentScrollView zoomToRect:currentScrollView.frame animated:YES];
    }
    
    doubleClick = !doubleClick;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    UIImageView *imageView = (UIImageView *)[self viewWithTag:scrollView.tag + 900];
    return imageView;
}

- (CGRect)zoomRectForScale:(CGFloat)newscale withCenter:(CGPoint)center andScrollView:(UIScrollView *)scrollV{
   
    CGRect zoomRect = CGRectZero;
    
    zoomRect.size.height = scrollV.frame.size.height / newscale;
    zoomRect.size.width = scrollV.frame.size.width  / newscale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
   // NSLog(@" === %f",zoomRect.origin.x);
    return zoomRect;
}

- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    [UIView animateWithDuration:.4f animations:^(){
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - ScorllViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  
    CGPoint offset = _scrollView.contentOffset;
    page = offset.x / self.frame.size.width ;
    
    UIScrollView *scrollV_next = (UIScrollView *)[self viewWithTag:page+100+1]; //前一页
    
    if (scrollV_next.zoomScale != 1.0){
    
        scrollV_next.zoomScale = 1.0;
    }
    
    UIScrollView *scollV_pre = (UIScrollView *)[self viewWithTag:page+100-1]; //后一页
    if (scollV_pre.zoomScale != 1.0){
        scollV_pre.zoomScale = 1.0;
    }
    
   // NSLog(@"page == %d",page);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
  

}

@end
