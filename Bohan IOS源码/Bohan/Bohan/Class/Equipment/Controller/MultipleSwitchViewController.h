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
//    __weak IBOutlet UIView *coverView;
    
    //    开关一
    __weak IBOutlet UIView *Switch1view;
    //    __weak IBOutlet NSLayoutConstraint *View1LayoutConstraint;
    __weak IBOutlet UITextField *Years1TextField;  // 年
    __weak IBOutlet UITextField *Month1TextField; // 月
    __weak IBOutlet UITextField *Day1textField;  // 日
    __weak IBOutlet UITextField *Hours1TextField; //时
    __weak IBOutlet UITextField *Minutes1TextField; // 分
    __weak IBOutlet UIButton *Open1But; // 开
    __weak IBOutlet UIButton *Guan1But; // 关
//    __weak IBOutlet UILabel *Prompt1Label; //提示文字
    
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
@property (nonatomic, copy) NSString * SwitchStateStr;
/***************开关1************/
@property (nonatomic, copy) NSString * string1;
@property (nonatomic, copy) NSString * string2;
@property (nonatomic, copy) NSString * string3;
@property (nonatomic, copy) NSString * string4;
@property (nonatomic, copy) NSString * string5;

@property (nonatomic, copy) NSString * stringg1;
@property (nonatomic, copy) NSString * stringg2;
@property (nonatomic, copy) NSString * stringg3;
@property (nonatomic, copy) NSString * stringg4;
@property (nonatomic, copy) NSString * stringg5;
/***************开关2************/
@property (nonatomic, copy) NSString * string11;
@property (nonatomic, copy) NSString * string22;
@property (nonatomic, copy) NSString * string33;
@property (nonatomic, copy) NSString * string44;
@property (nonatomic, copy) NSString * string55;

@property (nonatomic, copy) NSString * stringg11;
@property (nonatomic, copy) NSString * stringg22;
@property (nonatomic, copy) NSString * stringg33;
@property (nonatomic, copy) NSString * stringg44;
@property (nonatomic, copy) NSString * stringg55;
/***************开关3************/
@property (nonatomic, copy) NSString * stringg111;
@property (nonatomic, copy) NSString * stringg222;
@property (nonatomic, copy) NSString * stringg333;
@property (nonatomic, copy) NSString * stringg444;
@property (nonatomic, copy) NSString * stringg555;

@property (nonatomic, copy) NSString * string111;
@property (nonatomic, copy) NSString * string222;
@property (nonatomic, copy) NSString * string333;
@property (nonatomic, copy) NSString * string444;
@property (nonatomic, copy) NSString * string555;
@property (weak, nonatomic) IBOutlet UIButton *TurnOnSwitch1; // 开
@property (weak, nonatomic) IBOutlet UIButton *TurnOnSwitch2;
@property (weak, nonatomic) IBOutlet UIButton *TurnOnSwitch3;



@end
