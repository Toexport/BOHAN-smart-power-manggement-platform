//
//  WKWebView+Utils.m
//  AppKit
//
//  Created by YangLin on 2017/12/20.
//  Copyright © 2017年 YangLin. All rights reserved.
//

#import "WKWebView+Utils.h"
#import <objc/runtime.h>
#import "DebuggingANDPublishing.pch"
static CGFloat const Padding = 32;
static char imgUrlArrayKey;


@implementation WKWebView (Utils)

+ (instancetype)initWithFrame:(CGRect)frame
{
   WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) configuration:[WKWebView configuration]];
    return webview;
}

+ (WKWebViewConfiguration *)configuration
{
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    
    NSString *js = @"function ResizeImages() { "
    "var myimg,oldwidth,oldHeight;"
    "for(i=1;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "oldwidth = myimg.width;"
    "oldHeight = myimg.height;"
    "myimg.width = %f;"
    "if(oldHeight> 0 && oldHeight>0) {"
    "myimg.height = oldHeight*%f/(oldwidth*1.0);"
    "}"
    "}"
    "}";
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - Padding,[UIScreen mainScreen].bounds.size.width - Padding];
    
    NSString *adjust = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='%@';",[[[NSNumber numberWithFloat:100*SizeScale] stringValue] stringByAppendingString:@"%"]];
    
    WKUserScript *wkUScriptA = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserScript *wkUScriptB = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserScript *wkUScriptC = [[WKUserScript alloc] initWithSource:@"ResizeImages()" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserScript *wkUScriptD = [[WKUserScript alloc] initWithSource:adjust injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScriptA];
    [wkUController addUserScript:wkUScriptB];
    [wkUController addUserScript:wkUScriptC];
    [wkUController addUserScript:wkUScriptD];
    
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;

    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    // 设置字体大小(最小的字体大小)
    preference.minimumFontSize = 11;
    // 设置偏好设置对象
    wkWebConfig.preferences = preference;
    
    return wkWebConfig;
}



- (void)setImgUrlArray:(NSArray *)imgUrlArray
{
    objc_setAssociatedObject(self, &imgUrlArrayKey, imgUrlArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)getImgUrlArray
{
    return objc_getAssociatedObject(self, &imgUrlArrayKey);
}


-(void)getImageUrlByJS

{
    //查看大图代码
    
    //js方法遍历图片添加点击事件返回图片个数
    
    static  NSString * const jsGetImages =
    
    @"function getImages(){"
    "var objs = document.getElementsByTagName(\'img\');"
    "var imgUrlStr='';"
    "for(var i=0;i<objs.length;i++){"
    "if(i==0){"
    "imgUrlStr=objs[i].src;"
    "}else{"
    "imgUrlStr+='#'+objs[i].src;"
    "}"
    "objs[i].onclick=function(){"
    "document.location=\"myweb:imageClick:\"+this.src;"
    "};"
    "}"
    "return imgUrlStr;"
    "};";
    
    //用js获取全部图片
    
    [self evaluateJavaScript:jsGetImages completionHandler:nil];
    
    NSString *js2=@"getImages()";
    
    __weak typeof(self) weakSelf = self;
    [self evaluateJavaScript:js2 completionHandler:^(id Result, NSError * error) {
        
        NSString *resurlt=[NSString stringWithFormat:@"%@",Result];
        
        if([resurlt hasPrefix:@"#"])
        {
            resurlt=[resurlt substringFromIndex:1];
        }
        [weakSelf setImgUrlArray:[resurlt componentsSeparatedByString:@"#"]];
    }];
}


-(BOOL)showBigImage:(NSURLRequest *)request clickBlock:(void(^)(NSInteger index, NSArray *images))block
{
    NSString *requestString = [[request URL] absoluteString];
    
    if ([requestString hasPrefix:@"myweb:imageClick:"])
    {
        NSArray *images = [self getImgUrlArray];
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        NSInteger index=[images indexOfObject:imageUrl];
        
        if (block) {
            block(index,images);
        }

        return NO;
    }
    
    return YES;
    
}



@end
