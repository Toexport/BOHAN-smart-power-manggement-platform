//
//  BaseController.h
//  Bohan
//
//  Created by summer on 2018/9/10.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "LYPaymentSecurityField.h"

@interface BaseController : UIViewController

/**
 安全输入框 LYSecurityField
 */
@property (nonatomic, strong) LYSecurityField *securityField;
/**
 清空按钮 clear button
 */
@property (nonatomic, strong) UIButton *clearButton;

/**
 操作信息展示
 */
@property (nonatomic, strong) UILabel *infoLabel;

@end
