//
//  ShareView.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/25.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "ShareView.h"
#import "YLSheetView.h"
#import "DebuggingANDPublishing.pch"
@implementation ShareView

- (IBAction)cancelAction {
    
    [[YLSheetView sharedInstace] closeView];
}

- (IBAction)okAction {
    
    if (tel.text.length == 0) {
        [HintView showHint:@"请输入手机号码"];
    }else if (pwd.text.length == 0) {
        [HintView showHint:@"请输入手机号码"];
    }else if (![Utils isMobileNumber:tel.text]) {
        [HintView showHint:@"手机号码格式错误"];
    }else {
        if (self.submitBlock) {
            self.submitBlock(tel.text, pwd.text);
        }
    }
    
}
// 只可查询数据按钮
- (IBAction)QueryBut:(UIButton *)sender {
    QueryBut.selected =! QueryBut.selected;
//    if (QueryBut.selected ==! QueryBut.selected) {        ChargingBut.selected = NO;
        LoadThresholdBut.selected = NO;
        AllBut.selected = NO;
//    }
}

//可设置充电保护自定义智能用电控制
- (IBAction)ChargingBut:(UIButton *)sender {
    ChargingBut.selected =! ChargingBut.selected;
    QueryBut.selected = NO;
    LoadThresholdBut.selected = NO;
    AllBut.selected = NO;
}

// 设置符合门限
- (IBAction)LoadThresholdBut:(UIButton *)sender {
    LoadThresholdBut.selected =! LoadThresholdBut.selected;
    QueryBut.selected = NO;
    ChargingBut.selected = NO;
    AllBut.selected = NO;
}

// 完全权限
- (IBAction)AllBut:(UIButton *)sender {
    AllBut.selected =! AllBut.selected;
    QueryBut.selected = NO;
    ChargingBut.selected = NO;
    LoadThresholdBut.selected = NO;
}


@end
