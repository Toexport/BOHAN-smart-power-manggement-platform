//
//  RealTimeParamViewController.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/16.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "RealTimeParamViewController.h"
#import "UIViewController+NavigationBar.h"
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
            
            [weakSelf updateViewWithData:response];
            
        }else
        {
            [HintView showHint:error.localizedDescription];
        }
        
        NSLog(@"--------%@",response);
    }];
    
}

- (void)updateViewWithData:(NSString *)data
{
    [deviceNo setText:self.dNo];
    [time setText:[data time]];
    [week setText:[data week]];
    [voltage setText:[data voltage]];
    [electric setText:[data electric]];
    [power setText:[data realTimePower]];
    [factor setText:[data realTimePowerFactor]];
    [elcAmount setText:[data elcAmount]];
    [carbon setText:[data carbon]];
    [money setText:[data money]];
    [temperature setText:[data temperature]];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
