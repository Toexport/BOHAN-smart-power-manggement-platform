//
//  CommonOperation.h
//  UFA
//
//  Created by YangLin on 2017/7/20.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonOperation : NSObject

//
///**
// 密钥请求方法
// */
//+ (void)keyRequest;
//
///**
// 区域请求方法
// */
//+ (void)areaRequestComplation:(void(^)(NSInteger flag, NSArray *cityArr))block;
//
//+ (NSArray *)areaData;
//
//
///**
// 版本更新接口
//
// */
//+ (void)updateRequest;
//
//
///**
// 分类请求方法
//
// @param block 请求成功回调
// */
//+ (void)categoryRequestCompletion:(void(^)(NSInteger flag, id response))block;
//
//
///**
// 获取分类数据
//
// @return 返回持久化的分类数据
// */
//+ (NSArray *)categoryData;

/**
 公用参数设置

 @param dic 私有参数
 @return 返回全部参数
 */
+ (NSDictionary *)publicParamatersWithDic:(NSDictionary *)dic isSign:(BOOL)sign;


///**
// 获取订单状态
//
// @param status 状态值
// @return 返回对应状态
// */
//+ (NSString *)stringWithOrderStatus:(NSString *)status;
//
///**
// 获取交易类型
//
// @param type 类型值
// @return 返回对应类型
// */
//+ (NSString *)stringWithDealType:(NSString *)type;
//
//+ (NSString *)stringWithOrderStatusIndex:(NSInteger )status;

//取消设备运行状态
+ (void)cancelDeviceRunModel:(NSString *)deviceNo result:(void(^)(id response, NSError *error))block;
@end
