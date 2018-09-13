//
//  DetailsPayController.m
//  Bohan
//
//  Created by summer on 2018/9/7.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "DetailsPayController.h"
#import "DetailsPayCell.h"
#import "PrefixHeader.pch"
#import "DebuggingANDPublishing.pch"
#import "ZJBLStoreShopTypeAlert.h"
#import "ViewFrame.h"
#import "LYPaymentAlertController.h"

@interface DetailsPayController ()<UITableViewDelegate,UITableViewDataSource,LYPaymentAlertControllerDelegate> {
     NSArray *titles;
    NSArray * images;
    NSInteger _selectIndex;
    NSString * priceString;
}

@end

@implementation DetailsPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.DataId;
    [self.Tableview registerNib:[UINib nibWithNibName:@"DetailsPayCell" bundle:nil] forCellReuseIdentifier:@"DetailsPayCell"];
    self.Tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
    images = @[@"yuePay",@"AlpayPay",@"WechatPay",@"YhkPay"];
    titles = @[@"余额",@"支付宝",@"微信",@"银联卡"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


//重写好返回按钮后执行这个方法
- (void)backAction {
    NSArray *array =self.navigationController.viewControllers;
    for (UIViewController *vc in array) {
        if ([NSStringFromClass(vc.class) isEqualToString:@"DetailsViewController"]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __block DetailsPayCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsPayCell" forIndexPath:indexPath];
    cell.DeviceId.text = self.DataId;
    MyWeakSelf
    [cell setBalanceViewBlock:^(id response) {
        [ZJBLStoreShopTypeAlert showWithTitle:Localize(@"请选择支付方式") images:images titles:titles selectIndex:^(NSInteger selectIndex) {
            _selectIndex = selectIndex;
            [cell updateBalanceView:selectIndex];
        } selectValuee:^(NSString *selectValuee) {
            
        } selectValue:^(NSString *selectValue) {
            
        } showCloseButton:YES];
        ZPLog(@"111");
    }];
    
    [cell setPayBlockBlock:^(NSString *  DeviceId, NSString *  PayWay, NSString *  PriceLabel) {
        priceString = [NSString stringWithFormat:@"%@",PriceLabel];
        ZPLog(@"222");// 此处选中的是余额需要输入密码，不是余额直接跳过去
        LYPaymentAlertController *paymentAlert = [LYPaymentAlertController alertControllerWithTitle:@"请输入支付密码" numberOfCharacters:6 amount:PriceLabel remarks:DeviceId];
        paymentAlert.delegate = weakSelf;
        paymentAlert.contentOffset = CGSizeMake(0, 50);
        paymentAlert.presentingStyle = AlertPresentStyleTopToCenterSpring;
        paymentAlert.dismissStyle = AlertPresentStyleCenterSpring;
        [self presentViewController:paymentAlert animated:YES completion:nil];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 360;
}

//  输入完成打印的结果
- (void)lYPaymentController:(LYPaymentAlertController *)paymentController securityTextOfCompeletion:(NSString *)securityText {
    ZPLog(@"现在使用的是：%@支付%@==密码是：%@",titles[_selectIndex],priceString,securityText);
}

@end
