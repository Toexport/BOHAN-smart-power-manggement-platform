//
//  SettingPayController.m
//  Bohan
//
//  Created by summer on 2018/10/10.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "SettingPayController.h"
#import "XMPayCodeView.h"
@interface SettingPayController ()
/// 支付密码输入框
@property (weak, nonatomic) XMPayCodeView *payCodeView;

@end

@implementation SettingPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *tipL = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 30)];
    tipL.text = @"请设置支付密码";
    tipL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipL];
    
    
    // 支付密码输入框
    XMPayCodeView *payCodeView = [[XMPayCodeView alloc]initWithFrame:CGRectMake(0, 180, self.view.bounds.size.width, 60)];
    [self.view addSubview:payCodeView];
    
    // 1.暗文输入，自动验证
    if (self.secureEntry) {
        payCodeView.secureTextEntry = YES;  // 设置暗文
        payCodeView.endEditingOnFinished = YES;  // 完成输入，退出键盘
        // 回调
        [payCodeView setPayBlock:^(NSString *payCode) {
            NSLog(@"payCode==%@",payCode);
            tipL.text = [NSString stringWithFormat:@"你输入的支付密码是%@",payCode];
        }];
    }
    // 1秒后，让密码输入成为第一响应
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [payCodeView becomeKeyBoardFirstResponder];
    });
}

- (void)sureBtnClick:(UIButton *)btn {
    NSString *text = [NSString stringWithFormat:@"你设置的支付密码是%@",_payCodeView.payCode];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:text message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    btn.enabled = NO;
    btn.backgroundColor = [UIColor lightGrayColor];
}


@end
