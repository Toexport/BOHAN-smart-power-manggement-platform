//
//  ParamsSettingViewController.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/20.
//  Copyright © 2018年 Bohan. All rights reserved.
//
#import "ParamsSettingViewController.h"
#import "UIViewController+NavigationBar.h"
#import "SGActionView.h"
#import "DebuggingANDPublishing.pch"
#import "TimeSettingModel.h"
#import "CommonOperation.h"
#import "TimeSettingListViewController.h"

@interface ParamsSettingViewController ()
{
    NSDateFormatter *formatter;
    NSMutableArray *muniteArr;
    NSMutableArray *powerArr;
    NSIndexPath *selectedIndexPath;
    BOOL isParentModel;
    NSString *_content;
}

@property (nonatomic, strong)NSMutableArray *datas;
@end
@implementation ParamsSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"增值服务");
    [self rightBarTitle:Localize(@"刷新") color:[UIColor whiteColor] action:@selector(deviceParams)];
//    [self GetDatas];
    muniteArr = [NSMutableArray array];
    powerArr = [NSMutableArray array];
    for (int i = 0; i<60; i++) {
        [muniteArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for (int i = 0; i<100; i++) {
        [powerArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [deviceId setText:[NSString stringWithFormat:@"ID:%@",self.dNo]];
    [self deviceParams];
    [self configNoData];// 打开这个不显示家长模式是否开启
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStauts:) name:CHANGETIMEMODEL object:nil];
}

- (void)deviceParams {
    [self GetDatas];
//    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadData];
}

- (void)updateStauts:(NSNotification *)noti {
    NSDictionary *dic = noti.object;
    ParentsModeBut.selected = dic;
    isParentModel = ParentsModeBut.selected;
}

// 获取数据
- (void)GetDatas {
    self.datas = [NSMutableArray array];
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0023";
    model.deviceNo = self.dNo;
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        ZPLog(@"%@",response);
        if ([self.Coedid containsString:@"YC"] || [self.Coedid containsString:@"YC10"] || [self.Coedid containsString:@"YC16"] || [self.Coedid containsString:@"YCGP10"] || [self.Coedid containsString:@"YCGP16"] || [self.Coedid containsString:@"QC"] || [self.Coedid containsString:@"QC10"] || [self.Coedid containsString:@"QC16"] || [self.Coedid containsString:@"YC13"] || [self.Coedid containsString:@"QC13"] || [self.Coedid containsString:@"YC15"] || [self.Coedid containsString:@"QC15"]) {
            [ParentsModeBut setEnabled:YES];
            ParentsModeBut.alpha = 100;
            [ParentsModeSettingBut setEnabled:YES];
            ParentsModeSettingBut.alpha = 100;
        }else {
            [ParentsModeBut setEnabled:NO];
            ParentsModeBut.alpha = 0.4;
            [ParentsModeSettingBut setEnabled:NO];
            ParentsModeSettingBut.alpha = 0.4;
        }
        if ([self.Coedid containsString:@"QK01"] || [self.Coedid containsString:@"QK02"] || [self.Coedid containsString:@"QK03"]) {
            [ParentsModeBut setEnabled:NO];
            ParentsModeBut.alpha = 0.4;
            [ParentsModeSettingBut setEnabled:NO];
            ParentsModeSettingBut.alpha = 0.4;
            [ChargingProtectionBut setEnabled:NO];
            ChargingProtectionBut.alpha = 0.4;
            [PhoneChargingProtectionBut setEnabled:NO];
            PhoneChargingProtectionBut.alpha = 0.4;
            [DDCChargingProtectionBut setEnabled:NO];
            DDCChargingProtectionBut.alpha = 0.4;
            [ZNDDBut setEnabled:NO];
            ZNDDBut.alpha = 0.4;
            [SettingBut setEnabled:NO];
            SettingBut.alpha = 0.4;
            [timeBut setEnabled:NO];
            timeBut.alpha = 0.4;
            [PowerBut setEnabled:NO];
            PowerBut.alpha = 0.4;
        }
        if (!error) {
            NSString *priceStr = [response substringWithRange:NSMakeRange(24, 4)];
            NSString * Time = [response substringWithRange:NSMakeRange(50, 2)];
            NSString * Power = [response substringWithRange:NSMakeRange(52, 2)];
            [time setText:[NSString stringWithFormat:@"%d%@",[[Time substringToIndex:2] intValue],Localize(@"分钟")]];
            [power setText:[NSString stringWithFormat:@"%d%@",[[Power substringToIndex:2] intValue],Localize(@"W")]];
            ZPLog(@"%@",self.Coedid);
            [price setText:[NSString stringWithFormat:@"%d.%02d",[[priceStr substringToIndex:2] intValue],[[priceStr substringFromIndex:2] intValue]]];
            if ([self.Coedid containsString:@"WFMT"] || [self.Coedid containsString:@"YFMT"] || [self.Coedid containsString:@"CDMT60"] || [self.Coedid containsString:@"GP1P"] || [self.Coedid containsString:@"MC"] || [self.Coedid containsString:@"GP3P"] || [self.Coedid containsString:@"YFGPMT"]) {
                ZPLog(@"%@",self.Coedid);
                NSString *powerStr1 = [response substringWithRange:NSMakeRange(28, 8)];
                //                [limit setText:[NSString stringWithFormat:@"%d.%02d",[[powerStr1 substringToIndex:5] intValue],[[powerStr1 substringFromIndex:5] intValue]]];
                [limit setText:[NSString stringWithFormat:@"%d.%02d",[[powerStr1 substringToIndex:6] intValue],[[powerStr1 substringFromIndex:6] intValue]]];
            } else {
                NSString *powerStr = [response substringWithRange:NSMakeRange(28, 6)];
                [limit setText:[NSString stringWithFormat:@"%d.%02d",[[powerStr substringToIndex:4] intValue],[[powerStr substringFromIndex:4] intValue]]];
            }
            NSString * protectStr = [response substringWithRange:NSMakeRange(48, 2)];
            NSString * powerTest = [response substringWithRange:NSMakeRange(52, 2)];
            if ([protectStr  isEqual: @"01"]) {
                ZPLog(@"%@",protectStr);
                if ([Time isEqual:@"03"] && [powerTest isEqual:@"02"]) {
                    ChargingProtectionBut.selected = YES;
                    PhoneChargingProtectionBut.selected = YES;
                    DDCChargingProtectionBut.selected = NO;
                    [SettingBut setEnabled:NO]; // 交互关闭
                    SettingBut.alpha = 0.4; // 透明度
                    [timeBut setEnabled:NO];
                    timeBut.alpha = 0.4;
                    [PowerBut setEnabled:NO];
                    PowerBut.alpha = 0.4;
                }else
                    if ([Time isEqual:@"03"] && [powerTest isEqual:@"05"]) {
                        ChargingProtectionBut.selected = YES;
                        DDCChargingProtectionBut.selected = YES;
                        PhoneChargingProtectionBut.selected = NO;
                        [SettingBut setEnabled:NO]; // 交互关闭
                        SettingBut.alpha = 0.4; // 透明度
                        [timeBut setEnabled:NO];
                        timeBut.alpha = 0.4;
                        [PowerBut setEnabled:NO];
                        PowerBut.alpha = 0.4;
                    }else {
                        //                    if ([powerTest isEqual:@"00"] || [powerTest isEqual:@"01"] || [powerTest isEqual:@"03"] || [powerTest isEqual:@"04"] ||  [powerTest isEqual:@"06"] || [powerTest isEqual:@"07"] || [powerTest isEqual:@"08"] || [powerTest isEqual:@"09"] || [powerTest isEqual:@"10"] || [powerTest isEqual:@"11"] || [powerTest isEqual:@"12"] || [powerTest isEqual:@"13"] || [powerTest isEqual:@"14"] || [powerTest isEqual:@"15"] || [powerTest isEqual:@"16"] || [powerTest isEqual:@"17"] || [powerTest isEqual:@"18"] || [powerTest isEqual:@"19"] || [powerTest isEqual:@"20"] || [powerTest isEqual:@"21"] || [powerTest isEqual:@"22"] || [powerTest isEqual:@"23"] || [powerTest isEqual:@"24"] || [powerTest isEqual:@"25"] || [powerTest isEqual:@"26"] || [powerTest isEqual:@"27"] || [powerTest isEqual:@"28"] || [powerTest isEqual:@"29"] || [powerTest isEqual:@"30"] || [powerTest isEqual:@"31"] || [powerTest isEqual:@"32"] || [powerTest isEqual:@"33"] || [powerTest isEqual:@"34"] || [powerTest isEqual:@"35"] || [powerTest isEqual:@"36"] || [powerTest isEqual:@"37"] || [powerTest isEqual:@"38"] || [powerTest isEqual:@"39"] || [powerTest isEqual:@"40"] || [powerTest isEqual:@"41"] || [powerTest isEqual:@"42"] || [powerTest isEqual:@"43"] || [powerTest isEqual:@"44"] || [powerTest isEqual:@"45"] || [powerTest isEqual:@"46"] || [powerTest isEqual:@"47"] || [powerTest isEqual:@"48"] || [powerTest isEqual:@"49"] || [powerTest isEqual:@"50"] || [powerTest isEqual:@"51"] || [powerTest isEqual:@"52"] || [powerTest isEqual:@"53"] || [powerTest isEqual:@"54"] || [powerTest isEqual:@"55"] || [powerTest isEqual:@"56"] || [powerTest isEqual:@"57"] || [powerTest isEqual:@"58"] || [powerTest isEqual:@"59"] || [powerTest isEqual:@"60"] || [powerTest isEqual:@"61"] || [powerTest isEqual:@"62"] || [powerTest isEqual:@"63"] || [powerTest isEqual:@"64"] || [powerTest isEqual:@"65"] || [powerTest isEqual:@"66"] || [powerTest isEqual:@"67"] || [powerTest isEqual:@"68"] || [powerTest isEqual:@"69"] || [powerTest isEqual:@"70"] || [powerTest isEqual:@"71"] || [powerTest isEqual:@"72"] || [powerTest isEqual:@"73"] || [powerTest isEqual:@"74"] || [powerTest isEqual:@"75"] || [powerTest isEqual:@"76"] || [powerTest isEqual:@"77"] || [powerTest isEqual:@"78"] || [powerTest isEqual:@"79"] || [powerTest isEqual:@"80"] || [powerTest isEqual:@"81"] || [powerTest isEqual:@"82"] || [powerTest isEqual:@"83"] || [powerTest isEqual:@"84"] || [powerTest isEqual:@"85"] || [powerTest isEqual:@"86"] || [powerTest isEqual:@"87"] || [powerTest isEqual:@"88"] || [powerTest isEqual:@"89"] || [powerTest isEqual:@"90"] || [powerTest isEqual:@"91"] || [powerTest isEqual:@"92"] || [powerTest isEqual:@"93"] || [powerTest isEqual:@"94"] || [powerTest isEqual:@"95"] || [powerTest isEqual:@"96"] || [powerTest isEqual:@"97"] || [powerTest isEqual:@"98"] || [powerTest isEqual:@"99"]) {
                        ZNDDBut.selected = YES;
                        [SettingBut setEnabled:YES]; // 交互关闭
                        SettingBut.alpha = 100; // 透明度
                        [timeBut setEnabled:YES];
                        timeBut.alpha = 100;
                        [PowerBut setEnabled:YES];
                        PowerBut.alpha = 100;
                        [PhoneChargingProtectionBut setEnabled:NO];// 交互关闭
                        PhoneChargingProtectionBut.alpha = 0.4;
                        [DDCChargingProtectionBut setEnabled:NO];
                        DDCChargingProtectionBut.alpha = 0.4;
                    }
                ZPLog(@"%@",powerTest);
            }else
                if ([protectStr isEqual:@"00"]) {
                    ChargingProtectionBut.selected = NO;
                    ZNDDBut.selected = NO;
                    [SettingBut setEnabled:NO]; // 交互关闭
                    SettingBut.alpha = 0.4; // 透明度
                    [timeBut setEnabled:NO];
                    timeBut.alpha = 0.4;
                    [PowerBut setEnabled:NO];
                    PowerBut.alpha = 0.4;
                    [PhoneChargingProtectionBut setEnabled:NO];// 交互关闭
                    PhoneChargingProtectionBut.alpha = 0.4;
                    [DDCChargingProtectionBut setEnabled:NO];
                    DDCChargingProtectionBut.alpha = 0.4;
                    ZPLog(@"%@",protectStr);
                }
            ZPLog(@"%@",protectStr);
        }else {
            [HintView showHint:error.localizedDescription];
        }
        ZPLog(@"--------%@",response);
    }];
}

