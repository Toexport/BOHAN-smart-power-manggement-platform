//
//  UISearchBar+Color.m
//  UFA
//
//  Created by YangLin on 2017/7/14.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "UISearchBar+Color.h"
#import "DebuggingANDPublishing.pch"
@implementation UISearchBar (Color)

- (void)setSearchTextFieldBackgroundColor:(UIColor *)backgroundColor
{
    UIView *searchTextField = nil;

//    if (IsiOS7OrLater) {
    
        // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
        self.barTintColor = [UIColor whiteColor];
        searchTextField = [[[self.subviews firstObject] subviews] lastObject];
        
//    }else
//    {
//        self.barTintColor = [UIColor whiteColor];
//        searchTextField = [[[self.subviews firstObject] subviews] lastObject];
//    }
    searchTextField.backgroundColor = backgroundColor;
}
@end
