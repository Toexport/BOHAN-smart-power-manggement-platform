//
//  WithdrawalsTableViewCell.h
//  Bohan
//
//  Created by summer on 2018/9/18.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawalsTableViewCell : UITableViewCell 

/**
 当输入框输入文字时需要隐藏
 当输入框输入文字大于当前文字时需要隐藏
 */
@property (weak, nonatomic) IBOutlet UILabel *TextLabel; // 文字label
@property (weak, nonatomic) IBOutlet UILabel *TextLabel1; // 提示label
@property (weak, nonatomic) IBOutlet UILabel *TextLabel2; // 提示label2

/**********************************/

@property (weak, nonatomic) IBOutlet UIView *ChooseView; // 选择支付方式View
@property (weak, nonatomic) IBOutlet UIImageView *TitleImages; // 标题图片
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel; // 标题文字
@property (weak, nonatomic) IBOutlet UITextField *InputBoxTextField; // 输入框
@property (weak, nonatomic) IBOutlet UILabel *AmountLabel; // 金额Label
@property (weak, nonatomic) IBOutlet UIButton *AllBut; // 全部提取
@property (weak, nonatomic) IBOutlet UIButton *ExtractBut; // 提款

typedef void (^ChooseViewBlock)(id ChooseView);
@property (nonatomic , copy) ChooseViewBlock chooseViewBlock;

typedef void (^ExtractButBlock)(id ExtractBut);
@property (nonatomic , copy) ExtractButBlock extractButBlock;

@end
