//
//  NetworkRequest.m
//  AppKit
//
//  Created by YangLin on 2017/12/18.
//  Copyright © 2017年 YangLin. All rights reserved.
//

#import "NetworkRequest.h"
#import "NetworkRequest+Utils.h"
#import "NSError+Message.h"
#import "NSData+Base64.h"
//#import "NSString+XML.h"
#import "DebuggingANDPublishing.pch"
static NSString *const soapNameSpace = @"http://bohansever.top/";


@interface NetworkRequest()
@property (nonatomic, strong, readwrite) AFHTTPSessionManager *session;
@end

@implementation NetworkRequest

+ (instancetype)sharedInstance{
    
    static NetworkRequest *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetworkRequest alloc] init];
        instance.session = [[AFHTTPSessionManager alloc] init];
        instance.session.requestSerializer = [AFHTTPRequestSerializer serializer];
        instance.session.responseSerializer = [AFXMLParserResponseSerializer serializer];
        
        instance.session.requestSerializer.timeoutInterval = 15;
        [instance.session.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/xml", @"application/xml", @"text/html", @"text/plain", @"text/json", @"text/javascript",@"charset=utf-8", @"application/soap+xml", nil]];
    });
    
    [instance.session.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [instance.session.reachabilityManager stopMonitoring];
            
            //            [HintView showGreenHint:@"网络联接中断，请检查网络后重试..."];
            
            [instance.session.operationQueue cancelAllOperations];
            return ;
        }
    }];
    
    
    return instance;
    
}


- (void)requestWithUrl:(NSString *)urlStr parameter:(NSDictionary *)paramater completion:(CompletionBlock)block
{
    [self requestWithUrl:urlStr parameter:paramater isSign:NO completion:block];
    ZPLog(@"%@",urlStr);
}


- (void)requestSignWithUrl:(NSString *)urlStr parameter:(NSDictionary *)paramater completion:(CompletionBlock)block
{
    [self requestWithUrl:urlStr parameter:paramater isSign:YES completion:block];
}


- (void)requestWithUrl:(NSString *)urlStr parameter:(NSDictionary *)paramater isSign:(BOOL)sign completion:(CompletionBlock)block
{
    NSString *theUrl = [self urlStrHandle:urlStr];
    
    NSString *soapMessage = [self soapWithMethodName:urlStr parameters:paramater];
    
    [self.session.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapMessage;
    }];
    [self.session POST:theUrl parameters:soapMessage progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (block) {
            NSDictionary *dic = [self xmlParse:responseObject methodName:urlStr];
            [self resultHandleWithResponse:dic complationBlock:block];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (block) {
            block(0,error.errorConvert);
        }
    }];
}


#pragma mark 网络请求
//- (void)requestWithUrl:(NSString *)urlStr
//             parameter:(NSDictionary *)paramater
//               success:(NetworkBlock)success
//               failure:(NetworkBlock)failure
//{
//    NSString *theUrl = [[Configuration getServer] stringByAppendingString:urlStr];
//
//    NSDictionary *dic = [CommonOperation publicParamatersWithDic:paramater isSign:NO];
//
//    [self POST:theUrl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        [WDLoadingTip hideLoading];
//
//        if (success) {
//
//            success(responseObject);
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
////        [WDLoadingTip fuaileWithText:@"操作失败，请稍后再试"];
//
//        if (failure) {
//
//            failure(error);
//            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            //                [WDLoadingTip fuaileWithText:@"操作失败，请稍后再试"];
//            //            });
//
//        }
//    }];
//
//}

//- (void)uploadFileWithUrl:(NSString *)urlStr
//                 filePath:(NSString *)filePath
//                paramater:(NSDictionary *)paramater
//                  success:(NetworkBlock)success
//                  failure:(NetworkBlock)failure
//{
//
//    NSString *theUrl = [[Configuration getServer] stringByAppendingString:urlStr];
//
//    NSDictionary *dic = [CommonOperation publicParamatersWithDic:paramater isSign:NO];
//
//    [self.session POST:theUrl parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//
//        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"image" fileName:@"image.png" mimeType:@"image/png" error:nil];
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //        [WDLoadingTip hideLoading];
//
//
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//        //        [WDLoadingTip fuaileWithText:@"上传失败"];
//
//        if (failure) {
//            failure(error);
//            //            [WDLoadingTip fuaileWithText:@"上传失败"];
//        }
//
//    }];
//
//}
//
//- (void)uploadFileWithUrl:(NSString *)urlStr
//                 fileData:(NSData *)data
//                paramater:(NSDictionary *)paramater
//                  success:(NetworkBlock)success
//                  failure:(NetworkBlock)failure
//{
//
//    NSString *theUrl = [[Configuration getServer] stringByAppendingString:urlStr];
//
//    NSDictionary *dic = [CommonOperation publicParamatersWithDic:paramater isSign:NO];
//
//    [self POST:theUrl parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//
//        //        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"image" fileName:@"image.png" mimeType:@"image/png" error:nil];
//        [formData appendPartWithFileData:data name:@"image" fileName:@"image.png" mimeType:@"image/png"];
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //        [WDLoadingTip hideLoading];
//
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //        [WDLoadingTip hideLoading];
//
//        if (failure) {
//            failure(error);
//            //            [WDLoadingTip fuaileWithText:@"上传失败"];
//        }
//
//    }];
//
//}


@end
