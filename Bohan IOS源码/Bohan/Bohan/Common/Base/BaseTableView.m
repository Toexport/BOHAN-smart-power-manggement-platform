//
//  BaseTableView.m
//  UFA
//
//  Created by YangLin on 2017/7/3.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "BaseTableView.h"
#import "UIScrollView+Refresh.h"
#import "DebuggingANDPublishing.pch"
@implementation BaseTableView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
    
}

- (void)setUp{
    
    self.currentPage = 1;
    self.pageSize = 20;
    self.datas = [NSArray array];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame shouldRefresh:NO];
}

- (instancetype)initWithFrame:(CGRect)frame shouldRefresh:(BOOL)fresh {
    return [self initWithFrame:frame shouldRefresh:fresh shouldPage:NO];
}

- (instancetype)initWithFrame:(CGRect)frame shouldRefresh:(BOOL)fresh shouldPage:(BOOL)page {
    self = [super initWithFrame:frame];
    if (self) {
        [self shouldRefresh:fresh shouldPage:page];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    return [self initWithFrame:frame style:style shouldRefresh:NO];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style shouldRefresh:(BOOL)fresh {
    return [self initWithFrame:frame style:style shouldRefresh:fresh shouldPage:NO];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style shouldRefresh:(BOOL)fresh shouldPage:(BOOL)page
{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        [self shouldRefresh:fresh shouldPage:page];
    }
    
    return self;
}

- (void)shouldRefresh:(BOOL)fresh shouldPage:(BOOL)page
{
    [self setUp];
    
    MyWeakSelf
    
    [self setupRefreshHeaderBlock:fresh?^{
        MyStrongSelf
        [strongSelf setupHeader];
    }:nil footerBlock:page?^{
        
        MyStrongSelf
        [strongSelf setupFooter];
    }:nil];

}


- (void)setupHeader
{
    self.currentPage = 1;
    
    if (self.loadBlock) {
        self.loadBlock();
    }
}

- (void)setupFooter
{
    self.currentPage++;
    if (self.loadBlock) {
        self.loadBlock();
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.separatorInsetZero) {
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

- (void)changeState
{
    if (self.currentPage <= 1) {
        [self setState:RefreshStateHeaderEnd];
    }else
    {
        [self setState:RefreshStateFooterEnd];
    }
    
    if (self.currentPage >= self.pageCount) {
        [self setState:RefreshStateNoData];
    }
}

- (void)resetCurrentPage
{
    if (self.currentPage > 1) {
        self.currentPage--;
    }
}


#pragma mark - getter and setter 方法
- (void)setDatas:(NSArray *)datas
{
    _datas = datas;
    [self reloadData];
    
}
@end
