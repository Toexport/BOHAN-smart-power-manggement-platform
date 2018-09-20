//
//  WithdrawalsTableViewCell.m
//  Bohan
//
//  Created by summer on 2018/9/18.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "WithdrawalsTableViewCell.h"

@implementation WithdrawalsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
    UITapGestureRecognizer * TapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ChooseViews)];
    self.ChooseView.userInteractionEnabled = YES;
    [self.ChooseView addGestureRecognizer:TapGestureRecognizer];
}

- (void)ChooseViews {
    self.chooseViewBlock(self.ChooseView);
}

- (void)initUI {
    self.TextLabel1.hidden = YES;
    self.TextLabel2.hidden = YES;
}

// 全部提取
- (IBAction)AllBut:(UIButton *)sender {
    ZPLog(@"%@",self.AmountLabel.text);
    self.InputBoxTextField.text = self.AmountLabel.text;
}

// 提款
- (IBAction)ExtractBut:(UIButton *)sender {
    self.extractButBlock(self.AllBut);
}


@end
