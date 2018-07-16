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

@interface BindingViewController () {
    __weak IBOutlet UITextField *deviceTF; // 设备ID输入框
    __weak IBOutlet CustomInputView *typeInput; //文字输入1
    __weak IBOutlet UIScrollView *scrollView; //scrollView
    __weak IBOutlet CustomInputView *typeInput2;  //文字输入2
    __weak IBOutlet CustomInputView *typeInput3;  //文字输入3
    __weak IBOutlet CustomInputView *posInput;  // 设备位置
    __weak IBOutlet CustomInputView *brandInput; // 电器品牌
    __weak IBOutlet NSLayoutConstraint *TypeInput2LayoutConstraint; // 输入框2的高度
    __weak IBOutlet NSLayoutConstraint *TypeInput3LayoutConstraint; // 输入框3的高度
    __weak IBOutlet NSLayoutConstraint *bdffLayoutConstraint; // View的高度
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
    typeInput.name.text = Localize(@"设备名称");
    posInput.name.text = Localize(@"设备位置");
    brandInput.name.text = Localize(@"电器品牌");
    deviceTF.clearButtonMode = UITextFieldViewModeWhileEditing;  // 一键删除文字
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; // 滚动时键盘隐藏
    deviceTF.keyboardType = UIKeyboardTypeNumberPad; // 设置只能输入数字
    [self.view startLoading];
    [self loadPosList];
    [self loadNameList];
    [self loadBrandList];
    [self TextField];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        DBLog(@"全部请求完毕");
        [self.view stopLoading];
    });
}

// 隐藏text输入框
- (void) TextField {
    /*****************************此处用来判断是否显示设备名称2-3项*********************/
    TypeInput2LayoutConstraint.constant = CGFLOAT_MIN;
    typeInput2.hidden = YES;
    TypeInput3LayoutConstraint.constant = CGFLOAT_MIN;
    typeInput3.hidden = YES;
    bdffLayoutConstraint.constant = - 59; // (隐藏两个text输入框的高度)
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self TextFileTest]; // 实时监控text
}

// 二维码
- (IBAction)scanAction {
    ScanViewController *scan = [[ScanViewController alloc] init];
    [scan getResultStr:^(NSString *result) {
        if (result && result.length>0) {
            deviceTF.text = result;
        }
    }];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"设备具备相机");
        [self presentViewController:scan animated:YES completion:nil];
    }else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您的设备暂时不支持扫码", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
        [alert show];
        ZPLog(@"没有摄像");
    }
}

- (IBAction)bindAction {
//    [self unBindDevice]; // 解绑设备
//    if (deviceTF.text.length == 0 || posInput.contentTF.text.length == 0 || typeInput.contentTF.text.length == 0 || brandInput.contentTF.text.length == 0) {
//        [HintView showHint:Localize(@"请填完整设备信息")];
//        return;
//    }else
//        if ([deviceTF.text containsString:@"62"]) {
//            if (deviceTF.text.length == 0 || typeInput2.contentTF.text.length == 0 || posInput.contentTF.text.length == 0 || typeInput.contentTF.text.length == 0 || brandInput.contentTF.text.length == 0) {
//                [HintView showHint:Localize(@"请填完整设备信息")];
//                return;
//            }
//    }else
//        if ([deviceTF.text containsString:@"63"]) {
//            if (deviceTF.text.length == 0 || typeInput2.contentTF.text.length == 0 || typeInput3.contentTF.text.length == 0 || posInput.contentTF.text.length == 0 || typeInput.contentTF.text.length == 0 || brandInput.contentTF.text.length == 0) {
//                    [HintView showHint:Localize(@"请填完整设备信息")];
//                    return;
//                }
//            }
//    [self bindDevice];
    [self POSTs];
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

// 获取(如：客厅，卧室)
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

// 获取(如：客厅，卧室)
- (void)loadNameList {
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
//            WifiConnectViewController * connect = [[WifiConnectViewController alloc] init];
//            connect.deviceNo = deviceTF.text;
//            [self.navigationController pushViewController:connect animated:YES];

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
        }else {
            [HintView showHint:error.localizedDescription];
        }
  }];
}

