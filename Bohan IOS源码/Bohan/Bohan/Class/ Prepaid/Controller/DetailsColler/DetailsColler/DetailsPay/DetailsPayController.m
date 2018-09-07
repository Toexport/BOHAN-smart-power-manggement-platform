//
//  DetailsPayController.m
//  Bohan
//
//  Created by summer on 2018/9/7.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "DetailsPayController.h"
#import "DetailsPayCell.h"
@interface DetailsPayController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DetailsPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.DataId;
    [self.Tableview registerNib:[UINib nibWithNibName:@"DetailsPayCell" bundle:nil] forCellReuseIdentifier:@"DetailsPayCell"];
    self.Tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 225;
}
@end
