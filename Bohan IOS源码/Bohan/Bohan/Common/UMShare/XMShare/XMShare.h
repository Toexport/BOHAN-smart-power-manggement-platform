//
//  XMShare.h
//  XiaoMainTravel
//
//  Created by ArihinM on 2017/10/11.
//  Copyright © 2017年 encifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UShareUI/UShareUI.h>
@interface XMShare : NSObject

+ (instancetype)shareManager;
- (void)showWithController:(UIViewController *)viewController;
- (void)showWithController:(UIViewController *)viewController Title:(NSString *)title Descr:(NSString *)descr DeUrl:(NSString *)deUrl Image:(id)image;

//- (void)loginWithController:(UIViewController *)viewController Type:(UMSocialPlatformType)type;

@end
