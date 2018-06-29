//
//  NetworkRequest+Utils.m
//  AppKit
//
//  Created by YangLin on 2017/12/18.
//  Copyright © 2017年 YangLin. All rights reserved.
//
#import "NetworkRequest+Utils.h"
#import "XMLUtil.h"
#import "NSError+Message.h"
//#import "NSData+Base64.h"
#import "DebuggingANDPublishing.pch"
#import "SoapManager.h"


static NSString *const soapNameSpace = @"http://bohansever.top:/";


@implementation NetworkRequest (Utils)

- (NSString *)urlStrHandle:(NSString *)urlStr
{

    return [SERVER stringByAppendingString:urlStr];
//    return [[SERVER stringByAppendingString:urlStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

//    return [SERVER stringByAppendingString:[NSString stringWithFormat:@"%@?wsdl",urlStr]];
}


- (void)allHTTPHeaderFields
{
    SoapManager *manager = [SoapManager manager];
    
    NSDictionary *dic = [manager headers];
    
    for (NSString *key in [dic allKeys]) {
        [self.session.requestSerializer setValue:dic[key] forHTTPHeaderField:key];
    }
}

- (NSString *)soapWithMethodName:(NSString *)method parameters:(NSDictionary *)parameters
{
    //设置请求头
    SoapManager *manager = [SoapManager manager];
    
    NSDictionary *headers;
    if (TOKEN) {
        
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        NSString *language = [df objectForKey:@"App_Language_Switch_Key"];
        
//        NSString *localeLanguageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
        NSString *localeLanguageCode = [NSLocale preferredLanguages][0];//当前设置的语言
        localeLanguageCode = [[localeLanguageCode componentsSeparatedByString:@"-"] firstObject];//去掉后面国家后缀
        headers = @{@"token":TOKEN, @"language":@"english"};
        if ((language && [language isEqualToString:@"zh-Hans"]) || (!language && [localeLanguageCode isEqualToString:@"zh"])) {
            headers = @{@"token":TOKEN, @"language":@"simple-chinese"};
        }

    }
    [manager soapWithMethodName:method soapHeader:@"Certificate" headers:headers parameters:parameters];
    
    [self allHTTPHeaderFields];
//    return [[manager soapBodyMessage] dataUsingEncoding:NSUTF8StringEncoding];
    return [manager soapBodyMessage];
//    return [[manager soapBodyMessage] stringByReplacingPercentEscapesUsingEncoding:<#(NSStringEncoding)#>];
}


- (NSDictionary *)paramaterHandle:(NSDictionary *)paramater sign:(BOOL)sign
{
    return [CommonOperation publicParamatersWithDic:paramater isSign:sign];
}


- (void)resultHandleWithResponse:(id)responseObject complationBlock:(CompletionBlock)block
{
    if ([[responseObject[@"statusCode"] stringValue] isEqualToString:@"0"]) {

        block(responseObject,nil);
    }else if([[responseObject[@"statusCode"] stringValue] isEqualToString:@"2"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUTNOTIFICATION object:responseObject];
//        block(responseObject,nil);


    }else
    {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:[responseObject[@"statusCode"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}];
        block(nil,error.errorConvert);

    }
}

- (NSDictionary *)xmlParse:(NSXMLParser *)parse methodName:(NSString *)method
{
    
    XMLUtil *xml = [[XMLUtil alloc] init];
    
    xml.par = parse;
    xml.methodName = method;
//    NSLog(@"解析前parse=%@, xml = %@",parse,xml);
    
    [xml.par parse];
    
//    NSLog(@"解析后parse=%@, xml = %@",parse,xml);

    return xml.data;

    
}

@end
