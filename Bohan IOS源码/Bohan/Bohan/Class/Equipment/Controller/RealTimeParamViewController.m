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
@interface RealTimeParamViewController ()
{
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
    // Do any additional setup after loading the view from its nib.
    self.title = Localize(@"用电参数");
    [self rightBarTitle:Localize(@"刷新") color:[UIColor whiteColor] action:@selector(deviceParams)];
    
    [self deviceParams];
}


- (void)deviceParams
{
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
            if ([string substringToIndex:4]) {
                NSString * stringg = string;
                if ([stringg hasPrefix:@"E766"] || [stringg hasPrefix:@"E765"] || [stringg hasPrefix:@"E764"] || [string hasPrefix:@"E767"]) {
                    ZPLog(@"包含");
                    [weakSelf updateViewWithDataa:response];
                }else
//                    if ([stringg hasPrefix:@"E765"]) {
//                        ZPLog(@"包含");
//                        [weakSelf updateViewWithDataa:response];
//                    }else
//                        if ([stringg hasPrefix:@"E764"]) {
//                            ZPLog(@"包含");
//                            [weakSelf updateViewWithDataa:response];
//                        }else
                            if ([stringg hasPrefix:@"E768"]) {
                                ZPLog(@"包含");
                                [weakSelf updateViewWithData:response];
                            }else if ([stringg hasPrefix:@"E761"]|| [stringg hasPrefix:@"E762"] || [string hasPrefix:@"E763"]) {//39位开始获取
                                [weakSelf updateViewWithDataaa:response];
                            }
            }
//            [weakSelf updateViewWithData:response];
            
        }else
        {
            [HintView showHint:error.localizedDescription];
        }
        
        ZPLog(@"--------%@",response);
        
        
        
    }];
    
}

- (void)updateViewWithData:(NSString *)data
{
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
