//
//  MultipleSwitchViewController.h
//  Bohan
//
//  Created by summer on 2018/7/18.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "BaseViewController.h"
#import "DeviceModel.h"
@interface MultipleSwitchViewController : BaseViewController {
    __weak IBOutlet UIScrollView *scrollView;
    
    //    开关一
    __weak IBOutlet UIView *Switch1view;
    __weak IBOutlet UITextField *Years1TextField;  // 年
    __weak IBOutlet UITextField *Month1TextField; // 月
    __weak IBOutlet UITextField *Day1textField;  // 日
    __weak IBOutlet UITextField *Hours1TextField; //时
    __weak IBOutlet UITextField *Minutes1TextField; // 分
    __weak IBOutlet UIButton *Open1But; // 开
    __weak IBOutlet UIButton *Guan1But; // 关
    
//     开关二
     __weak IBOutlet NSLayoutConstraint *View2LayoutConstraint;
    __weak IBOutlet UILabel *Label2Text;
    __weak IBOutlet UIView *Switch2view; // 开关2View
    __weak IBOutlet UITextField *Years2TextField; // 年
    __weak IBOutlet UITextField *Month2TextField; // 月
    __weak IBOutlet UITextField *Day2textField; // 日
    __weak IBOutlet UITextField *Hours2TextField; // 时
    __weak IBOutlet UITextField *Minutes2TextField; // 分
    __weak IBOutlet UIButton *Open2But; // 开
    __weak IBOutlet UIButton *Guan2But; // 关
    
//     开关三
    __weak IBOutlet NSLayoutConstraint *View3LayoutConstraint;
    __weak IBOutlet UILabel *Label3Text;
    __weak IBOutlet UIView *DividerView; // 分割线
    __weak IBOutlet UIView *Switch3view; // 开关3View
    __weak IBOutlet UITextField *Years3TextField; // 年
    __weak IBOutlet UITextField *Month3TextField; // 月
    __weak IBOutlet UITextField *Day3textField; // 日
    __weak IBOutlet UITextField *Hours3TextField; // 时
    __weak IBOutlet UITextField *Minutes3TextField; // 分
    __weak IBOutlet UIButton *Open3But; // 开
    __weak IBOutlet UIButton *Guan3But; // 关
    __weak IBOutlet UIView *Divider2View; // 分割线
    __weak IBOutlet NSLayoutConstraint *View4LayoutConstraint;
    
}

@property (nonatomic, copy) NSString *deviceNo; // 设备编码
@property (nonatomic, copy) NSString * str1;
@property (nonatomic, copy) NSString * str2;
@property (nonatomic, copy) NSString * str3;
@property (nonatomic, copy) NSString * str11;
@property (nonatomic, copy) NSString * str22;
@property (nonatomic, copy) NSString * str33;
@property (nonatomic, copy) NSString * SwitchStateStr;

/***************开关1************/
@property (nonatomic, copy) NSString * string1;
@property (nonatomic, copy) NSString * string2;
@property (nonatomic, copy) NSString * string3;
@property (nonatomic, copy) NSString * string4;
@property (nonatomic, copy) NSString * string5;

/***************开关2************/
@property (nonatomic, copy) NSString * string11;
@property (nonatomic, copy) NSString * string22;
@property (nonatomic, copy) NSString * string33;
@property (nonatomic, copy) NSString * string44;
@property (nonatomic, copy) NSString * string55;

/***************开关3************/
@property (nonatomic, copy) NSString * string111;
@property (nonatomic, copy) NSString * string222;
@property (nonatomic, copy) NSString * string333;
@property (nonatomic, copy) NSString * string444;
@property (nonatomic, copy) NSString * string555;

@property (weak, nonatomic) IBOutlet UIButton *TurnOnSwitch1;
@property (weak, nonatomic) IBOutlet UIButton *TurnOnSwitch2;
@property (weak, nonatomic) IBOutlet UIButton *TurnOnSwitch3;

@property (weak, nonatomic) IBOutlet UIButton *Title1But;
@property (weak, nonatomic) IBOutlet UIButton *Title2But;
@property (weak, nonatomic) IBOutlet UIButton *Title3But;



@end
