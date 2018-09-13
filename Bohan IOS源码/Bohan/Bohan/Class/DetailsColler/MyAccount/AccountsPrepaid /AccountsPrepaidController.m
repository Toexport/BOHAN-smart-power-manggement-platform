//
//  AccountsPrepaidController.m
//  Bohan
//
//  Created by summer on 2018/9/4.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "AccountsPrepaidController.h"
#import "DebuggingANDPublishing.pch"
#import "PrefixHeader.pch"
#import "AccountsPrepaidCell.h"
@interface AccountsPrepaidController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation AccountsPrepaidController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"账户充值");
    [self.Tableview registerNib:[UINib nibWithNibName:@"AccountsPrepaidCell" bundle:nil] forCellReuseIdentifier:@"AccountsPrepaidCell"];
    self.Tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountsPrepaidCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AccountsPrepaidCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 400;
}

@end
