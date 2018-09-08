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
    images = @[@"yuePay",@"AlpayPay",@"WechatPay",@"YhkPay"];
//    images = @{@"",}
    titles = @[@"余额",@"支付宝",@"微信",@"银联卡"];
}

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
            
        } selectValuee:^(NSString *selectValue) {
            
        } selectValue:^(NSString *selectValue) {
            
        } showCloseButton:YES];
        ZPLog(@"111");
    }];
    
    [cell setPayBlockBlock:^(id DeviceId, id PayWay, id PriceLabel) {
        ZPLog(@"222");
        
    }];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 360;
}
@end
