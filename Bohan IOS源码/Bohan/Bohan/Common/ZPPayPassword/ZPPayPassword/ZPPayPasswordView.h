//
//  ZPPayPasswordView.h
//  Bohan
//
//  Created by summer on 2018/10/10.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ZPInputPasswordCompletionBlock) (NSString *password);

@interface ZPPayPasswordView : UIView

@property (nonatomic, copy)ZPInputPasswordCompletionBlock completionBlock;
@property (nonatomic ,assign) NSInteger opretionType;

// 抖动输入框
- (void)startShakeViewAnimation;

- (void)didInputPasswordError;

@end

