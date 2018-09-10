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

@interface DetailsPayController ()<UITableViewDelegate,UITableViewDataSource> {
     NSArray *titles;
    NSArray * images;
}

@end

@implementation DetailsPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.DataId;
    [self.Tableview registerNib:[UINib nibWithNibName:@"DetailsPayCell" bundle:nil] forCellReuseIdentifier:@"DetailsPayCell"];
    self.Tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
    images = @[@"yuePay.png",@"AlpayPay.png",@"WechatPay.png",@"YhkPay.png"];
    titles = @[@"余额",@"支付宝",@"微信",@"银联卡"];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    UIViewController *viewCtl = self.navigationController.viewControllers[3];
//    [self.navigationController popToViewController:viewCtl animated:YES];

//    if (self.navigationController.viewControllers.count >=2) {
//
//        UIViewController *listViewController =self.navigationController.viewControllers[3];
//        [self.navigationController popToViewController:listViewController animated:YES];
//    }
//    NSInteger index = (NSInteger)[[self.navigationController viewControllers] indexOfObject:self];
//    if (index > 2) {
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
//    }else{
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    ZPLog(@"111");
//}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsPayCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsPayCell" forIndexPath:indexPath];
    cell.DeviceId.text = self.DataId;
    [cell setBalanceViewBlock:^(id response) {
        [ZJBLStoreShopTypeAlert showWithTitle:Localize(@"请选择支付方式") images:images titles:titles selectIndex:^(NSInteger selectIndex) {
            
        } selectValuee:^(NSString *selectValuee) {
            
        } selectValue:^(NSString *selectValue) {
            
        } showCloseButton:YES];
        ZPLog(@"111");
    }];
    [cell setPayBlockBlock:^(NSString *  DeviceId, NSString *  PayWay, NSString *  PriceLabel) {
        ZPLog(@"222");// 此处选中的是余额需要输入密码，不是余额直接跳过去
        LYPaymentAlertController *paymentAlert = [LYPaymentAlertController alertControllerWithTitle:@"请输入支付密码" numberOfCharacters:6 amount:PriceLabel remarks:DeviceId];
        
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
@end
