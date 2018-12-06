//
//  UIButton+countDown.m
//  DDAYGO
//
//  Created by Summer on 2017/11/2.
//  Copyright © 2017年 Summer. All rights reserved.
//

#import "UIButton+countDown.h"

@implementation UIButton (countDown)
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color {
    
    __weak typeof(self) weakSelf = self;
//  倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//  每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
//  倒计时结束，关闭,标题设置为完成标题,并且要设定倒数时间不等于现在剩余时间
    if (timeOut <= 0 || ([self.titleLabel.text isEqualToString:title] && timeOut != timeLine)) {
        dispatch_source_cancel(_timer);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.backgroundColor = mColor;
            [weakSelf setTitle:title forState:UIControlStateNormal];
            weakSelf.userInteractionEnabled = YES;
        });
    } else {
        int allTime = (int)timeLine + 1;
        int seconds = timeOut % allTime;
        NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.backgroundColor = color;
            [weakSelf setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
            weakSelf.userInteractionEnabled = NO;
        });
        timeOut--;
    }
});
    dispatch_resume(_timer);
}

- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title titleColor:(UIColor *)tColor countDownTitle:(NSString *)subTitle countDownTitleColor:(UIColor *)cColor mainColor:(UIColor *)mColor countColor:(UIColor *)color {
    __weak typeof(self) weakSelf = self;
//  倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//  每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
//        NSLog(@"self.titleLabel.text-->%@",self.titleLabel.text);
        
//  倒计时结束，关闭,标题设置为完成标题,并且要设定倒数时间不等于现在剩余时间
    if (timeOut <= 0 || ([self.titleLabel.text isEqualToString:title] && timeOut != timeLine)) {
        dispatch_source_cancel(_timer);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.backgroundColor = mColor;
            [weakSelf setTitle:title forState:UIControlStateNormal];
            weakSelf.userInteractionEnabled = YES;
            [weakSelf setTitleColor:tColor forState:UIControlStateNormal];
                
        });
    } else {
        int allTime = (int)timeLine + 1;
        int seconds = timeOut % allTime;
        NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.backgroundColor = color;
            [weakSelf setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
            weakSelf.userInteractionEnabled = NO;
            [weakSelf setTitleColor:cColor forState:UIControlStateNormal];
        });
        timeOut--;
    }
});
    dispatch_resume(_timer);
}

-  (void)cancelCountDownWith:(NSString *)title {
//  延迟一秒，确保timeOut != timeLine
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setTitle:title forState:UIControlStateNormal];
    });
}

@end
