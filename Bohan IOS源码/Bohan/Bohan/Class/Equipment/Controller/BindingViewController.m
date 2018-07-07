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
    typeInput.name.text = Localize(@"设备名称");
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

////获取电器位置列表(如：客厅，卧室)
- (void)loadPosList {
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [[NetworkRequest sharedInstance] requestWithUrl:GET_POS_NAME_LIST_URL parameter:nil completion:^(id response, NSError *error) {
            dispatch_group_leave(group);
            ZPLog(@"%@",response);
            if (!error) {
                NSArray *postions = [[response[@"content"] componentsSeparatedByString:@","] mutableCopy];
                posInput.datas = postions;
            }
        }];
    });
}

// 获取设备列表(如：客厅，卧室)
- (void)loadBrandList {
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [[NetworkRequest sharedInstance] requestWithUrl:GET_BRAND_LIST_URL parameter:nil completion:^(id response, NSError *error) {
            dispatch_group_leave(group);

            ZPLog(@"%@",response);
            if (!error) {
                NSArray *brands = [[response[@"content"] componentsSeparatedByString:@","] mutableCopy];
                brandInput.datas = brands;

            }
        }];
        
    });
    
}

// 获取设备列表(如：客厅，卧室)
- (void)loadNameList
{
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);

        [[NetworkRequest sharedInstance] requestWithUrl:GET_NAME_LIST_URL parameter:nil completion:^(id response, NSError *error) {
            dispatch_group_leave(group);

            ZPLog(@"%@",response);
            if (!error) {
                NSArray *names = [[response[@"content"] componentsSeparatedByString:@","] mutableCopy];
                typeInput.datas = names;
            }
            
        }];
    });
}

// 绑定设备请求
- (void)bindDevice {
    [self.view startLoading];
    NSDictionary * dic = @{@"DeviceCode":deviceTF.text, @"DeviceKey":deviceTF.text, @"PosName":posInput.contentTF.text, @"LoadName":typeInput.contentTF.text, @"LoadBrand":brandInput.contentTF.text};
    [[NetworkRequest sharedInstance] requestWithUrl:BINDING_DEVICE_URL parameter:dic completion:^(id response, NSError *error) {
        [self.view stopLoading];
        ZPLog(@"%@",response);
        
        //请求成功
        if (!error) {
//            [self POSTs];
            WifiConnectViewController * connect = [[WifiConnectViewController alloc] init];
            connect.deviceNo = deviceTF.text;
            [self.navigationController pushViewController:connect animated:YES];
            
//            判断输入框中的数字是否包含制定的数字，如果有则不跳转直接成功，如果没有需要跳转到下个界面
//            NSString * string = deviceTF.text;
//            if ([string hasPrefix:@"65"]) {
//                ZPLog(@"%@包含", string);
//            NSDictionary * dict = @{@"DeviceCode":deviceTF.text};
//            [[NetworkRequest sharedInstance]requestWithUrl:GET_DEVICE_INFO_URL parameter:dict completion:^(id response, NSError *error) {
//                [self.view startLoading];
//                ZPLog(@"%@",dict);
//                ZPLog(@"%@",error);
//                ZPLog(@"%@",response);
//            }];
            
//            [[NetworkRequest sharedInstance] requestWithUrl:GET_DEVICE_INFO_URL parameter:nil completion:^(id response, NSError *error) {
//
//                [self.view stopLoading];
//
//                ZPLog(@"%@",response);
//            }];
            
//            }else {
//                ZPLog(@"%@不包含", string);
//                [self.navigationController popViewControllerAnimated:YES];
//                [HintView showHint:Localize(@"添加成功")];  // 提示框
//            }
        }else
        {
            [HintView showHint:error.localizedDescription];
        }
    }];
}

// 获取设备信息（单个）
//- (void)POSTs {
//    [self.view startLoading];
//    NSDictionary * dict = @{@"DeviceCode":deviceTF.text};
//    [[NetworkRequest sharedInstance]requestWithUrl:GET_DEVICE_INFO_URL parameter:dict completion:^(id response, NSError *error) {
//        [self.view stopLoading];
//        ZPLog(@"%@",dict);
//        ZPLog(@"%@",error);
//        ZPLog(@"%@",response);
//    }];
//}

// 获取所有设备，判断是否是需要加入wifi的
- (void)POSTs {
    [self.view startLoading];
   [[NetworkRequest sharedInstance] requestWithUrl:GET_DEVICE_LIST_URL parameter:nil completion:^(id response, NSError *error) {
       ZPLog(@"%@",response);
       NSArray *array = response[@"content"];
       NSDictionary * dic = array[0];
       NSString * sort = dic[@"sort"];
       ZPLog(@"%@",sort);
       if ([sort containsString:@"FYGPMT"] || [sort containsString:@"CDMT10"] || [sort containsString:@"CDMT16"]  || [sort containsString:@"CDMT60"]  || [sort containsString:@"GP1P"]  || [sort containsString:@"YCGP10"]  || [sort containsString:@"YCGP16"] || [sort containsString:@"MC"] || [sort containsString:@"GP3P"] || [sort containsString:@"YC"]) {
           ZPLog(@"不需要加入wifi");
           [self.navigationController popViewControllerAnimated:YES];
          [HintView showHint:Localize(@"添加成功")];  // 提示框
       }else {
           WifiConnectViewController * connect = [[WifiConnectViewController alloc] init];
           connect.deviceNo = deviceTF.text;
        [self.navigationController pushViewController:connect animated:YES];
       }
    }];
}
//解绑设备 （传入参数：设备编号；设备Key）
- (void)unBindDevice {
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


@end