// 获取设备信息（单个）这个
- (void)POSTs {
    [self.view startLoading];
    NSDictionary * dict = @{@"deviceCode":deviceTF.text};
//    NSDictionary * dic = @{@"devicecode":deviceTF.text};
    [[NetworkRequest sharedInstance]requestWithUrl:GET_DEVICE_INFO_URL parameter:dict completion:^(id response, NSError *error) {
        [self.view stopLoading];
        NSDictionary * dic = response[@"content"];
        if ([dic[@"sort"] isEqual:@"YC"]) { //换汤不换药
            ZPLog(@"不跳转");
        } else {
            
        }
    
        ZPLog(@"%@",dict);
        ZPLog(@"%@",error);
        ZPLog(@"%@",response);
    }];
}

//// 获取所有设备，判断是否是需要加入wifi的
//- (void)POSTs {
//    [self.view startLoading];
//   [[NetworkRequest sharedInstance] requestWithUrl:GET_DEVICE_LIST_URL parameter:nil completion:^(id response, NSError *error) {
//       ZPLog(@"%@",response);
//       NSArray *array = response[@"content"];
//       NSDictionary * dic = array[0];
//       NSString * sort = dic[@"sort"];
//       ZPLog(@"%@",sort);
//       if ([sort containsString:@"FYGPMT"] || [sort containsString:@"CDMT10"] || [sort containsString:@"CDMT16"]  || [sort containsString:@"CDMT60"]  || [sort containsString:@"GP1P"]  || [sort containsString:@"YCGP10"]  || [sort containsString:@"YCGP16"] || [sort containsString:@"MC"] || [sort containsString:@"GP3P"] || [sort containsString:@"YC"]) {
//           ZPLog(@"不需要加入wifi");
//           [self.navigationController popViewControllerAnimated:YES];
//          [HintView showHint:Localize(@"添加成功")];  // 提示框
//       }else {
//           WifiConnectViewController * connect = [[WifiConnectViewController alloc] init];
//           connect.deviceNo = deviceTF.text;
//        [self.navigationController pushViewController:connect animated:YES];
//       }
//    }];
//}

//解绑设备 （传入参数：设备编号；设备Key）
- (void)unBindDevice {
    [self.view startLoading];
    NSDictionary *dic = @{@"DeviceCode":deviceTF.text, @"DeviceKey":deviceTF.text};
    [[NetworkRequest sharedInstance] requestWithUrl:UNBINDING_DEVICE_URL parameter:dic completion:^(id response, NSError *error) {
        [self.view stopLoading];
        //请求成功
        if (!error) {
            
        }else {
            [HintView showHint:error.localizedDescription];
        }
    }];
}


// 实时监控text输入框动向
- (void) TextFileTest {
    [deviceTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(changeValue:)   name:@"changeValue"  object:nil];
}

// 这两个方法实时监控text输入框
-(void)textFieldDidChange:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeValue" object:textField];
}

- (void)changeValue:(NSNotification *)notification {
    UITextField * textField = notification.object;
    //要实现的监听方法操作
    ZPLog(@"%@",textField.text);
    if (textField.text.length > 12) {
        ZPLog(@"输入有误");
        [HintView showHint:Localize(@"请输入正确的设备ID")];
    }
    
    if ([textField.text hasPrefix:@"62"]) {
        ZPLog(@"%@",textField.text);
        typeInput.name.text = Localize(@"开关1");
        typeInput2.name.text = Localize(@"开关2");
        TypeInput2LayoutConstraint.constant = CGFLOAT_MIN;
        typeInput2.hidden = NO;
        bdffLayoutConstraint.constant = 0; // (隐藏一个text输入框的高度)
        TypeInput3LayoutConstraint.constant = CGFLOAT_MIN;
        typeInput3.hidden = YES;
    }else
        if ([textField.text hasPrefix:@"63"]) {
            typeInput.name.text = Localize(@"开关1");
            typeInput2.name.text = Localize(@"开关2");
            typeInput3.name.text = Localize(@"开关3");
            TypeInput2LayoutConstraint.constant = CGFLOAT_MIN;
            typeInput2.hidden = NO;
            TypeInput3LayoutConstraint.constant = 60;
            typeInput3.hidden = NO;
            bdffLayoutConstraint.constant = + 20; // (正常状态)
    }else {
        /*****************************此处用来判断是否显示设备名称2-3项*********************/
        typeInput.name.text = Localize(@"设备名称");
        TypeInput2LayoutConstraint.constant = CGFLOAT_MIN;
        typeInput2.hidden = YES;
        TypeInput3LayoutConstraint.constant = CGFLOAT_MIN;
        typeInput3.hidden = YES;
        bdffLayoutConstraint.constant = - 59; // (隐藏两个text输入框的高度)
        /****************************************************************************/
    }
}


@end
