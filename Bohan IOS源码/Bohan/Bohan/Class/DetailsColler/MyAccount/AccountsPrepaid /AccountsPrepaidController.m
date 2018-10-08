//
//  AccountsPrepaidController.m
//  Bohan
//
//  Created by summer on 2018/9/4.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "AccountsPrepaidController.h"
#import "DebuggingANDPublishing.pch"
#import "PrefixHeader.pch"
#import "AccountsPrepaidCell.h"
@interface AccountsPrepaidController ()<UITableViewDelegate,UITableViewDataSource,PKPaymentAuthorizationViewControllerDelegate>
{
    NSMutableArray *summaryItems;
    NSMutableArray *shippingMethods;
}


@end

@implementation AccountsPrepaidController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"账户充值");
    [self.Tableview registerNib:[UINib nibWithNibName:@"AccountsPrepaidCell" bundle:nil] forCellReuseIdentifier:@"AccountsPrepaidCell"];
    self.Tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountsPrepaidCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AccountsPrepaidCell" forIndexPath:indexPath];
    [cell setPayBlockBlock:^(id AmountPay, id PayWay) {
        ZPLog(@"%@%@",AmountPay,PayWay);
        self.PriceStr = AmountPay;
        self.PayWayStr = PayWay;
        if ([self.PayWayStr isEqualToString:@"ApplePay"]) {
            [self ApplePay]; //ApplePay
        }else
            if ([self.PayWayStr isEqualToString:@"WeChat"]) {
                ZPLog(@"暂时不支持WeChat");
            }else
                if ([self.PayWayStr isEqualToString:@"Alipay"]) {
                    ZPLog(@"暂时不支持Alipay");
                }
        
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 480;
}

// PAy
- (void)ApplePay {
    ZPLog(@"%@%@",self.PayWayStr,self.PriceStr);
    if (![PKPaymentAuthorizationViewController class]) {
        //PKPaymentAuthorizationViewController需iOS8.0以上支持
        NSLog(@"操作系统不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持");
        [HintView showHint:Localize(@"操作系统不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持")];
        return;
    }
    //检查当前设备是否可以支付
    if (![PKPaymentAuthorizationViewController canMakePayments]) {
        //支付需iOS9.0以上支持
        [HintView showHint:Localize(@"设备不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持")];
        NSLog(@"设备不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持");
        return;
    }
    //检查用户是否可进行某种卡的支付，是否支持Amex、MasterCard、Visa与银联四种卡，根据自己项目的需要进行检测
//    NSArray *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
     NSArray *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
    if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportedNetworks]) {
        NSLog(@"没有绑定支付卡");
        return;
    }
    
    NSLog(@"可以支付，开始建立支付请求");
    //设置币种、国家码及merchant标识符等基本信息
    PKPaymentRequest *payRequest = [[PKPaymentRequest alloc]init];
    payRequest.countryCode = @"CN";     //国家代码
    payRequest.currencyCode = @"CNY";       //RMB的币种代码
    payRequest.merchantIdentifier = @"merchant.Bohan";  //申请的merchantID
    payRequest.supportedNetworks = supportedNetworks;   //用户可进行支付的银行卡
    payRequest.merchantCapabilities = PKMerchantCapability3DS|PKMerchantCapabilityEMV;      //设置支持的交易处理协议，3DS必须支持，EMV为可选，目前国内的话还是使用两者吧
//    NSString * price = [NSNumber numberWithInteger:self.PriceStr];
    NSDecimalNumber *subtotalAmount = [NSDecimalNumber decimalNumberWithMantissa:self.PriceStr.longLongValue exponent:0 isNegative:NO];   //12.75
    PKPaymentSummaryItem *subtotal = [PKPaymentSummaryItem summaryItemWithLabel:Localize(@"商品价格") amount:subtotalAmount];
    
    NSDecimalNumber *totalAmount = [NSDecimalNumber zero];
    totalAmount = [totalAmount decimalNumberByAdding:subtotalAmount];
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:Localize(@"东莞伯瀚智能科技有限公司") amount:totalAmount];  //最后这个是支付
    
    summaryItems = [NSMutableArray arrayWithArray:@[subtotal, total]];
    //summaryItems为账单列表，类型是 NSMutableArray，这里设置成成员变量，在后续的代理回调中可以进行支付金额的调整。
    payRequest.paymentSummaryItems = summaryItems;
    
    //ApplePay控件
    PKPaymentAuthorizationViewController *view = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:payRequest];
    view.delegate = self;
    [self presentViewController:view animated:YES completion:nil];
}

#pragma mark - PKPaymentAuthorizationViewControllerDelegate
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                  didSelectShippingContact:(PKContact *)contact
                                completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion{
    
    //送货信息选择回调，如果需要根据送货地址调整送货方式，比如普通地区包邮+极速配送，偏远地区只有付费普通配送，进行支付金额重新计算，可以实现该代理，返回给系统：shippingMethods配送方式，summaryItems账单列表，如果不支持该送货信息返回想要的PKPaymentAuthorizationStatus
//    completion(PKPaymentAuthorizationStatusSuccess, shippingMethods, summaryItems);
}

-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectPaymentMethod:(PKPaymentMethod *)paymentMethod completion:(void (^)(NSArray<PKPaymentSummaryItem *> * _Nonnull))completion{
    //支付银行卡回调，如果需要根据不同的银行调整付费金额，可以实现该代理
    completion(summaryItems);
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion {
    
    PKPaymentToken *payToken = payment.token;
    //支付凭据，发给服务端进行验证支付是否真实有效
    PKContact *billingContact = payment.billingContact;     //账单信息
    //等待服务器返回结果后再进行系统block调用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //模拟服务器通信
        completion(PKPaymentAuthorizationStatusSuccess);
        ZPLog(@"%@--%@",payToken, billingContact);
    });
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
