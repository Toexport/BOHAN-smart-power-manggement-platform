//
//  UIButton+EdgeInsets.m
//  UFA
//
//  Created by YangLin on 2017/7/28.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "UIButton+EdgeInsets.h"

@implementation UIButton (EdgeInsets)


- (void)imageViewCenter:(CGPoint)imageCenter titleCenter:(CGPoint)titleCenter
{
    
//    self.imageEdgeInsets = UIEdgeInsetsZero;
//    self.titleEdgeInsets = UIEdgeInsetsZero;

    // 取得imageView最初的center
    CGPoint startImageViewCenter = self.imageView.center;
    
    // 取得titleLabel最初的center
    CGPoint startTitleLabelCenter = self.titleLabel.center;
    
    NSLog(@"----------%@",self.titleLabel);
    
    
    // 设置imageEdgeInsets
    CGFloat imageEdgeInsetsTop = imageCenter.y - startImageViewCenter.y;
    
    CGFloat imageEdgeInsetsLeft = imageCenter.x - startImageViewCenter.x;
    
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    
//    self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight)];
    
    // 设置titleEdgeInsets
    
    CGFloat titleEdgeInsetsTop = titleCenter.y-startTitleLabelCenter.y;
    
    CGFloat titleEdgeInsetsLeft = titleCenter.x - startTitleLabelCenter.x;
    
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    
//    self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
    [self setTitleEdgeInsets:UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight)];
    
}
@end