- (void)checkClose:(BOOL)close {
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0015";
    model.deviceNo = self.dNo;
    model.content = close?@"01":@"00";
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        if (!error) {
        }else {
            [HintView showHint:error.localizedDescription];
        }
    }];
}

- (void)changeTime {
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0016";
    model.deviceNo = self.dNo;
    model.content = [NSString stringWithFormat:@"%02d",[[time.text substringToIndex:time.text.length - 2] intValue]];
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        if (!error) {
            //            [HintView showHint:Localize(@"设置成功")];
        }else {
            [HintView showHint:error.localizedDescription];
        }
    }];
}

- (void)changePower {
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0021";
    model.deviceNo = self.dNo;
    model.content = [NSString stringWithFormat:@"%02d",[[power.text substringToIndex:power.text.length - 1] intValue]];
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        ZPLog(@"%@",power);
        if (!error) {
            [HintView showHint:Localize(@"设置成功")];
        }else {
            [HintView showHint:error.localizedDescription];
        }
    }];
}

// 单价BUt
- (IBAction)priceBut:(UIButton *)sender {
    if (priceTF.text == nil || priceTF.text.length <= 0) {
        ZPLog(@"没有输入文字");
        [HintView showHint:Localize(@"请输入单价")];
    }else {
        [self AllDtaPrice];
    }
}

