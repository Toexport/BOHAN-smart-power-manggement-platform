//
//  DeviceInfoViewController.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/16.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "BaseViewController.h"
@class DeviceModel;
@interface DeviceInfoViewController : BaseViewController


@property (nonatomic, strong) DeviceModel *model;
@property (nonatomic, assign) NSString * type; // ID
@property (nonatomic, strong) NSString * sortt;
@property (nonatomic, strong) NSString * TitleStr;// 文字状态

@property (weak, nonatomic) IBOutlet UIView *PayView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *StateViewLayoutConstraint; // 状态
/***********校时**********/
@property (nonatomic, strong) NSString * YearStr; // 年
@property (nonatomic, strong) NSString * MonthStr; // 月
@property (nonatomic, strong) NSString * DayStr; // 日
@property (nonatomic, strong) NSString * WeekStr; // 星期
@property (nonatomic, strong) NSString * HourStr; // 时
@property (nonatomic, strong) NSString * MinuteStr; // 分
@property (nonatomic, strong) NSString * SecondStr; // 秒
@property (nonatomic, strong) NSString * Ymdhms;
@end
