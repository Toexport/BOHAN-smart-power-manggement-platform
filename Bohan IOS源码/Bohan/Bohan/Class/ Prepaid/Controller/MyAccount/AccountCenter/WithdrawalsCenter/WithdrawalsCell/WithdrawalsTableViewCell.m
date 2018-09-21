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
    [self.InputBoxTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(changeValue:)   name:@"changeValue"  object:nil];
}

// 这两个方法实时监控text输入框ID
-(void)textFieldDidChange:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeValue" object:textField];
}

- (void)changeValue:(NSNotification *)notification {
    UITextField * textField = notification.object;
    //要实现的监听方法操作
    ZPLog(@"%@",textField.text);
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
}

// 提款
- (IBAction)ExtractBut:(UIButton *)sender {
    self.extractButBlock(self.AllBut);
}


@end