// 负荷门限BUt
//options+command+ 左右箭头折叠/展开
- (IBAction)saveAction:(UIButton *)sender {
    if ([self.Coedid containsString:@"YC"] || [self.Coedid containsString:@"K"]
        || [self.Coedid containsString:@"QC"] || [self.Coedid containsString:@"QK01"] || [self.Coedid containsString:@"QK02"] || [self.Coedid containsString:@"QK03"] || [self.Coedid containsString:@"CDMT10"] || [self.Coedid containsString:@"QC10"] || [self.Coedid containsString:@"YC10"] || [self.Coedid containsString:@"YCGP10"]) {
        if (limitTF.text == nil || limitTF.text.length <= 1) {
            ZPLog(@"没有输入文字");
            [HintView showHint:Localize(@"请输入负荷门限")];
        }else {
            if (limitTF.text.integerValue  > 2500) {
                [HintView showHint:Localize(@"负荷门限不能大于2500")];
            }else {
                [self AllDataload];
            }
        }
    }else
        if ([self.Coedid containsString:@"CDMT60"] ) {
            if (limitTF.text == nil || limitTF.text.length <= 1) {
                ZPLog(@"没有输入文字");
                [HintView showHint:Localize(@"请输入负荷门限")];
            }else {
                if (limitTF.text.integerValue  > 15000) {
                    [HintView showHint:Localize(@"负荷门限不能大于15000")];
                }else {
                    [self AllDataload];
                }
            }
        }else
            if ([self.Coedid containsString:@"CDMT16"] || [self.Coedid containsString:@"QC16"] || [self.Coedid containsString:@"YC16"] || [self.Coedid containsString:@"YCGP16"]) {
                if (limitTF.text == nil || limitTF.text.length <= 1) {
                    ZPLog(@"没有输入文字");
                    [HintView showHint:Localize(@"请输入负荷门限")];
                }else {
                    if (limitTF.text.integerValue  > 4000) {
                        [HintView showHint:Localize(@"负荷门限不能大于4000")];
                    }else {
                        [self AllDataload];
                    }
                }
            }else
                if ([self.Coedid containsString:@"YC13"] || [self.Coedid containsString:@"QC13"]) {
                    if (limitTF.text == nil || limitTF.text.length <= 1) {
                        ZPLog(@"没有输入文字");
                        [HintView showHint:Localize(@"请输入负荷门限")];
                    }else {
                        
                        if (limitTF.text.integerValue  > 3000) {
                            [HintView showHint:Localize(@"负荷门限不能大于3000")];
                        }else {
                            [self AllDataload];
                        }
                    }
                }else
                    if ([self.Coedid containsString:@"QC15"] || [self.Coedid containsString:@"YC15"]) {
                        if (limitTF.text == nil || limitTF.text.length <= 1) {
                            ZPLog(@"没有输入文字");
                            [HintView showHint:Localize(@"请输入负荷门限")];
                        }else {
                            if (limitTF.text.integerValue  > 3300) {
                                [HintView showHint:Localize(@"负荷门限不能大于3300")];
                            }else {
                                [self AllDataload];
                            }
                        }
                    }else
                        if ([self.Coedid containsString:@"MC"]) {
                            if (limitTF.text == nil || limitTF.text.length <= 1) {
                                ZPLog(@"没有输入文字");
                                [HintView showHint:Localize(@"请输入负荷门限")];
                            }else {
                                if (limitTF.text.integerValue  > 23000) {
                                    [HintView showHint:Localize(@"负荷门限不能大于23000")];
                                }else {
                                    [self AllDataload];
                                }
                            }
                        }else
                            if ([self.Coedid containsString:@"GP3P"]) {
                                if (limitTF.text == nil || limitTF.text.length <= 1) {
                                    ZPLog(@"没有输入文字");
                                    [HintView showHint:Localize(@"请输入负荷门限")];
                                }else {
                                    if (limitTF.text.integerValue  > 45000) {
                                        [HintView showHint:Localize(@"负荷门限不能大于45000")];
                                    }else {
                                        [self AllDataload];
                                    }
                                }
                            }else
                                if ([self.Coedid containsString:@"YFMT"] || [self.Coedid containsString:@"GP1P"] || [self.Coedid containsString:@"WFMT"] || [self.Coedid containsString:@"YFGPMT"] || [self.Coedid containsString:@"MC"]) {
                                    if (limitTF.text == nil || limitTF.text.length <= 1) {
                                        ZPLog(@"没有输入文字");
                                        [HintView showHint:Localize(@"请输入负荷门限")];
                                    }else {
                                        if (limitTF.text.integerValue  > 25000) {
                                            [HintView showHint:Localize(@"负荷门限不能大于25000")];
                                        }else {
                                            [self AllDataload];
                                        }
                                    }
                                }
}

