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
    ZPLog(@"111");
    WithdrawalsView *datepicker = [[WithdrawalsView alloc]initWithDateStyle:nil BlankBlock:^(NSDate *date) {
        ZPLog(@"111");
    }];
//    datepicker.hideBackgroundYearLabel = YES;
//    datepicker.dateLabelColor = kDefualtColor;
//    datepicker.doneButtonColor = kDefualtColor;
    [datepicker show];
}

//// 这两个方法实时监控text输入框ID
//-(void)textFieldDidChange:(UITextField *)textField {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeValue" object:textField];
//}

//- (void)changeValue:(NSNotification *)notification {
//    UITextField * textField = notification.object;
//    //要实现的监听方法操作
//    ZPLog(@"%@",textField.text);
//    if (textField.text.length > 8) {
//        return;
//    }
//}



@end
