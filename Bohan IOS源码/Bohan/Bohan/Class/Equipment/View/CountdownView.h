//
//  CountdownView.h
//  Bohan
//
//  Created by summer on 2018/8/2.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountdownView : UIView

{
    
    __weak IBOutlet UIButton *SettingBut; // 设置按钮
    __weak IBOutlet UITextField *YearTextField; // 年
    __weak IBOutlet UITextField *MonthTextField; // 月
    __weak IBOutlet UITextField *DayTextField; // 日
    __weak IBOutlet UITextField *HoursTextField; // 时
    __weak IBOutlet UITextField *MinutesTextField; // 分
    /***************************显示时间******************/
    
    __weak IBOutlet UITextField *YYYYTextField;  // 年
    __weak IBOutlet UITextField *mmTextField;   // 月
    __weak IBOutlet UITextField *DDTextField;  // 日
    __weak IBOutlet UITextField *HHTextField;  // 时
    __weak IBOutlet UITextField *MMTextField; // 分
}


@property (nonatomic, strong) NSString * string1;
@property (nonatomic, strong) NSString * string2;
@property (nonatomic, strong) NSString * string3;
@property (nonatomic, strong) NSString * string4;
@property (nonatomic, strong) NSString * string5;

@property (nonatomic, strong) NSString * string11;
@property (nonatomic, strong) NSString * string22;
@property (nonatomic, strong) NSString * string33;
@property (nonatomic, strong) NSString * string44;
@property (nonatomic, strong) NSString * string55;
@end