//  单价数据
- (void)AllDtaPrice {
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.deviceNo = self.dNo;
    NSArray *contents;
    NSString *content;
    if (price.text.length == 0) {
        [HintView showHint:Localize(@"请输入单价")];
        return;
    }
    model.command = @"0019";
    contents = [priceTF.text componentsSeparatedByString:@"."];
    NSString *decimal = contents.count == 1?@"00":contents[1];
    if (decimal.length == 1) {
        decimal = [NSString stringWithFormat:@"%@0",decimal];
    }
    content = [NSString stringWithFormat:@"%02d%02d",[[contents firstObject] intValue],[decimal intValue]];
    model.content = content;
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        if (!error) {
            [HintView showHint:Localize(@"保存成功")];
            [price setText:[NSString stringWithFormat:@"%d.%02d",[[content substringToIndex:2] intValue],[[content substringFromIndex:2] intValue]]];
        }else {
            [HintView showHint:error.localizedDescription];
        }
    }];
}

// 负荷门限数据
- (void)AllDataload {
    WebSocket * socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.deviceNo = self.dNo;
    NSArray *contents;
    NSString *content;
    if (power.text.length == 0) {
        [HintView showHint:Localize(@"请输入负荷门限")];
        return;
    }
    if ([self.Coedid containsString:@"WFMT"] || [self.Coedid containsString:@"YFMT"] || [self.Coedid containsString:@"CDMT60"] || [self.Coedid containsString:@"GP1P"] || [self.Coedid containsString:@"MC"] || [self.Coedid containsString:@"GP3P"] || [self.Coedid containsString:@"YFGPMT"]) {
        model.command = @"0020";
        contents = [limitTF.text componentsSeparatedByString:@"."];
        content = [NSString stringWithFormat:@"%06d%02d",[[contents firstObject] intValue],contents.count == 1?0:[contents[1] intValue]];
        model.content = [NSString stringWithFormat:@"%06d",[[contents firstObject] intValue]];
    }else {
        model.command = @"0020";
        contents = [limitTF.text componentsSeparatedByString:@"."];
        content = [NSString stringWithFormat:@"%04d%02d",[[contents firstObject] intValue],contents.count == 1?0:[contents[1] intValue]];
        NSString * contentStr = [content substringWithRange:NSMakeRange(0, 6)];
        model.content = contentStr;
    }
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        if (!error) {
            [HintView showHint:Localize(@"保存成功")];
            if ([self.Coedid containsString:@"WFMT"] || [self.Coedid containsString:@"YFMT"] || [self.Coedid containsString:@"CDMT60"] || [self.Coedid containsString:@"GP1P"] || [self.Coedid containsString:@"MC"] || [self.Coedid containsString:@"GP3P"] || [self.Coedid containsString:@"YFGPMT"]) {
                [limit setText:[NSString stringWithFormat:@"%d.%02d",[[content substringToIndex:6] intValue],[[content substringFromIndex:6] intValue]]];
            }else {
                [limit setText:[NSString stringWithFormat:@"%d.%02d",[[content substringToIndex:4] intValue],[[content substringFromIndex:4] intValue]]];
                //            [limit setText:content];
            }
        }else {
            [HintView showHint:error.localizedDescription];
        }
    }];
}

