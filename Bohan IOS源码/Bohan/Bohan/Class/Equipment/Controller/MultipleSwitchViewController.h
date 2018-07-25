//
//  MultipleSwitchViewController.h
//  Bohan
//
//  Created by summer on 2018/7/18.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "BaseViewController.h"
#import "DeviceModel.h"
@interface MultipleSwitchViewController : BaseViewController
{
    __weak IBOutlet UIScrollView *scrollView;
    //    开关一
    __weak IBOutlet UITextField *Years1TextField;  // 年
    __weak IBOutlet UITextField *Month1TextField; // 月
    __weak IBOutlet UITextField *Day1textField;  // 日
    __weak IBOutlet UITextField *Hours1TextField; //时
    __weak IBOutlet UITextField *Minutes1TextField; // 分
    __weak IBOutlet UIButton *Open1But; // 开
    __weak IBOutlet UIButton *Guan1But; // 关
//     开关二
    __weak IBOutlet UIView *Switch2view; // 开关2View
    __weak IBOutlet UITextField *Years2TextField; // 年
    __weak IBOutlet UITextField *Month2TextField; // 月
    __weak IBOutlet UITextField *Day2textField; // 日
    __weak IBOutlet UITextField *Hours2TextField; // 时
    __weak IBOutlet UITextField *Minutes2TextField; // 分
    __weak IBOutlet UIButton *Open2But; // 开
    __weak IBOutlet UIButton *Guan2But; // 关
//     开关三
    
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
    
}
@property (nonatomic, copy) NSString *deviceNo; // 设备编码
@property (nonatomic, strong) NSString * str1;
@property (nonatomic, strong) NSString * str2;
@property (nonatomic, strong) NSString * str3;




@end
