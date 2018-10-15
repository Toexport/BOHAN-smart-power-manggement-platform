//
//  NewFinancialCARDSCell.h
//  Bohan
//
//  Created by summer on 2018/9/25.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewFinancialCARDSCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *WhyLabel;
@property (weak, nonatomic) IBOutlet UIButton *WhyBut;
@property (weak, nonatomic) IBOutlet UITextField *NameTExtField;
@property (weak, nonatomic) IBOutlet UITextField *AccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *ConfirmAccountTextField;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmBut;

@end

NS_ASSUME_NONNULL_END
