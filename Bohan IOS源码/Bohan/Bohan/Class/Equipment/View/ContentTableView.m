
//
//  ContentTableView.m
//  UFA
//
//  Created by mac on 2017/7/25.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "ContentTableView.h"
#import "EquipmentTableViewCell.h"
#import "UIScrollView+Refresh.h"
#import "DebuggingANDPublishing.pch"
@interface ContentTableView ()<UITableViewDataSource, UITableViewDelegate>

@end

static NSString *cellIdentifier =@"EquipmentTableViewCell";

@implementation ContentTableView

#pragma mark - 懒加载

-(void)setUp{

    self.delegate = self;
    self.dataSource = self;

    
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedRowHeight = 110;
    [self registerNib:[UINib nibWithNibName:@"EquipmentTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
     self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.datas = [NSArray array];
    
    self. separatorColor =rgbColor(242, 242, 242);
    self.backgroundColor = rgbColor(242, 242, 242);
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       return self.datas.count;
 
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    EquipmentTableViewCell  *cell = (EquipmentTableViewCell *)[tableView dequeueReusableCellWithIdentifier: cellIdentifier forIndexPath:indexPath];
    cell.delegate = self.actionDelegate;
    cell.name.text = self.datas[indexPath.row];
    return cell;
}
#pragma mark 按钮的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!tableView.isEditing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (self.didSelectedBlock) {
            self.didSelectedBlock(self.datas[indexPath.row]);
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Width(50);
}
@end
