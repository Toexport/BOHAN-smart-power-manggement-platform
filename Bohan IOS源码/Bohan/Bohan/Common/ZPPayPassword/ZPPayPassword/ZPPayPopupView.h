//
//  ZPPayPopupView.h
//  Bohan
//
//  Created by summer on 2018/10/10.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ZPPayPopupViewDelegate <NSObject>

- (void)didClickForgetPasswordButton;
- (void)didPasswordInputFinished:(NSString *)password;

@end

@interface ZPPayPopupView : UIView
@property (nonatomic, weak) id <ZPPayPopupViewDelegate> delegate;

- (void)showPayPopView;
- (void)hidePayPopView;
- (void)didInputPayPasswordError;

@end

NS_ASSUME_NONNULL_END
