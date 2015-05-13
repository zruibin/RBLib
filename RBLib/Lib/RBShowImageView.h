//
//  RBShowImageView.h
//  RBLib
//
//  Created by zruibin on 15/4/14.
//  Copyright (c) 2015年 zruibin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RBShowImageView : UIView<UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger currentImageIndex;

/**
 *  初始化
 *
 *  @param imgs 要展示的图片数组(数组内容为UIImage)
 *
 *  @return 该对象
 */
- (instancetype)initWithImages:(NSArray *)imgs;

- (void)show;

@end
