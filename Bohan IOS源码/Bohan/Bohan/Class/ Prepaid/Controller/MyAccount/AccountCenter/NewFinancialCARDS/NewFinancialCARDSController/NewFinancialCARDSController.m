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
@interface NewFinancialCARDSController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation NewFinancialCARDSController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"新增账号");
    [self.tableview registerNib:[UINib nibWithNibName:@"NewFinancialCARDSCell" bundle:nil] forCellReuseIdentifier:@"NewFinancialCARDSCell"];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewFinancialCARDSCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NewFinancialCARDSCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 320;
}

@end
