//
//  WifiView.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/10.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "WifiView.h"

@implementation WifiView


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.pwdTF.secureTextEntry = NO;

    self.ssidTF.textSpacing = 8;
    self.ssidTF.editSpacing = 8;
    self.pwdTF.textSpacing = 8;
    self.pwdTF.editSpacing = 8;

    
    NSMutableAttributedString *pageAtt = [[NSMutableAttributedString alloc] initWithString:steps.text];
    NSMutableParagraphStyle *pageStyle = [[NSMutableParagraphStyle alloc] init];
    [pageStyle setLineSpacing:1];
    [pageStyle setParagraphSpacing:3];

    [pageAtt addAttributes:@{NSParagraphStyleAttributeName:pageStyle} range:NSMakeRange(0, pageAtt.length)];

    
    steps.attributedText = pageAtt;
    
}
- (IBAction)showPwdAction:(UIButton *)sender {

    sender.selected = !sender.selected;

    self.pwdTF.secureTextEntry = sender.selected;

}
- (IBAction)addAction:(UIButton *)sender {

    if (self.addBock) {
        self.addBock(self.ssidTF.text, self.pwdTF.text);
    }

}


@end
