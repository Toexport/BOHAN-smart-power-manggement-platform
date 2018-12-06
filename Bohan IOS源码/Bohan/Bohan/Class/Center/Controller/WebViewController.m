//
//  WebViewController.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/5.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "WebViewController.h"
#import  <WebKit/WebKit.h>
#import "WKWebView+Utils.h"
#import "DebuggingANDPublishing.pch"
@interface WebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong)WKWebView *wkwebView;

@end

@implementation WebViewController

- (instancetype)initWithTitle:(NSString *)name urlStr:(NSString *)url {
    self = [super init];
    if (self) {
        self.title = Localize(name);
        [self.wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.wkwebView];
    [self.view startLoading];
    if (self.type == 555) {
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.StrKey]]];
        self.title = Localize(@"最新消息");
        [self.wkwebView loadRequest:request];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_details_cancel"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }else
        if (self.type == 666) {
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
            self.title = Localize(@"红外设备介绍");
            [self.wkwebView loadRequest:request];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_details_cancel"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
        }
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (WKWebView *)wkwebView {
    if (!_wkwebView) {
        _wkwebView = [WKWebView initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _wkwebView.backgroundColor = [UIColor clearColor];
//        _wkwebView.UIDelegate = self;
        _wkwebView.navigationDelegate = self;
        _wkwebView.allowsBackForwardNavigationGestures =YES;//打开网页间的 滑动返回
    }
    return _wkwebView;
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
//    [ webView evaluateJavaScript:@"var script = document.createElement('script');"
//          "script.type = 'text/javascript';"
//          "script.text = \"function ResizeImages() { "
//          "var myimg,oldwidth;"
//          "var maxwidth = 1000.0;" // UIWebView中显示的图片宽度
//          "for(i=1;i <document.images.length;i++){"
//          "myimg = document.images[i];"
//          "oldwidth = myimg.width;"
//          "myimg.width = maxwidth;"
//          "}"
//          "}\";"
//          "document.getElementsByTagName('head')[0].appendChild(script);ResizeImages();" completionHandler:nil];
    [self.view stopLoading];

}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.view stopLoading];
}

-(void)dealloc {
    _wkwebView.navigationDelegate = nil;
    _wkwebView.UIDelegate = nil;
    ZPLog(@"wkwebview dealloc");
}


@end
