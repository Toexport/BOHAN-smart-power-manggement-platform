//
//  MyAccountViewController.m
//  Bohan
//
//  Created by summer on 2018/9/4.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "MyAccountViewController.h"
#import "AccountsPrepaidController.h"
#import "RechargeRecordController.h"
#import "PrefixHeader.pch"
#import "DebuggingANDPublishing.pch"
#import "MyAccountTableViewCell.h"
#import "PrepaidRecordsController.h"
#import "gesturesPasswordController.h"
#import "AccountCenterController.h"
#import "WithdrawalsController.h"
@interface MyAccountViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray * data;

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"我的");
    self.TitleLabel.text = USERNAME;
    [self Registered];
}

- (NSMutableArray *)data {
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    [_data setArray:@[@{@"item":Localize(@"我的账户"),@"image":@"",@"money":@"248.56"}, @{@"item":Localize(@"账户充值"),@"image":@"ic_Forward"},@{@"item":Localize(@"充值记录"),@"image":@"ic_Forward"}, @{@"item":Localize(@"充电记录"),@"image":@"ic_Forward"}]];
    return _data;
}

// 注册Cell
- (void)Registered {
    static NSString * MyAccount = @"MyAccountTableViewCell";
    [self.Tableview registerNib:[UINib nibWithNibName:MyAccount bundle:nil] forCellReuseIdentifier:MyAccount];
    self.Tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
}

#pragma mark -- tabeView delegate
// Cell分组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * MyAccount = @"MyAccountTableViewCell";
    MyAccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MyAccount];
    NSDictionary * dict_ = self.data[indexPath.row];
    cell.TitleLabel.text = dict_[@"item"];
    cell.imageViewS.image = [UIImage imageNamed:dict_[@"image"]];
    cell.MoneyLabel.text = [NSString stringWithFormat:@"￥%@",dict_[@"money"]];
    if (indexPath.row == 0) {
        cell.imageViewS.hidden = YES;
    }
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
        cell.MoneyLabel.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
    return cell;
}

// cell的大小
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

// cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AccountCenterController * AccountCenter = [[AccountCenterController alloc]init];
        [self.navigationController pushViewController:AccountCenter animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
    }else
        if (indexPath.row == 1) {
            AccountsPrepaidController * AccountsPrepaid = [[AccountsPrepaidController alloc]init];
            [self.navigationController pushViewController:AccountsPrepaid animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
        }else
            if (indexPath.row == 2) {
                PrepaidRecordsController * RechargeRecord = [[PrepaidRecordsController alloc]init];
                [self.navigationController pushViewController:RechargeRecord animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
            }else {
                RechargeRecordController * RechargeRecord = [[RechargeRecordController alloc]init];
                [self.navigationController pushViewController:RechargeRecord animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
            }
}

@end
