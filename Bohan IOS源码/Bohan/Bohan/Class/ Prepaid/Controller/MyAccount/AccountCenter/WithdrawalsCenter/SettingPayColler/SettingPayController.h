//
//  SettingPayController.h
//  Bohan
//
//  Created by summer on 2018/10/10.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingPayController : UIViewController
@property (nonatomic, assign) BOOL isRegist;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *code;
/// 是否暗文输入
@property (assign, nonatomic) BOOL secureEntry;

@end

NS_ASSUME_NONNULL_END
