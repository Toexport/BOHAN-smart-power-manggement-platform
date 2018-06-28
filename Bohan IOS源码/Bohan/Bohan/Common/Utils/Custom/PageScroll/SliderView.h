//
//  SliderView.h
//  UFA
//
//  Created by YangLin on 2017/8/4.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SliderBlock)(NSUInteger index);
typedef void(^ShowMoreBlock)(NSUInteger index);

@interface SliderView : UIView


@property (nonatomic, copy)NSArray *datas;
@property (nonatomic, copy)SliderBlock block;
@property (nonatomic, copy)ShowMoreBlock moreBlock;

- (instancetype)initWithFrame:(CGRect)frame datas:(NSArray *)datas;

//根据下标设置当前选中按钮
- (void)selectedWithIndex:(NSUInteger)index;
@end
