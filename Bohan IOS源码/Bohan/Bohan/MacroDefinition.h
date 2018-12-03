//
//  MacroDefinition.h
//  Bohan
//
//  Created by summer on 2018/11/28.
//  Copyright © 2018 Bohan. All rights reserved.
//

#ifndef MacroDefinition_h
#define MacroDefinition_h

//全局
#define appD ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define NavBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height + 44)
#define TabbarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49) // 适配iPhone x 底栏高度
//尺寸
#define ZP_Width [UIScreen mainScreen].bounds.size.width
#define ZP_height [UIScreen mainScreen].bounds.size.height


#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)


#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPad ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(768, 1024), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPadNew ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1536, 2048), [[UIScreen mainScreen] currentMode].size) : NO)

#define  iPhone6s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2000), [[UIScreen mainScreen] currentMode].size) : NO)

#define  iPhone6splus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iphoneX ((screenH==812)?1:0)


//#define ZP_Graybackground [UIColor colorWithHexString:@"#eeeeee"]

#endif /* MacroDefinition_h */