// 设置按钮
- (IBAction)SettingBut:(UIButton *)sender {
    [self checkClose:ZNDDBut.selected];
    [self changeTime];
    [self changePower];
}

// 时间设置
- (IBAction)timeEditAction {
    [SGActionView showSheetWithTitle:nil itemTitles:muniteArr itemSubTitles:nil selectedIndex:[[time.text substringToIndex:time.text.length - Localize(@"分钟").length] integerValue] selectedHandle:^(NSInteger index) {
        [time setText:[NSString stringWithFormat:@"%ld%@",(long)index, Localize(@"分钟")]];
    }];
}

// 功率设置
- (IBAction)powerEditAction {
    [SGActionView showSheetWithTitle:nil itemTitles:powerArr itemSubTitles:nil selectedIndex:[[power.text substringToIndex:power.text.length - 1] integerValue] selectedHandle:^(NSInteger index) {
        [power setText:[NSString stringWithFormat:@"%ldW",(long)index]];
    }];
}

// 新增
// 家长模式
/**
 家长模式
 @param sender 家长模式
 */
- (IBAction)ParentsModeBut:(UIButton *)sender {
    if (!sender.selected) {
        TimeSettingListViewController *list = [[TimeSettingListViewController alloc] init];
        list.datas = self.datas;
        list.deviceNo = self.dNo;
        list.isParentModel = YES;
        [self.navigationController pushViewController:list animated:YES];
    }else {
        [self changeModel];
        sender.selected = NO;
        ZPLog(@"取消");
    }
}

