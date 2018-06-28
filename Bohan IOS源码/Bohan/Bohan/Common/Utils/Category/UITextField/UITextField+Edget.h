//
//  UITextField+Edget.h
//  UFA
//
//  Created by YangLin on 2018/1/3.
//  Copyright © 2018年 UFA. All rights reserved.
//


#import <UIKit/UIKit.h>


/**
 ***注意：该category没有起作用，不知道为什么，暂时不用
 */
@interface UITextField (Edget)


@property (nonatomic, assign) CGFloat leftViewSpacing;//leftView X间距
@property (nonatomic, assign) CGFloat rightViewSpacing;//rightView X间距
@property (nonatomic, assign) CGFloat placeHolderSpacing;//placeHolder X间距
@property (nonatomic, assign) CGFloat textSpacing;//text X间距
@property (nonatomic, assign) CGFloat editSpacing;//edit X间距
@end
