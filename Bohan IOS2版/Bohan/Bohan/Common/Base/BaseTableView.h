//
//  BaseTableView.h
//  UFA
//
//  Created by YangLin on 2017/7/3.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TablePageModel;
typedef void(^LoadBlock)(void);
//typedef void(^DidSlectedRowBlock)(NSIndexPath *indexPath);

@interface BaseTableView : UITableView

@property (nonatomic,assign) NSInteger pageSize;//每页大小
@property (nonatomic,assign) NSInteger currentPage;//当前页
@property (nonatomic,assign) NSInteger pageCount;//总页数
@property (nonatomic, copy) NSArray *datas;//数据源
@property (nonatomic,assign) BOOL separatorInsetZero;//分隔线从最左边开始
@property (nonatomic, copy) LoadBlock loadBlock;//加载数据回调block
//@property (nonatomic, copy)DidSlectedRowBlock didSelectedBlock;

/**
 初始化方法

 @param frame UITableView 的frame
 @param fresh 是否需要刷新
 @return 返回实例对象
 */
- (instancetype)initWithFrame:(CGRect)frame shouldRefresh:(BOOL)fresh;

/**
 初始化方法
 
 @param frame UITableView 的frame
 @param fresh 是否需要刷新
 @param page 是否分页
 @return 返回实例对象
 */
- (instancetype)initWithFrame:(CGRect)frame shouldRefresh:(BOOL)fresh shouldPage:(BOOL)page;

/**
 初始化方法

 @param frame UITableView 的frame
 @param style UITableView 样式
 @param fresh 是否需要刷新
 @return 返回实例对象
 */
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style shouldRefresh:(BOOL)fresh;


/**
 初始化方法

 @param frame UITableView 的frame
 @param style UITableView 样式
 @param fresh 是否需要刷新
 @param page 是否分页
 @return 返回实例对象
 */
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style shouldRefresh:(BOOL)fresh shouldPage:(BOOL)page;


/**
 修改刷新状态方法
 */
- (void)changeState;


/**
 重置当前页数据，当上拉加载时请求失败时调用
 */
- (void)resetCurrentPage;

- (void)setUp;

@end
