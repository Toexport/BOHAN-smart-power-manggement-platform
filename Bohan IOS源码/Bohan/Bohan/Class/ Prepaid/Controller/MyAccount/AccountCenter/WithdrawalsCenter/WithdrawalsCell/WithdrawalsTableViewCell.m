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
    [self.ExtractBut setEnabled:NO];
    self.ExtractBut.alpha = 0.4;
    UITapGestureRecognizer * TapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ChooseViews)];
    self.ChooseView.userInteractionEnabled = YES;
    [self.ChooseView addGestureRecognizer:TapGestureRecognizer];
    [self.InputBoxTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(changeValue:)   name:@"changeValue"  object:nil];
}

// 这两个方法实时监控text输入框ID
-(void)textFieldDidChange:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeValue" object:textField];
}

- (void)changeValue:(NSNotification *)notification {
    UITextField * textField = notification.object;
    if (textField.text.length > 0) {
        self.TextLabel2.hidden = NO;
        self.TextLabel.hidden = YES;
        self.AmountLabel.hidden = YES;
        self.AllBut.hidden = YES;
        [self.ExtractBut setEnabled:YES];
        self.ExtractBut.alpha = 100;
    }else {
        self.TextLabel2.hidden = YES;
        self.TextLabel.hidden = NO;
        self.AmountLabel.hidden = NO;
        self.AllBut.hidden = NO;
        [self.ExtractBut setEnabled:NO];
        self.ExtractBut.alpha = 0.4;
    }
    if (self.InputBoxTextField.text > self.AmountLabel.text) {
        self.TextLabel1.hidden = NO;
        self.TextLabel2.hidden = YES;
        ZPLog(@"111");
    }else {
      self.TextLabel1.hidden = YES;
    }
    
    //要实现的监听方法操作
    ZPLog(@"%lu",textField.text.length);
    if (textField.text.length > 5) {
        ZPLog(@"输入有误");
        return;
    }
}

- (void)initUI {
//    self.TextLabel1.hidden = YES;
//    self.TextLabel2.hidden = YES;
}

- (void)ChooseViews {
    self.chooseViewBlock(self.ChooseView);
}

// 全部提取
- (IBAction)AllBut:(UIButton *)sender {
    ZPLog(@"%@",self.AmountLabel.text);
    self.InputBoxTextField.text = self.AmountLabel.text;
    if (self.InputBoxTextField.text.length > 0) {
        self.TextLabel2.hidden = NO;
        self.TextLabel.hidden = YES;
        self.AmountLabel.hidden = YES;
        self.AllBut.hidden = YES;
        [self.ExtractBut setEnabled:YES];
        self.ExtractBut.alpha = 100;
    }
}

// 提款
- (IBAction)ExtractBut:(UIButton *)sender {
    self.extractButBlock(self.AllBut);
}

@end
