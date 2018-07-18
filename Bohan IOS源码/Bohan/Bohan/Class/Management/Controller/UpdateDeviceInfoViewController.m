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
    __weak IBOutlet UIButton *alternativeButt;
    __weak IBOutlet NSLayoutConstraint *MaimVIEwLayoutConstraint;
    __weak IBOutlet NSLayoutConstraint *SecondViewLayoutConstraint;
    __weak IBOutlet NSLayoutConstraint *ssecondViewLayoutConstraint;
    __weak IBOutlet CustomInputView *SecondView;
    __weak IBOutlet UIView *divider1View;
    __weak IBOutlet CustomInputView *ThreeView;
    __weak IBOutlet UIView *divider2View;

    BOOL loadtType;
    BOOL loadtPos;
    BOOL loadtBrand;


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

    posInput.name.text = Localize(@"设备位置");
    posInput.contentTF.text = self.model.position;
    
    typeInput.name.text = Localize(@"设备名称");
    typeInput.contentTF.text = self.model.name;
    
    brandInput.name.text = Localize(@"电器品牌");
    brandInput.contentTF.text = self.model.brand;

    [self.view startLoading];
    [self loadPosList];
    [self loadNameList];
    [self loadBrandList];
    [self IFGPRS];
    [self MoreSwitch];
//    [self Hidden];
}
// 默认隐藏
- (void)Hidden {
    SecondView.hidden = YES;
    ThreeView.hidden = YES;
    divider2View.hidden = YES;
    divider1View.hidden = YES;
    MaimVIEwLayoutConstraint.constant = 348;
    ssecondViewLayoutConstraint.constant = -102;
}
// 判断是几位开关
- (void)MoreSwitch {
    if ([self.model.id containsString:@"61"]) {
        ZPLog(@"%@",self.model.id);
        ZPLog(@"一位开关，需要隐藏两位开关，View3上移1.2");
        typeInput.name.text = Localize(@"设备名称1");
        SecondView.hidden = YES;
        ThreeView.hidden = YES;
        divider2View.hidden = YES;
        divider1View.hidden = YES;
        MaimVIEwLayoutConstraint.constant = 348;
        ssecondViewLayoutConstraint.constant = -102;
    }
        if ([self.model.id containsString:@"62"]) {
            typeInput.name.text = Localize(@"设备名称1");
            SecondView.name.text = Localize(@"设备名称2");
            ThreeView.hidden = YES;
            divider1View.hidden = NO;
            SecondView.hidden = NO;
            SecondViewLayoutConstraint.constant = - 51;
            MaimVIEwLayoutConstraint.constant = 397;
        }
            if ([self.model.id containsString:@"63"]) {
                typeInput.name.text = Localize(@"设备名称1");
                SecondView.name.text = Localize(@"设备名称2");
                ThreeView.name.text = Localize(@"设备名称3");
                SecondView.hidden = NO;
                ThreeView.hidden = NO;
                divider2View.hidden = NO;
                divider1View.hidden = NO;
                MaimVIEwLayoutConstraint.constant = 450;
                ssecondViewLayoutConstraint.constant = 0;
            }
}
// 判断是否是GPRS设备
- (void)IFGPRS {
    NSString * string = self.model.sort;
    if ([string containsString:@"YFGPMT"] || [string containsString:@"CDMT10"] || [string containsString:@"CDMT16"] || [string containsString:@"CDMT60"] || [string containsString:@"GP1P"] || [string containsString:@"YCGP10"] || [string containsString:@"YCGP16"] || [string containsString:@"MC"] || [string containsString:@"GP3P"]) {
        connectBtn.hidden = YES;
        lookBtn.hidden = YES;
        alternativeButt.hidden = NO;
    }else {
       connectBtn.hidden = NO;
       alternativeButt.hidden = YES;
       lookBtn.hidden = NO;
    }
}

- (void)updateUI {
    
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
