//
//  PrepaidRecordsController.m
//  Bohan
//
//  Created by summer on 2018/9/7.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "PrepaidRecordsController.h"
#import "PrepaidRecordsCell.h"
@interface PrepaidRecordsController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation PrepaidRecordsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"充值记录");
    [self.Tableview registerNib:[UINib nibWithNibName:@"PrepaidRecordsCell" bundle:nil] forCellReuseIdentifier:@"PrepaidRecordsCell"];
    self.Tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
}

//3.设置cell之间headerview的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PrepaidRecordsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PrepaidRecordsCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

@end
