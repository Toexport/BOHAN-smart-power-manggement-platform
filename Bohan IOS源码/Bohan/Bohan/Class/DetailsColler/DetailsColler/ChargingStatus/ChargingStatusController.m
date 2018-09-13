//
//  ChargingStatusController.m
//  Bohan
//
//  Created by summer on 2018/9/12.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "ChargingStatusController.h"

@interface ChargingStatusController ()

@end

@implementation ChargingStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkAndMonitorBatteryLevel];
}
#pragma mark - 电池电量获取及监控
-(void)checkAndMonitorBatteryLevel{
    //拿到当前设备
    UIDevice * device = [UIDevice currentDevice];
    //是否允许监测电池
    //要想获取电池电量信息和监控电池电量 必须允许
    device.batteryMonitoringEnabled = true;
    //1、check
    /*
     获取电池电量
     0 .. 1.0. -1.0 if UIDeviceBatteryStateUnknown
     */
    float level = device.batteryLevel;
    NSLog(@"level = %lf",level);
    //2、monitor
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeBatteryLevel:) name:@"UIDeviceBatteryLevelDidChangeNotification" object:device];
}

- (void)didChangeBatteryLevel:(id)sender{
    //电池电量发生改变时调用
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    float batteryLevel = [myDevice batteryLevel];
    NSLog(@"电池剩余比例：%@", [NSString stringWithFormat:@"%f",batteryLevel*100]);
}

- (IBAction)BackBut:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
