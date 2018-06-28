//
//  UIWebView+Utils.h
//  AppKit
//
//  Created by YangLin on 2017/12/20.
//  Copyright © 2017年 YangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Utils)


/**
 调整图片大小、取消文字选中，获取图片方法
 */
-(void)getImageUrlByJS;

/**
 处理js回调

 @param request js回调请求
 @param block 处理回调block
 @return 返回是否处理请求
 */
-(BOOL)shouldStartLoad:(NSURLRequest *)request block:(void(^)(NSInteger index, NSArray *images))block;
@end