- (void)loadData {
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0008";
    model.deviceNo = self.dNo;
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        if (!error) {
            if (((NSString *)response).length == 120) {
                NSString *content = [response substringWithRange:NSMakeRange(((NSString *)response).length - 96, 92)];
                [weakSelf caculateWithString:content];
                _content = content;
            }
        }else {
            [HintView showHint:Localize(@"加载数据失败")];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        ZPLog(@"--------%@",response);
    }];
}

- (void)changeModel {
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0009";
    model.deviceNo = self.dNo;
    
    NSString *contentStr = @"";
    for (TimeSettingModel *model in self.datas) {
        NSString *item = [model.startTime stringByReplacingOccurrencesOfString:@":" withString:@""];
        item = [item stringByAppendingString:[model.endTime stringByReplacingOccurrencesOfString:@":" withString:@""]];
        
        NSString *week = [Utils getBinaryByHex:model.week];
        week = [week stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"0"];
        model.week = [Utils getHexByBinary:week];
        item = [item stringByAppendingString:model.week];
        
        contentStr = [contentStr stringByAppendingString:item];
    }
    
    model.content = contentStr;
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        if (!error) {
            [self cancelAction];
        }else {
            [HintView showHint:error.localizedDescription];
        }
    }];
}

// 家长模式
- (void)caculateWithString:(NSString *)content {
    NSString *str = [content substringFromIndex:content.length - 2];
    if ([str isEqualToString:@"03"] || [str isEqualToString:@"04"] || [str isEqualToString:@"02"]) {
        [self.datas removeAllObjects];
        BOOL isValidate = NO;
        for (NSInteger i = 0; i < 9; i++) {
            NSString *time= [content substringWithRange:NSMakeRange(i*10, 10)];
            TimeSettingModel *model = [[TimeSettingModel alloc] init];
            NSMutableString *start = [[time substringToIndex:4] mutableCopy];
            [start insertString:@":" atIndex:2];
            NSMutableString *end = [[time substringWithRange:NSMakeRange(4, 4)] mutableCopy];
            [end insertString:@":" atIndex:2];
            model.startTime = start;
            model.endTime = end;
            model.week = [time substringFromIndex:time.length - 2];
            NSString *week = [Utils getBinaryByHex:model.week];
            if ((![week isEqualToString:@"00000000"]) && (!([start isEqualToString:@"00:00"] && [end isEqualToString:@"00:00"]))) {
                if ([str isEqualToString:@"03"]) {
                    isParentModel = YES;
                    isValidate = YES;
                    model.open = YES;
                    ParentsModeBut.selected = YES;
                }
            }
            
            [self.datas addObject:model];
        }
        //有效的时段设置模式
        if (isValidate) {
            [self configRunModelWithModelStr:content isLoop:NO];
            ParentsModeBut.selected = YES;
            return;
        }
    }else if([str isEqualToString:@"05"]) {
        [self configRunModelWithModelStr:content isLoop:YES];
        ParentsModeBut.selected = YES;
        return;
    } else {
        
    }
    ParentsModeBut.selected = NO;
    //[self configNoData];
}

