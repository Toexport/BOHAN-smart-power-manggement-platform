//
//  RealTimeParamViewController.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/16.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "RealTimeParamViewController.h"
#import "UIViewController+NavigationBar.h"
#import "DebuggingANDPublishing.pch"
@interface RealTimeParamViewController () {
    
    __weak IBOutlet UILabel *deviceNo;
    __weak IBOutlet UILabel *time;
    __weak IBOutlet UILabel *week;
    __weak IBOutlet UILabel *voltage;
    __weak IBOutlet UILabel *electric;
    __weak IBOutlet UILabel *power;
    __weak IBOutlet UILabel *factor;
    __weak IBOutlet UILabel *elcAmount;
    __weak IBOutlet UILabel *carbon;
    __weak IBOutlet UILabel *money;
    __weak IBOutlet UILabel *temperature;  
}
@end

@implementation RealTimeParamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"用电参数");
    [self rightBarTitle:Localize(@"刷新") color:[UIColor whiteColor] action:@selector(deviceParams)];
    [self deviceParams];
}

- (void)deviceParams {
    WebSocket * socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0001";
    model.deviceNo = self.dNo;
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        if (!error) {
            NSString * string = response;
            NSString * strin  = self.CoedID;
            ZPLog(@"%@",strin);
            if ([string substringToIndex:4]) {
                NSString * stringg = string;
                if ([stringg hasPrefix:@"E766"]|| [stringg hasPrefix:@"E764"]) {
                    ZPLog(@"包含");
                    if ([strin containsString:@"WFMT"]) {
                        [weakSelf updateViewWithDataaNo:response];
                        ZPLog(@"不带点");
                        
                    }else {
                        [weakSelf updateViewWithDataa:response];
                        ZPLog(@"带点");
                    }
                }else
                    if ([stringg hasPrefix:@"E768"]|| [string hasPrefix:@"E767"]) {
                        ZPLog(@"包含");
                        [weakSelf updateViewWithData:response];
                    }else
                        if ([stringg hasPrefix:@"E761"]|| [stringg hasPrefix:@"E762"] || [string hasPrefix:@"E763"]) {//39位开始获取
                        [weakSelf updateViewWithDataaa:response];
                    }else
                        if ([stringg hasPrefix:@"E765"]){
                        if ([strin containsString:@"GP1P"]) {
                            ZPLog(@"不带点");
                            [weakSelf updateViewWithDataasNo:response];
                        }else {
                            ZPLog(@"带点");
                            [weakSelf updateViewWithDataas:response];
                        }
                    }else
                        if ([stringg hasPrefix:@"E760"]) {
                        if ([strin containsString:@"YFGPMT"]) {
                            ZPLog(@"不带点");
                            [weakSelf updateViewWithDataaasNo:response];
                        }else {
                            ZPLog(@"带点");
                            [weakSelf updateViewWithDataas:response];
                        }
                    }else
                        if ([strin containsString:@"YFMT"]) {
                        ZPLog(@"不带点");
                        [weakSelf updateViewWithDataaasNo:response];
                    }else {
                        ZPLog(@"带点");
                        [weakSelf updateViewWithDataas:response];
                    }
            }
        }else {
            [HintView showHint:error.localizedDescription];
        }
        
        ZPLog(@"--------%@",response);
    }];
}

- (void)updateViewWithData:(NSString *)data {
    [deviceNo setText:self.dNo];
    [time setText:[data time]];
    [week setText:[data week]];
    [voltage setText:[data voltage]];
    [electric setText:[data electric]];
    [factor setText:[data realTimePowerFactor]];
    [elcAmount setText:[data elcAmount]];
    [carbon setText:[data carbon]];
    [money setText:[data money]];
    [temperature setText:[data temperature]];
    [power setText:[data realTimePower]];
}

// 带点
- (void)updateViewWithDataa:(NSString *)data {
    [power setText:[data realTimePowerr]];
    [deviceNo setText:self.dNo];
    [time setText:[data time]];
    [week setText:[data week]];
    [voltage setText:[data voltage]];
    [electric setText:[data electric]];
    [factor setText:[data realTimePowerFactor]];
    [elcAmount setText:[data elcAmount]];
    [carbon setText:[data carbon]];
    [money setText:[data money]];
    [temperature setText:[data temperature]];
}

// 不带点
- (void)updateViewWithDataaNo:(NSString *)data {
    [power setText:[data realTimePowerrNo]];
    [deviceNo setText:self.dNo];
    [time setText:[data time]];
    [week setText:[data week]];
    [voltage setText:[data voltage]];
    [electric setText:[data electric]];
    [factor setText:[data realTimePowerFactor]];
    [elcAmount setText:[data elcAmount]];
    [carbon setText:[data carbon]];
    [money setText:[data money]];
    [temperature setText:[data temperature]];
}

// 带点
- (void)updateViewWithDataas:(NSString *)data {
    [power setText:[data realTimePowwerr]];
    [deviceNo setText:self.dNo];
    [time setText:[data time]];
    [week setText:[data week]];
    [voltage setText:[data voltage]];
    [electric setText:[data electric]];
    [factor setText:[data realTimePowerFactor]];
    [elcAmount setText:[data elcAmount]];
    [carbon setText:[data carbon]];
    [money setText:[data money]];
    [temperature setText:[data temperature]];
}

// 不带点
- (void)updateViewWithDataasNo:(NSString *)data {
    NSString * PORT = [data substringWithRange:NSMakeRange(36, 1)];
    if ([PORT isEqualToString:@"0"]) {
        [power setText:[data realTimePowwerrYES]];
    }else {
        [power setText:[data realTimePowwerrNo]];
    }
    [deviceNo setText:self.dNo];
    [time setText:[data time]];
    [week setText:[data week]];
    [voltage setText:[data voltage]];
    [electric setText:[data electric]];
    [factor setText:[data realTimePowerFactor]];
    [elcAmount setText:[data elcAmount]];
    [carbon setText:[data carbon]];
    [money setText:[data money]];
    [temperature setText:[data temperature]];
}

// 不带点
- (void)updateViewWithDataaasNo:(NSString *)data {
    NSString * PORT = [data substringWithRange:NSMakeRange(36, 1)];
    if ([PORT isEqualToString:@"0"]) {
        [power setText:[data realTimePowwerrYES]];
    }else {
        [power setText:[data realTimePowwerrNo]];
    }
    [deviceNo setText:self.dNo];
    [time setText:[data time]];
    [week setText:[data week]];
    [voltage setText:[data voltage]];
    [electric setText:[data electric]];
    [factor setText:[data realTimePowerFactor]];
    [elcAmount setText:[data elcAmount]];
    [carbon setText:[data carbon]];
    [money setText:[data money]];
    [temperature setText:[data temperature]];
}

- (void)updateViewWithDataaa:(NSString *)data {
    [power setText:[data realTimePoerrr]];
    [deviceNo setText:self.dNo];
    [time setText:[data time]];
    [week setText:[data week]];
    [voltage setText:[data voltage]];
    [electric setText:[data electric]];
    [factor setText:[data realTimePowerFactor]];
    [elcAmount setText:[data elcAmount]];
    [carbon setText:[data carbon]];
    [money setText:[data money]];
    [temperature setText:[data temperature]];
}


@end
