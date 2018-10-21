//
//  WithdrawalsPromptController.h
//  Bohan
//
//  Created by summer on 2018/10/19.
//  Copyright © 2018 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawalsPromptController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *TotalAmountLabel; // 提款金额
@property (weak, nonatomic) IBOutlet UILabel *PoundageLabel; // 手续费
@property (weak, nonatomic) IBOutlet UILabel *PromptLabel; // 到账方式
@property (weak, nonatomic) IBOutlet UILabel *PrivateAccountLabel; // 后四位尾号

@end

NS_ASSUME_NONNULL_END
