//
//  WithdrawalsController.m
//  Bohan
//
//  Created by summer on 2018/9/18.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "WithdrawalsController.h"
#import "WithdrawalsTableViewCell.h"
#import "WithdrawalsView.h"
@interface WithdrawalsController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation WithdrawalsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"提款");
    [self.Tableview registerNib:[UINib nibWithNibName:@"WithdrawalsTableViewCell" bundle:nil] forCellReuseIdentifier:@"WithdrawalsTableViewCell"];
    self.Tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WithdrawalsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WithdrawalsTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
    cell.chooseViewBlock = ^(id ChooseView) {
        [self initUIView];
    };
    cell.extractButBlock = ^(id ExtractBut) {
        ZPLog(@"点击了提款按钮");
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 280;
}

- (void)initUIView {
    WithdrawalsView *view = [[WithdrawalsView alloc] initWithDateStyle:0 BlankBlock:^(NSDate *date) {
//        view.ClickBut = ^(NSString *ClickBut) {
//            [self.navigationController pushViewController:ClickBut animated:YES];
//        };
        
    }];
    [view show];
}

@end
