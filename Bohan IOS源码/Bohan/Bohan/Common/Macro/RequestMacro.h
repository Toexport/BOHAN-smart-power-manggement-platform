//
//  RequestMacro.h
//  AppKit
//
//  Created by YangLin on 2017/12/18.
//  Copyright © 2017年 YangLin. All rights reserved.
//

#ifndef RequestMacro_h
#define RequestMacro_h

#import <UIKit/UIKit.h>


//字符串常量尽量不要用#define定义，因为宏定义是在预编译时将所有定义的标识符替换为对应的字符或语句。而const是运行时指向对应内存位置的指针

/**
 *  个人中心模块接口
 */

//验证验证码接口
static NSString *const CHECK_CODE_URL = @"ValidateCheckCode";

//注册获取验证码接口
//获取注册/重置密码验证码 传入参数:手机号码;操作标志(0:注册；1：重置密码)

static NSString *const GET_REGISTER_CODE_URL = @"GetRegisterCode";


//获取注册/重置密码验证码 传入参数:邮件地址;操作标志(0:注册；1：重置密码)
static NSString *const GET_REGISTER_CODE_BY_MAIL_URL = @"GetRegisterCodeByMail";

//注册接口
//用户注册/重置密码 （传入参数：用户名；密码；验证码;操作标志(0:注册；1：重置密码)）
static NSString *const REGISTER_URL = @"Register";

//登录接口
static NSString *const LOGIN_URL = @"Login";

//获取APP版本号接口
static NSString *const GET_APP_VERSION_URL = @"GetAppVersion";


//获取用户反馈分类
static NSString *const GET_CLASSIFICATION_URL = @"GetClassification";


//用户反馈 传入参数:问题分类;用户反馈文字
static NSString *const FEEDBACK_URL = @"UserFeedback";



/**
 *  设备列表模块接口
 */

//获取单个设备信息 （传入参数：设备编号）
static NSString *const GET_DEVICE_INFO_URL = @"GetDeviceInfo";


//获取电器品牌列表(如：美的，格力)
static NSString *const GET_BRAND_LIST_URL = @"GetLoadBrandList";

//获取电器名称列表(如：空调，冰箱)
static NSString *const GET_NAME_LIST_URL = @"GetLoadNameList";

//获取电器位置列表(如：客厅，卧室)
static NSString *const GET_POS_NAME_LIST_URL = @"GetPosNameList";




/**
 *  设备管理模块接口
 */

//获取当前连接用户下所有设备列表 传入参数：电器位置(如:客厅 可空)；电器名称(如：空调 可空)
static NSString *const GET_DEVICE_LIST_URL = @"GetUserDeviceList";


//绑定设备接口
//绑定设备 （传入参数：设备编号；设备Key；电器位置；电器名称；电器品牌）
static NSString *const BINDING_DEVICE_URL = @"BindingDevice";


//解绑设备 （传入参数：设备编号；设备Key）
static NSString *const UNBINDING_DEVICE_URL = @"UnbindDevice";


//修改单个设备信息 （传入参数：设备编号(必选)；电器位置；电器名称；电器品牌(至少传入一个)）
static NSString *const MODIFY_DEVICE_INFO_URL = @"ModifyDeviceInfo";


//分享设备 传入参数:设备编号(多个设备用逗号分割),手机号码,密码;操作标志(0:注册；1：重置密码)
static NSString *const SHARE_DEVICE_URL = @"ShareDevice";

/**
 *  所有用电模块接口
 */
//获取某设备某一日24个小时时段用电量及平均功率 传入参数:设备编号(如：681609050101);年月(如:20170101)
static NSString *const GET_DAY_DETAIL_POWER = @"GetDeviceDayDetailPowerData";
//获取某设备某一月每天用电量及平均功率 传入参数:设备编号(如：681609050101);年月(如:201701)

//获取某设备某一月每天用电量及平均功率 传入参数:设备编号(如：681609050101);年月(如:201701)
static NSString *const GET_MONTH_DETAIL_POWER = @"GetDeviceMonthDetailPowerData";

//获取某设备某一年每个月用电量及平均功率 传入参数:设备编号(如：681609050101);年(如:2017)
static NSString *const GET_YERA_DETAIL_POWER = @"GetDeviceYearDetailPowerData";


//获取当前连接用户下所有设备某天按时段分组统计用电总量 传入参数:年月日(如:20170101)
static NSString *const GET_DAY_TOTAL_POWER = @"GetUserDayTotalPowerData";


//获取当前连接用户下所有设备某月按天分组统计用电总量 传入参数:年月(如:201701)
static NSString *const GET_MONTH_TOTAL_POWER = @"GetUserMonthTotalPowerData";

//获取当前连接用户下所有设备某年按月分组统计用电总量 传入参数:年(如:2017)
static NSString *const GET_YEAR_TOTAL_POWER = @"GetUserYearTotalPowerData";



static NSString *const SERVER = @"http://www.bohanserver.top:8088/webservice.asmx?wsdl/";

#endif /* RequestMacro_h */
