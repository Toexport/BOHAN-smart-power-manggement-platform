//
//  UIScrollView+Refresh.h
//  UFA
//
//  Created by YangLin on 2017/7/25.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RefreshState)
{
    RefreshStateBegin = 0,
    RefreshStateHeaderEnd,
    RefreshStateFooterEnd,
    RefreshStateNoData
};
typedef void(^LoadBlock)(void);
typedef void(^DidSlectedRowBlock)(id object);

@interface UIScrollView (Refresh)


/**
 下拉刷新
 
 @param headerBlock 下拉刷新回调
 */
- (void)setupRefreshHeaderBlock:(void (^)())headerBlock;

/**
 下拉刷新、上拉加载
 
 @param headerBlock 下拉刷新回调
 @param footerBlock 上拉加载回调
 */
- (void)setupRefreshHeaderBlock:(void (^)())headerBlock footerBlock:(void (^)())footerBlock;

- (void)setState:(RefreshState)state;
@end

@interface UIScrollView (Page)
//分页数据
@property (nonatomic,assign) NSUInteger pageSize;//每页大小
@property (nonatomic,assign) NSUInteger currentPage;//当前页
@property (nonatomic,assign) NSUInteger pageCount;//总页数
@property (nonatomic, copy) NSArray *datas;//数据源

//点击、加载
@property (nonatomic, copy) LoadBlock loadBlock;//加载数据回调block
@property (nonatomic, copy)DidSlectedRowBlock didSelectedBlock;

//样式
@property (nonatomic,assign) BOOL separatorInsetZero;//分隔线从最左边开始


/**
 下拉刷新、上拉加载方法

 @param fresh 是否需要刷新
 @param page 是否需要加载
 */
- (void)shouldRefresh:(BOOL)fresh shouldPage:(BOOL)page;

/**
 修改刷新状态方法
 */
- (void)changeState;


/**
 重置当前页数据，当上拉加载时请求失败时调用
 */
- (void)resetCurrentPage;

//- (void)setUp;


- (NSMutableArray *)allDatasWithNews:(NSArray *)array;

//- (void)errorHeadle;
@end

//@interface UIScrollView (Data)
//
//
//@end


