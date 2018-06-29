//
//  UpdateDeviceInfoViewController.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/28.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "UpdateDeviceInfoViewController.h"
#import "CustomInputView.h"
#import "DeviceInfoViewController.h"
#import "WifiConnectViewController.h"
#import "DeviceModel.h"
#import "DebuggingANDPublishing.pch"
@interface UpdateDeviceInfoViewController ()
{
//    __weak IBOutlet UILabel *name;
    
    __weak IBOutlet UITextField *nameTF;
    __weak IBOutlet UILabel *deviceId;
    __weak IBOutlet CustomInputView *typeInput;
    __weak IBOutlet CustomInputView *posInput;
    __weak IBOutlet CustomInputView *brandInput;
//    dispatch_group_t group;
//    dispatch_queue_t queue;
    
    __weak IBOutlet UIButton *lookBtn;
    __weak IBOutlet UIButton *connectBtn;
    
    BOOL loadtType;
    BOOL loadtPos;
    BOOL loadtBrand;


//    __weak IBOutlet CustomInputView *typeInput;
//    __weak IBOutlet CustomInputView *brandInput;

}
@end

@implementation UpdateDeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"修改信息");
    [nameTF setText:self.model.name];
    [deviceId setText:self.model.id];
    lookBtn.titleLabel.numberOfLines = 2;
    connectBtn.titleLabel.numberOfLines = 2;

//    group = dispatch_group_create();
//    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    posInput.name.text = Localize(@"设备位置");
    posInput.contentTF.text = self.model.position;
    
    typeInput.name.text = Localize(@"用电类型");
    typeInput.contentTF.text = self.model.name;

    brandInput.name.text = Localize(@"电器品牌");
    brandInput.contentTF.text = self.model.brand;

    [self.view startLoading];
    [self loadPosList];
    [self loadNameList];
    [self loadBrandList];
    
}

- (void)updateUI
{
    
    if (loadtType && loadtType && loadtBrand) {
        
        DBLog(@"全部请求完毕");
        
        [self.view stopLoading];

    }

}

- (void)loadPosList
{
    
    [[NetworkRequest sharedInstance] requestWithUrl:GET_POS_NAME_LIST_URL parameter:nil completion:^(id response, NSError *error) {
//        dispatch_group_leave(group);
        DBLog(@"%@",response);
        loadtPos = YES;
        if (!error) {
            NSArray *postions = [[response[@"content"] componentsSeparatedByString:@","] mutableCopy];
            posInput.datas = postions;
            
            [self updateUI];
        }
    }];
    
}

- (void)loadBrandList
{
    
    [[NetworkRequest sharedInstance] requestWithUrl:GET_BRAND_LIST_URL parameter:nil completion:^(id response, NSError *error) {
//        dispatch_group_leave(group);
        loadtBrand = YES;
        DBLog(@"%@",response);
        if (!error) {
            NSArray *brands = [[response[@"content"] componentsSeparatedByString:@","] mutableCopy];
            brandInput.datas = brands;
            [self updateUI];

        }
    }];
    
}

- (void)loadNameList
{
    
    [[NetworkRequest sharedInstance] requestWithUrl:GET_NAME_LIST_URL parameter:nil completion:^(id response, NSError *error) {
//        dispatch_group_leave(group);
        loadtType = YES;

        DBLog(@"%@",response);
        if (!error) {
            NSArray *names = [[response[@"content"] componentsSeparatedByString:@","] mutableCopy];
            typeInput.datas = names;
            [self updateUI];

        }
        
    }];

}

- (void)updateDeviceInfo
{
    [self.view startLoading];
    NSDictionary *dic = @{@"DeviceName":nameTF.text,@"DeviceCode":deviceId.text, @"PosName":posInput.contentTF.text, @"LoadName":typeInput.contentTF.text, @"LoadBrand":brandInput.contentTF.text};
    [[NetworkRequest sharedInstance] requestWithUrl:MODIFY_DEVICE_INFO_URL parameter:dic completion:^(id response, NSError *error) {
        
        [self.view stopLoading];
        //请求成功
        if (!error) {
            
            [HintView showHint:Localize(@"修改成功")];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else
        {
            [HintView showHint:error.localizedDescription];
        }
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveAction {
    
    if (nameTF.text.length == 0 || posInput.contentTF.text.length == 0 || typeInput.contentTF.text.length == 0 || brandInput.contentTF.text.length == 0) {
        
        [HintView showHint:Localize(@"请填完整设备信息")];
        return;
    }
    [self updateDeviceInfo];
}

- (IBAction)deviceInfoAction {
    
    DeviceInfoViewController *info = [[DeviceInfoViewController alloc] init];
    info.model = self.model;
    [self.navigationController pushViewController:info animated:YES];

}

- (IBAction)connectAction {
    
    WifiConnectViewController *connect = [[WifiConnectViewController alloc] init];
    connect.deviceNo = self.model.id;
    [self.navigationController pushViewController:connect animated:YES];

}
@end
