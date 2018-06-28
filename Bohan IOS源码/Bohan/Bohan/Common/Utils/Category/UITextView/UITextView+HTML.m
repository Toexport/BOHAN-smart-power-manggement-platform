//
//  UITextView+HTML.m
//  UFA
//
//  Created by YangLin on 2017/7/25.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "UITextView+HTML.h"

@implementation UITextView (HTML)


- (void)setHtmlStr:(NSString *)html
{
    [self setHtmlStr:html defultColor:nil];
    
}

- (void)setHtmlStr:(NSString *)html defultColor:(UIColor*)color
{
    NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
    
    
    if (color) {
        
        [attr enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0, attr.string.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            
            CGColorRef coloref = [value CGColor];
            const CGFloat* components = CGColorGetComponents(coloref);
            
            CGFloat red = components[0];
            CGFloat green = components[1];
            CGFloat blue = components[2];
            CGFloat alpha =1;
            
            if (red ==0 && green == 0 && blue == 0 && alpha == 1) {
                
                [attr setAttributes:@{NSForegroundColorAttributeName: color} range:range];
            }
        }];
    }
    
    [attr addAttributes:@{NSFontAttributeName: Font(14)} range:NSMakeRange(0, attr.string.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    [paragraphStyle setLineSpacing:10];//设置行间距
    [paragraphStyle setParagraphSpacing:20];//设置行间距
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attr.length)];
    
    self.attributedText = [attr copy];
}
@end
