//
//  CountDownButton.m
//  UFA
//
//  Created by YangLin on 2017/8/16.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "CountDownButton.h"
#import "NSTimer+Action.h"
#import "DebuggingANDPublishing.pch"
@interface CountDownButton ()
@property (nonatomic, weak) NSTimer *timer;
@end
@implementation CountDownButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)startTime
{
    self.tag = 60;
    //    [self setTitleColor:SubTextColor forState:UIControlStateNormal];
    [self setEnabled:NO];
    
    __weak typeof(self) weakSelf = self;
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:weakSelf selector:@selector(verifyTimerAction:) userInfo:[NSNumber numberWithInteger:self.tag] repeats:YES];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                               block:^{
                                                   __strong typeof(self) strongSelf = weakSelf;
                                                   [strongSelf timeAction];
                                               }
                                             repeats:YES];

}

-(void)timeAction{
    
    NSInteger count = --self.tag;
    //    self.titleLabel.text = [NSString stringWithFormat:@"%lds%@",(long)count,@"后重新发送"];
    [self setTitle:[NSString stringWithFormat:@"重新发送(%lds)",(long)count] forState:UIControlStateNormal];
    if (count <= 0) {
        //        self.titleLabel.text = @"获取验证码";
        [self setTitle:@"重新发送" forState:UIControlStateNormal];
        //        [self setTitleColor:rgbColor(77, 180, 24) forState:UIControlStateNormal];
        [self setEnabled:YES];
        
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

//移除定时器
- (void)removeTimer
{
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}


- (void)dealloc
{
    [self removeTimer];
}

@end
