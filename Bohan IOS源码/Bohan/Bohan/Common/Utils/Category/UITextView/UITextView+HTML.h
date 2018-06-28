//
//  UITextView+HTML.h
//  UFA
//
//  Created by YangLin on 2017/7/25.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (HTML)

- (void)setHtmlStr:(NSString *)html;
- (void)setHtmlStr:(NSString *)html defultColor:(UIColor*)color;
@end
