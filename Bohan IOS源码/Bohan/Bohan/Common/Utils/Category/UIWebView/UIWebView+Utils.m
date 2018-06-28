//
//  UIWebView+Utils.m
//  AppKit
//
//  Created by YangLin on 2017/12/20.
//  Copyright © 2017年 YangLin. All rights reserved.
//

#import "UIWebView+Utils.h"
#import <objc/runtime.h>
static char imgUrlArrayKey;
static CGFloat const Padding = 32;

@implementation UIWebView (Utils)


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
    "document.location=\"myweb:getImages:\"+imgUrlStr;"
    "};";
    
    //用js获取全部图片

    [self stringByEvaluatingJavaScriptFromString:jsGetImages];

    NSString *js2=@"getImages()";
    [self stringByEvaluatingJavaScriptFromString:js2];
    
    
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
    
    [self stringByEvaluatingJavaScriptFromString:jScript];
    [self stringByEvaluatingJavaScriptFromString:js];
    [self stringByEvaluatingJavaScriptFromString:@"ResizeImages()"];
    
    [self stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
//    [self stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='%@';",[[[NSNumber numberWithFloat:100*SizeScale] stringValue] stringByAppendingString:@"%"]]];
    
    [self stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#333333'"];
    
}


-(BOOL)shouldStartLoad:(NSURLRequest *)request block:(void(^)(NSInteger index, NSArray *images))block
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
    }else if ([requestString hasPrefix:@"myweb:getImages:"])
    {
        
        NSString *resurlt = [requestString substringFromIndex:@"myweb:getImages:".length];
        
        NSString *prefix = @"#";
        if ([resurlt hasPrefix:@"#"]) {
            
        }else if ([resurlt hasPrefix:@"%23"])
        {
            prefix = @"%23";
        }
        resurlt=[resurlt substringFromIndex:prefix.length];

        NSArray *array = [resurlt componentsSeparatedByString:prefix];
        [self setImgUrlArray:array];

        if (block) {
            block(-1,array);
        }
        
        return NO;
    }
    
    return YES;
    
}


@end
