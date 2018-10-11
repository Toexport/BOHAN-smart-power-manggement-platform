//
//  XMShare.m
//  XiaoMainTravel
//
//  Created by ArihinM on 2017/10/11.
//  Copyright © 2017年 encifang. All rights reserved.
//

#import "XMShare.h"

#define ShareAppkey @"22167b3dffd48"
#define WeiboAppkey @"1233863390"
#define WeiboAppSecret @"17539bfac9d994ae123b4a569180fb72"
#define QQAppId @"1106441763"
#define QQAppSecret @"kGkPTZHU5QP4RHZa"
#define WeChatAppId @"wxbe4d14822b6278cb" //wx53fe2facdc1df93f
#define WeChatSecret @"b05f2f702ddaaf523e29aead14ebd602" //067837e7ba39566e54bf07bf08a41fa1 //7bbc1a12d43ff12eb095f06f34ba680a
#define APId @"2017112100068650"

#define defaultUrl @"http://www.wheatrip.com/"

@interface XMShare ()

@end

@implementation XMShare

+ (instancetype)shareManager{
    static XMShare *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XMShare alloc] init];
        [manager configUSharePlatforms];
    });
    return manager;
}

- (void)showWithController:(UIViewController *)viewController {
    [self showWithController:viewController Title:nil Descr:nil DeUrl:nil Image:nil];
}

- (void)showWithController:(UIViewController *)viewController Title:(NSString *)title
                     Descr:(NSString *)descr
                     DeUrl:(NSString *)deUrl
                     Image:(UIImage  *)image {
    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRoundAndSuperRadius;
    
    [self definePlatforms:NO];
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //设置文本
        messageObject.text = descr?descr:@"选择小麦,让旅行简单而美好!";
        messageObject.title = title?title:@"小麦旅行";
        UIImage *img = image?image:[UIImage imageNamed:@"icon_fillet"];
        
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:messageObject.title descr:messageObject.text thumImage:img];
        //设置网页地址
        shareObject.webpageUrl = deUrl?deUrl:defaultUrl;
        
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:viewController completion:^(id data, NSError *error) {
        }];
    }];
}

- (void)configUSharePlatforms {
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WeChatAppId appSecret:WeChatSecret redirectURL:defaultUrl];
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Tim appKey:QQAppId/*设置QQ平台的appID*/  appSecret:nil redirectURL:defaultUrl];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:WeiboAppkey  appSecret:WeiboAppSecret redirectURL:defaultUrl];
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:APId appSecret:nil redirectURL:defaultUrl];
}

- (void)definePlatforms:(BOOL)isLogin {
    if (isLogin) {
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                                   @(UMSocialPlatformType_QQ),
                                                   @(UMSocialPlatformType_Tim),
                                                   @(UMSocialPlatformType_Sina)
                                                   ]];
    } else {
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                                   @(UMSocialPlatformType_WechatTimeLine),
                                                   @(UMSocialPlatformType_WechatFavorite),
                                                   @(UMSocialPlatformType_QQ),
                                                   @(UMSocialPlatformType_Qzone),
                                                   @(UMSocialPlatformType_Tim),
                                                   @(UMSocialPlatformType_Sina),
                                                   @(UMSocialPlatformType_TencentWb),
                                                   @(UMSocialPlatformType_AlipaySession)
                                                   ]];
    }
}

@end
