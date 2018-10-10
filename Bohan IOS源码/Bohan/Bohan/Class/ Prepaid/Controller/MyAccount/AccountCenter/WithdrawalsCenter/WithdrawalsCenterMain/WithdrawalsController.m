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
@interface WithdrawalsController () <UITableViewDelegate,UITableViewDataSource,ZPPayPopupViewDelegate> {
    NSArray * images;
    NSArray * titles;
    NSInteger _selectIndex;
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
        //        [self SettingPay];
        [self buttonAction]; // 交易密码
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 280;
}

- (void)initUIView {
    WithdrawalsView *view = [[WithdrawalsView alloc] initWithDateStyle:0 BlankBlock:^(NSInteger selectIndex) {
        _selectIndex = selectIndex;
        [self.Tableview reloadData];
    }];
    [view show];
}
// 设置支付密码
- (void)SettingPay {
    SettingPayController * Pay = [[SettingPayController alloc]init];
    Pay.secureEntry = YES;  // 暗文输入
    [self.navigationController pushViewController:Pay animated:YES];
}

#pragma mark - ZJPayPopupViewDelegate
- (void)buttonAction {
    self.payPopupView = [[ZPPayPopupView alloc] init];
    self.payPopupView.delegate = self;
    [self.payPopupView showPayPopView];
}

- (void)didClickForgetPasswordButton {
    [self.payPopupView hidePayPopView:^(NSInteger selectIndex) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.payPopupView = [[ZPPayPopupView alloc] init];
            NSString *string = @"13538613874";
            self.payPopupView.titleLabel.text = [string stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"****"];
            self.payPopupView.forgetPasswordButton.hidden = YES;
            self.payPopupView.delegate = self;
            [self.payPopupView showPayPopView];
        });
    }];
    NSLog(@"点击了忘记密码");
}

- (void)didPasswordInputFinished:(NSString *)password {
    if ([password isEqualToString:@"911853"]){
        [self didClickForgetPasswordButton];
        NSLog(@"输入的密码正确");
        [self.payPopupView showPayPopView];
    }else {
        NSLog(@"输入错误:%@",password);
        [self.payPopupView didInputPayPasswordError];
    }
}

@end