- (void)configRunModelWithModelStr:(NSString *)modelStr isLoop:(BOOL)isLoop {
    if (isLoop) {
        selectedIndexPath = nil;
    }
    [self.view updateConstraints];
    if(!isLoop) {
        selectedIndexPath = nil;
    }
}

- (void)configNoData {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 9 ; i++) {
        TimeSettingModel *model = [[TimeSettingModel alloc] init];
        model.startTime = @"00:00";
        model.endTime = @"00:00";
        model.week = @"00";
        model.open = NO;
        [arr addObject:model];
    }
    self.datas = arr;
}


// 家长模式设置
- (IBAction)ParentsModeSettingBut:(UIButton *)sender {
    TimeSettingListViewController *list = [[TimeSettingListViewController alloc] init];
    list.datas = self.datas;
    list.deviceNo = self.dNo;
    list.isParentModel = YES;
    [self.navigationController pushViewController:list animated:YES];
}

// 取消家长模式
- (void)cancelAction {
    [CommonOperation cancelDeviceRunModel:self.dNo result:^(id response, NSError *error) {
        if (!error) {
            [self caculateWithString:[[_content substringToIndex:_content.length-2] stringByAppendingString:@"04"]];
            selectedIndexPath = nil;
            [HintView showHint:@"取消成功"];
        }else {
            [HintView showHint:error.localizedDescription];
        }
    }];
}

// 充电保护设置
- (IBAction)ChargingProtectionBut:(UIButton *)sender {
    sender.selected =! sender.selected;
    if (sender.selected) {
        if (sender == ChargingProtectionBut) {
            ChargingProtectionBut.selected = YES;
            //            [self checkClose:ChargingProtectionBut.selected];
        }
        ZNDDBut.selected = NO;
        [DDCChargingProtectionBut setEnabled:YES]; //交互开启
        DDCChargingProtectionBut.alpha=100;//透明度
        [PhoneChargingProtectionBut setEnabled:YES]; //交互开启
        PhoneChargingProtectionBut.alpha=100;//透明度
        [SettingBut setEnabled:NO]; // 交互打开
        SettingBut.alpha = 0.4; // 透明度
        [timeBut setEnabled:NO]; //交互开启
        timeBut.alpha = 0.4; //透明度
        [PowerBut setEnabled:NO]; // 交互开启
        PowerBut.alpha = 0.4;
        return;
    }else {
        if (sender == ChargingProtectionBut) {
            ChargingProtectionBut.selected = NO;
            ZNDDBut.selected = NO;
            [self checkClose:ChargingProtectionBut.selected];
        }
        [DDCChargingProtectionBut setEnabled:NO]; //交互关闭
        DDCChargingProtectionBut.alpha=0.4;//透明度
        [PhoneChargingProtectionBut setEnabled:NO]; //交互关闭
        PhoneChargingProtectionBut.alpha=0.4;//透明度
        /*****************************/
        [SettingBut setEnabled:NO]; // 交互打开
        SettingBut.alpha = 0.4; // 透明度
        [timeBut setEnabled:NO]; //交互关闭
        timeBut.alpha = 0.4; //透明度
        [PowerBut setEnabled:NO]; // 交互关闭
        PowerBut.alpha = 0.4;
    }
}

