//
//  FSAES128.h
//  UFA
//
//  Created by YangLin on 2017/7/20.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import <Foundation/Foundation.h>


#define SECRETKEY  [[NSUserDefaults standardUserDefaults] objectForKey:@"SECRETKEY"]//密钥key
#define SIGNKEY  [[NSUserDefaults standardUserDefaults] objectForKey:@"SIGNKEY"]//签名key

@interface FSAES128 : NSObject

/**
 *  加密
 *
 *  @param string 需要加密的string
 *
 *  @return 加密后的字符串
 */
+ (NSString *)AES128EncryptStrig:(NSString *)string;

/**
 *  解密
 *
 *  @param string 加密的字符串
 *
 *  @return 解密后的内容
 */
+ (NSString *)AES128DecryptString:(NSString *)string;




/**
 *  动态密钥加密方法
 *
 *  @param string 需要加密的string
 *
 *  @return 加密后的字符串
 */
+ (NSString *)AES128PrivateEncryptStrig:(NSString *)string;

/**
 *  动态密钥解密方法
 *
 *  @param string 加密的字符串
 *
 *  @return 解密后的内容
 */
+ (NSString *)AES128PrivateDecryptString:(NSString *)string;
    
@end
