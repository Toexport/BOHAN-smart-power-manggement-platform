//
//  UIButton+CountDown.m
//  UFA
//
//  Created by YangLin on 2017/7/20.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "UIButton+CountDown.h"
#import "DebuggingANDPublishing.pch"
#define COUNT  60

@implementation UIButton (CountDown)

- (void)startTime
{
    self.tag = 60;
    //    [self setTitleColor:SubTextColor forState:UIControlStateNormal];
    [self setEnabled:NO];
    
    __weak typeof(self) weakSelf = self;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:weakSelf selector:@selector(verifyTimerAction:) userInfo:[NSNumber numberWithInteger:self.tag] repeats:YES];
}

-(void)verifyTimerAction:(NSTimer *)timer{
    
    NSInteger count = --self.tag;
//    self.titleLabel.text = [NSString stringWithFormat:@"%lds%@",(long)count,@"后重新发送"];
    [self setTitle:[NSString stringWithFormat:@"重新发送(%lds)",(long)count] forState:UIControlStateNormal];
    if (count <= 0) {
//        self.titleLabel.text = @"获取验证码";
        [self setTitle:@"重新发送" forState:UIControlStateNormal];
        //        [self setTitleColor:rgbColor(77, 180, 24) forState:UIControlStateNormal];
        [self setEnabled:YES];
        
        if ([timer isValid]) {
            [timer invalidate];
            timer = nil;
        }
    }
}

@end
