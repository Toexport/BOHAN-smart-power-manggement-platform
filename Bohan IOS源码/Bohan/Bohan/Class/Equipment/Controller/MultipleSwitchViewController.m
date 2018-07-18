//
//  MultipleSwitchViewController.m
//  Bohan
//
//  Created by summer on 2018/7/18.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "MultipleSwitchViewController.h"
#import "DebuggingANDPublishing.pch"
@interface MultipleSwitchViewController ()

@end

@implementation MultipleSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"定时开关", nil);
    [self TimeDisplay];
}
// 是否显示2-3号开关
- (void)TimeDisplay {
    if ([self.Coedid containsString:@"61"]) {
        ZPLog(@"%@1个开关",self.Coedid);
        Switch2view.hidden = YES;
        Switch3view.hidden = YES;
        DividerView.hidden = YES;
        Divider2View.hidden = YES;
    }else
        if ([self.Coedid containsString:@"62"]) {
            ZPLog(@"%@2个开关",self.Coedid);
            Switch3view.hidden = YES;
            Divider2View.hidden = YES;
    }else
        if ([self.Coedid containsString:@"63"]) {
            ZPLog(@"%@3个开关",self.Coedid);
            Switch2view.hidden = NO;
            Switch3view.hidden = NO;
            DividerView.hidden = NO;
            Divider2View.hidden = NO;
    }
}

// 开关一
// 开
- (IBAction)Switch1OpenBut:(UIButton *)sender {
    ZPLog(@"开1");
    
}

// 关
- (IBAction)Switch1GuanBut:(UIButton *)sender {
    ZPLog(@"关1");
}

// 开关二
// 开
- (IBAction)Switch2OpenBut:(UIButton *)sender {
    ZPLog(@"开2");
}

// 关
- (IBAction)Switch2GuanBut:(UIButton *)sender {
    ZPLog(@"关2");
}

// 开关三
//开
- (IBAction)Switch3OpenBut:(UIButton *)sender {
    ZPLog(@"开3");
}

// 关
- (IBAction)Switch3GuanBut:(UIButton *)sender {
    ZPLog(@"关3");
}

@end
