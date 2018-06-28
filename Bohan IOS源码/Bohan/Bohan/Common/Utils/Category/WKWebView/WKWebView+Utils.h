//
//  WKWebView+Utils.h
//  AppKit
//
//  Created by YangLin on 2017/12/20.
//  Copyright © 2017年 YangLin. All rights reserved.
//


#import  <WebKit/WebKit.h>
@interface WKWebView (Utils)


/**
 WKWebView初始化类方法

 @param frame frame
 @return 返回WKWebView实例对象
 */
+ (instancetype)initWithFrame:(CGRect)frame;


/**
 获取WKWebView 内图片方法
 */
-(void)getImageUrlByJS;


/**
 查看大图方法

 @param request js请求
 @param block 点击图片回调block
 @return 返回是否响应js请求
 */
-(BOOL)showBigImage:(NSURLRequest *)request clickBlock:(void(^)(NSInteger index, NSArray *images))block;
@end
