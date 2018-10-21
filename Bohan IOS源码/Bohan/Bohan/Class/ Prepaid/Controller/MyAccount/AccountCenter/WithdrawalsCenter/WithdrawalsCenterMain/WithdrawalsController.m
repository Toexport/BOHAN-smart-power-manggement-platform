//
//  WithdrawalsController.m
//  Bohan
//
//  Created by summer on 2018/9/18.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "WithdrawalsController.h"
#import "WithdrawalsTableViewCell.h"
#import "WithdrawalsView.h"
#import "AppLocationManager.h"
#import "PrefixHeader.pch"
#import "ZPPayPopupView.h"
#import "SettingPayController.h"
#import "NewFinancialCARDSController.h"
#import "WithdrawalsPromptController.h"
@interface WithdrawalsController () <UITableViewDelegate,UITableViewDataSource,ZPPayPopupViewDelegate> {
    NSArray * images;
    NSArray * titles;
    NSInteger _selectIndex;
    NSInteger oprentionType; //操作类型 ，0输入密码 1忘记密码
    NSString * titletext;
    NSString * InputBoxText;
}

@property (nonatomic, strong) ZPPayPopupView * payPopupView;

@end

@implementation WithdrawalsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"提款");
    [self.Tableview registerNib:[UINib nibWithNibName:@"WithdrawalsTableViewCell" bundle:nil] forCellReuseIdentifier:@"WithdrawalsTableViewCell"];
    self.Tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
    images = @[@"AlpayPay",@"WechatPay"];
    titles = @[@"支付宝",@"微信"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WithdrawalsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WithdrawalsTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
    cell.TitleImages.image = [UIImage imageNamed:images[_selectIndex]];
    cell.TitleLabel.text = titles[_selectIndex];
    cell.chooseViewBlock = ^(id ChooseView) {
        [self initUIView];
    };
    cell.extractButBlock = ^(id ExtractBut) {
        ZPLog(@"点击了提款按钮");
        [self buttonAction]; // 交易密码
        titletext = cell.TitleLabel.text;
        InputBoxText = cell.InputBoxTextField.text;
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 280;
}

- (void)initUIView {
    WithdrawalsView *view = [[WithdrawalsView alloc] initWithDateStyle:0 BlankBlock:^(NSInteger selectIndex) {
        if (selectIndex >= 0) {
            _selectIndex = selectIndex;
            [self.Tableview reloadData];
        } else {
            NewFinancialCARDSController * NewFinancialCARDS = [[NewFinancialCARDSController alloc]init];
            [self.navigationController pushViewController:NewFinancialCARDS animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
        }
    }];
    [view show];
}

#pragma mark - ZJPayPopupViewDelegate
- (void)buttonAction {
    self.payPopupView = [[ZPPayPopupView alloc] init];
    self.payPopupView.delegate = self;
    [self.payPopupView showPayPopView];
    self.payPopupView.sendBtn.hidden = YES; // 默认隐藏发送验证码
}

- (void)didClickForgetPasswordButton {
    [self.payPopupView hidePayPopView:^(NSInteger selectIndex) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.payPopupView = [[ZPPayPopupView alloc] init];
            NSString *string = USERNAME;
            self.payPopupView.titleLabel.text = [string stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"****"];
            oprentionType = 1;
            self.payPopupView.type = 1;
            self.payPopupView.forgetPasswordButton.hidden = YES;
            self.payPopupView.sendBtn.hidden = NO; // 打开发送验证码
            self.payPopupView.delegate = self;
            [self.payPopupView showPayPopView];
            [self getCodeAction];
        });
    }];
    ZPLog(@"点击了忘记密码");
}

- (void)didPasswordInputFinished:(NSString *)password {
    if (oprentionType) {
        if ([password isEqualToString:@"911853"]){
            ZPLog(@"输入的验证码正确");
            oprentionType = 0;
            [self.payPopupView hidePayPopView:nil];
            [self SettingPay];
        }else {
            ZPLog(@"输入错误:%@",password);
            [self.payPopupView didInputPayPasswordError];
        }
    }else {
        if ([password isEqualToString:@"911855"]){
            [self.payPopupView hidePayPopView:nil];
            [self PassWordPass];
        }else {
            ZPLog(@"输入错误:%@",password);
            [self.payPopupView didInputPayPasswordError];
        }
    }
}
// 密码输入成功
- (void)PassWordPass {
    WithdrawalsPromptController * WithdrawalsPrompt = [[WithdrawalsPromptController alloc]init];
    [self presentViewController:WithdrawalsPrompt animated:YES completion:nil];
    WithdrawalsPrompt.TotalAmountLabel.text = InputBoxText;
    WithdrawalsPrompt.PromptLabel.text = titletext;
    WithdrawalsPrompt.PrivateAccountLabel.text = @"1624";
    ZPLog(@"输入的密码正确");
}

// 设置支付密码
- (void)SettingPay {
    SettingPayController * SetPay = [[SettingPayController alloc]init];
    SetPay.secureEntry = YES;  // 暗文输入
    //    SetPay.isRegist = self.isRegist;
    //    SetPay.username = accountTF.text;
    //    SetPay.code = codeTF.text;
    [self.navigationController pushViewController:SetPay animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
}

// 获取验证码
- (void)getCodeAction {
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSString *language = [df objectForKey:@"App_Language_Switch_Key"];
    NSString *localeLanguageCode = [NSLocale preferredLanguages][0];
    localeLanguageCode = [[localeLanguageCode componentsSeparatedByString:@"-"] firstObject];
    if ((language && [language isEqualToString:@"zh-Hans"]) || (!language && [localeLanguageCode isEqualToString:@"zh"])) {
        NSDictionary *dic = @{@"mobileNum":USERNAME, @"flag":(self.isRegist?@"0":@"1")};
        MyWeakSelf
        [[NetworkRequest sharedInstance] requestWithUrl:GET_REGISTER_CODE_URL parameter:dic completion:^(id response, NSError *error) {
            MyStrongSelf
            //            [strongSelf.view.window stopLoading];
            //请求成功
            if (!error) {
                [HintView showHint:Localize(@"验证码发送成功")];
                [self.payPopupView.sendBtn startTime];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //                    [codeTF becomeFirstResponder];
                });
            }else {
                ZPLog(@"%@",error);
                [HintView showHint:error.localizedDescription];
            }
        }];
    }else {
        NSDictionary *dic = @{@"reciver":USERNAME, @"flag":(self.isRegist?@"0":@"1")};
        ZPLog(@"英文");
        MyWeakSelf
        [[NetworkRequest sharedInstance] requestWithUrl:GET_REGISTER_CODE_BY_MAIL_URL parameter:dic completion:^(id response, NSError *error) {
            MyStrongSelf
            //            [strongSelf.view.window stopLoading];
            //请求成功
            if (!error) {
                [HintView showHint:Localize(@"验证码发送成功")];
                [self.payPopupView.sendBtn startTime];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                });
            }else {
                ZPLog(@"%@",error);
                [HintView showHint:error.localizedDescription];
            }
        }];
    }
}

// 检查验证码
#pragma mark - action
- (void)nextAction {
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSString *language = [df objectForKey:@"App_Language_Switch_Key"];
    NSString *localeLanguageCode = [NSLocale preferredLanguages][0];
    localeLanguageCode = [[localeLanguageCode componentsSeparatedByString:@"-"] firstObject];
    if ((language && [language isEqualToString:@"zh-Hans"]) || (!language && [localeLanguageCode isEqualToString:@"zh"])) {
        [self SettingPay];
    }else {
        [self SettingPay];
        ZPLog(@"英文");
    }
}

@end
