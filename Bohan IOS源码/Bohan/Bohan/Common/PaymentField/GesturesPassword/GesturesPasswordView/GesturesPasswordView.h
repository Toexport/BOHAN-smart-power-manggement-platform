//
//  GesturesPasswordView.h
//  Bohan
//
//  Created by summer on 2018/9/11.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, passwordtype) {
    ResetPassWordType = 1,
    UsePassWordType = 2,
};

@class GesturesPasswordView;
@protocol GesturesPasswordViewDelegate <NSObject>
- (BOOL)unlockView:(GesturesPasswordView *)unlockView withPassword:(NSString *)password;

- (void)setPassWordSuccess:(NSString *)tabelname;
@end

@interface GesturesPasswordView : UIView
@property (nonatomic, weak) id<GesturesPasswordViewDelegate> delegate;

@end
