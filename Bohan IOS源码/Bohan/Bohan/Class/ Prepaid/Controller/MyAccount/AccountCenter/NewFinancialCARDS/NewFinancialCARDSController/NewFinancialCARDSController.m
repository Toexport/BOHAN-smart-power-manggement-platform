//
//  NewFinancialCARDSController.m
//  Bohan
//
//  Created by summer on 2018/9/25.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "NewFinancialCARDSController.h"
#import "NewFinancialCARDSCell.h"
#import "PrefixHeader.pch"
#import "ZJBLStoreShopTypeAlert.h"
@interface NewFinancialCARDSController ()<UITableViewDelegate,UITableViewDataSource> {
    NSArray *titles;
    NSArray * images;
    NSInteger _selectIndex;
    NSString * Pay;
}

@end

@implementation NewFinancialCARDSController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"新增账号");
    [self.tableview registerNib:[UINib nibWithNibName:@"NewFinancialCARDSCell" bundle:nil] forCellReuseIdentifier:@"NewFinancialCARDSCell"];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
//    images = @[@"AlpayPay",@"WechatPay",@"YhkPay"];
    titles = @[@"支付宝",@"微信",@"银联卡"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewFinancialCARDSCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NewFinancialCARDSCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果
    [cell setWhyButBlock:^(id  _Nonnull response) {
        [ZJBLStoreShopTypeAlert showWithTitle:Localize(@"请选择支付方式") images:images titles:titles selectIndex:^(NSInteger selectIndex) {
            _selectIndex = selectIndex;
            Pay = [NSString stringWithFormat:@"%ld",(long)selectIndex];
            [cell updateBalanceView:selectIndex];
        } selectValuee:^(NSString *selectValuee) {
        } selectValue:^(NSString *selectValue) {
        } showCloseButton:YES];
    }];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 400;
}

@end