// 手机充电保护
- (IBAction)PhoneChargingProtectionBut:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else {
        sender.selected =! sender.selected;
        DDCChargingProtectionBut.selected = NO;
        [self checkClose:PhoneChargingProtectionBut.selected];
        [time setText:[NSString stringWithFormat:@"%d%@",3, Localize(@"分钟")]];
        [self changeTime];
        [power setText:[NSString stringWithFormat:@"%dW",2]];
        [self changePower];
    }
}

// 电动车充电保护
- (IBAction)DDCChargingProtectionBut:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else {
        sender.selected =! sender.selected;
        PhoneChargingProtectionBut.selected = NO;
        [self checkClose:DDCChargingProtectionBut.selected];
        [time setText:[NSString stringWithFormat:@"%d%@",3, Localize(@"分钟")]];
        [self changeTime];
        [power setText:[NSString stringWithFormat:@"%dW",5]];
        [self changePower];
    }
}

// 智能断电控制
- (IBAction)ZNDDBut:(UIButton *)sender {
    sender.selected =! sender.selected;
    if (sender.selected) {
        if (sender == ZNDDBut) {
            ZNDDBut.selected = YES;
            //            [self checkClose:ZNDDBut.selected];
        }
        ChargingProtectionBut.selected = NO;
        [DDCChargingProtectionBut setEnabled:NO]; //交互关闭
        DDCChargingProtectionBut.alpha = 0.4;//透明度
        [PhoneChargingProtectionBut setEnabled:NO]; //交互关闭
        PhoneChargingProtectionBut.alpha = 0.4;//透明度
        [SettingBut setEnabled:YES]; // 交互打开
        SettingBut.alpha = 100; // 透明度
        [timeBut setEnabled:YES]; //交互开启
        timeBut.alpha = 100; //透明度
        [PowerBut setEnabled:YES]; // 交互开启
        PowerBut.alpha = 100;
        return;
    }else {
        if (sender == ZNDDBut) {
            ZNDDBut.selected = NO;
            ChargingProtectionBut.selected = NO;
            [self checkClose:ZNDDBut.selected];
        }
        [DDCChargingProtectionBut setEnabled:NO]; //交互关闭
        DDCChargingProtectionBut.alpha = 0.4;//透明度
        [PhoneChargingProtectionBut setEnabled:NO]; //交互关闭
        PhoneChargingProtectionBut.alpha = 0.4;//透明度
        /*****************************/
        [SettingBut setEnabled:NO]; // 交互打开
        SettingBut.alpha = 0.4; // 透明度
        [timeBut setEnabled:NO]; //交互关闭
        timeBut.alpha = 0.4; //透明度
        [PowerBut setEnabled:NO]; // 交互关闭
        PowerBut.alpha = 0.4;//透明度
    }
}

// 进来默认关闭所有按钮
- (void)DefaultTest {
    [ParentsModeBut setEnabled:NO];
    ParentsModeBut.alpha = 0.4;
    [ParentsModeSettingBut setEnabled:NO];
    ParentsModeSettingBut.alpha = 0.4;
    [SettingBut setEnabled:NO]; // 交互打开
    SettingBut.alpha = 0.4; // 透明度
    [timeBut setEnabled:NO]; //交互开启
    timeBut.alpha = 0.4; //透明度
    [PowerBut setEnabled:NO]; // 交互开启
    PowerBut.alpha = 0.4;
    [DDCChargingProtectionBut setEnabled:NO]; //交互关闭
    DDCChargingProtectionBut.alpha=0.4;//透明度
    [PhoneChargingProtectionBut setEnabled:NO]; //交互关闭
    PhoneChargingProtectionBut.alpha=0.4;//透明度
}

@end
