//
//  UILabel+HTML.h
//  UFA
//
//  Created by YangLin on 2017/7/27.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (HTML)

- (void)setHtmlStr:(NSString *)html;
- (void)setHtmlStr:(NSString *)html defultColor:(UIColor*)color;

@end
