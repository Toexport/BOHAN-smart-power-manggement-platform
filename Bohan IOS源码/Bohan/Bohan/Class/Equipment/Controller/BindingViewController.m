//
//  BindingViewController.m
//  Bohan
//
//  Created by Yang Lin on 2017/12/31.
//  Copyright © 2017年 Bohan. All rights reserved.
//

#import "BindingViewController.h"
#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CustomInputView.h"
#import "WifiConnectViewController.h"
#import "DebuggingANDPublishing.pch"
@interface BindingViewController ()
{
    __weak IBOutlet UITextField *deviceTF;
    __weak IBOutlet CustomInputView *posInput;
    __weak IBOutlet CustomInputView *typeInput;
    __weak IBOutlet CustomInputView *brandInput;
    
    dispatch_group_t group;
    dispatch_queue_t queue;
}
@end

@implementation BindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"绑定设备");
    
    group = dispatch_group_create();
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    posInput.name.text = Localize(@"设备位置");
    typeInput.name.text = Localize(@"用电类型");
    brandInput.name.text = Localize(@"电器品牌");
    
    [self.view startLoading];
    [self loadPosList];
    [self loadNameList];
    [self loadBrandList];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        DBLog(@"全部请求完毕");
        
        [self.view stopLoading];

    });
    
}



// 二维码
- (IBAction)scanAction {
    
    ScanViewController *scan = [[ScanViewController alloc] init];
    [scan getResultStr:^(NSString *result) {
        
        if (result && result.length>0) {
            deviceTF.text = result;
        }
    }];
    [self presentViewController:scan animated:YES completion:nil];
}

- (IBAction)bindAction {
    
//    [self unBindDevice];
    if (deviceTF.text.length == 0 || posInput.contentTF.text.length == 0 || typeInput.contentTF.text.length == 0 || brandInput.contentTF.text.length == 0) {
        [HintView showHint:Localize(@"请填完整设备信息")];
        return;
    }
    [self bindDevice];
}

- (void)loadPosList
{
    
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);

        [[NetworkRequest sharedInstance] requestWithUrl:GET_POS_NAME_LIST_URL parameter:nil completion:^(id response, NSError *error) {
            dispatch_group_leave(group);
            DBLog(@"%@",response);
            if (!error) {
                NSArray *postions = [[response[@"content"] componentsSeparatedByString:@","] mutableCopy];
                posInput.datas = postions;
            }
        }];
    });
    
}

- (void)loadBrandList {
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [[NetworkRequest sharedInstance] requestWithUrl:GET_BRAND_LIST_URL parameter:nil completion:^(id response, NSError *error) {
            dispatch_group_leave(group);

            DBLog(@"%@",response);
            if (!error) {
                NSArray *brands = [[response[@"content"] componentsSeparatedByString:@","] mutableCopy];
                brandInput.datas = brands;

            }
        }];
        
    });
    
}

- (void)loadNameList
{
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);

        [[NetworkRequest sharedInstance] requestWithUrl:GET_NAME_LIST_URL parameter:nil completion:^(id response, NSError *error) {
            dispatch_group_leave(group);

            DBLog(@"%@",response);
            if (!error) {
                NSArray *names = [[response[@"content"] componentsSeparatedByString:@","] mutableCopy];
                typeInput.datas = names;
            }
            
        }];
    });
    
}

- (void)bindDevice
{
    [self.view startLoading];
    NSDictionary * dic = @{@"DeviceCode":deviceTF.text, @"DeviceKey":deviceTF.text, @"PosName":posInput.contentTF.text, @"LoadName":typeInput.contentTF.text, @"LoadBrand":brandInput.contentTF.text};
    [[NetworkRequest sharedInstance] requestWithUrl:BINDING_DEVICE_URL parameter:dic completion:^(id response, NSError *error) {
        
        [self.view stopLoading];
        //请求成功
        if (!error) {
            WifiConnectViewController * connect = [[WifiConnectViewController alloc] init];
            connect.deviceNo = deviceTF.text;
//            判断输入框中的数字是否包含制定的数字，如果有则不跳转直接成功，如果没有需要跳转到下个界面
            
            
            [self.navigationController pushViewController:connect animated:YES];
        }else
        {
            [HintView showHint:error.localizedDescription];
        }
    }];
}

- (void)unBindDevice
{
    [self.view startLoading];
    NSDictionary *dic = @{@"DeviceCode":deviceTF.text, @"DeviceKey":deviceTF.text};
    [[NetworkRequest sharedInstance] requestWithUrl:UNBINDING_DEVICE_URL parameter:dic completion:^(id response, NSError *error) {
        [self.view stopLoading];
        //请求成功
        if (!error) {
            
        }else
        {
            [HintView showHint:error.localizedDescription];
        }
        
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
