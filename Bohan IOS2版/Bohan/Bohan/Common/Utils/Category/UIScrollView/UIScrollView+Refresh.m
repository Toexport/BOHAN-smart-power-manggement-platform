//
//  UIScrollView+Refresh.m
//  UFA
//
//  Created by YangLin on 2017/7/25.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "MJRefresh.h"
#import "DebuggingANDPublishing.pch"
static const void *currentPageKey = &currentPageKey;
static const void *pageSizeKey = &pageSizeKey;
static const void *pageCountKey = &pageCountKey;
static const void *datasKey = &datasKey;
static const void *loadBlockKey = &loadBlockKey;
static const void *selectedBlockKey = &selectedBlockKey;
static const void *separatorInsetZeroKey = &separatorInsetZeroKey;


@implementation UIScrollView (Refresh)

- (void)setupRefreshHeaderBlock:(void (^)())headerBlock
{
    [self setupRefreshHeaderBlock:headerBlock footerBlock:nil];
}

- (void)setupRefreshHeaderBlock:(void (^)())headerBlock footerBlock:(void (^)())footerBlock
{
    
    if (headerBlock) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:headerBlock];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        
        self.mj_header = header;
    }
    
    if (footerBlock) {
        //上拉刷新
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:footerBlock];
        footer.hidden = YES;
        footer.automaticallyHidden = YES;
        self.mj_footer = footer;
    }
    
}

- (void)setState:(RefreshState)state
{
    if (state == RefreshStateBegin) {
        [self.mj_header beginRefreshing];
    }else if (state == RefreshStateHeaderEnd)
    {
        [self.mj_header endRefreshing];
        [self.mj_footer resetNoMoreData];
    }else if (state == RefreshStateFooterEnd)
    {
        [self.mj_footer endRefreshing];
        [self.mj_footer resetNoMoreData];

    }else if (state == RefreshStateNoData)
    {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}
@end

@implementation UIScrollView (Page)


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
    self.currentPage ++;

    if (self.loadBlock) {
        self.loadBlock();
    }
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    if ([self isKindOfClass:[UITableView class]] && self.separatorInsetZero) {
//        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
//            [self setSeparatorInset:UIEdgeInsetsZero];
//        }
//
//        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
//            [self setLayoutMargins:UIEdgeInsetsZero];
//        }
//    }
//}

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
        self.currentPage --;
    }
}

- (NSMutableArray *)allDatasWithNews:(NSArray *)array
{
    NSMutableArray *datas = [NSMutableArray arrayWithArray:self.datas];
    //    self.pageCount = pageCount;
    if (self.currentPage == 1) {
        [datas removeAllObjects];
    }
    [datas addObjectsFromArray:array];
    
    [self setDatas:datas];
    if ([self isKindOfClass:[UITableView class]]) {
        [(UITableView *)self reloadData];

    }else if ([self isKindOfClass:[UICollectionView class]])
    {
        [(UICollectionView *)self reloadData];
    }
    
    
//    //无数据处理
//    if (datas.count == 0) {
//        [self showNoDataViewWithTitle:title];
//    }else
//    {
//        [self hideEmptyView];
//    }
    
    return datas;
}


//- (void)errorHeadle
//{
//    [self resetCurrentPage];
//
//    if (self.datas.count == 0) {
//
//        [self showEmptyViewType:EmptyViewTypeLoadFailed pullReload:YES];
//
//        //        if (flag == 0) {
//        //
//        //            [self showEmptyViewType:EmptyViewTypeNeworkError pullReload:YES];
//        //        }else{
//        //            [self showEmptyViewType:EmptyViewTypeLoadFailed pullReload:YES];
//        //        }
//    }
//}


#pragma mark - getter and setter 方法

- (NSUInteger)currentPage {
    return [objc_getAssociatedObject(self, currentPageKey) unsignedIntegerValue];
}

- (void)setCurrentPage:(NSUInteger)currentPage{
    objc_setAssociatedObject(self, currentPageKey, [NSNumber numberWithUnsignedInteger:currentPage], OBJC_ASSOCIATION_ASSIGN);
}


- (NSUInteger)pageCount {
    return [objc_getAssociatedObject(self, pageCountKey) unsignedIntegerValue];
}

- (void)setPageCount:(NSUInteger)pageCount{
    objc_setAssociatedObject(self, pageCountKey, [NSNumber numberWithUnsignedInteger:pageCount], OBJC_ASSOCIATION_ASSIGN);
}


- (NSUInteger)pageSize {
    return [objc_getAssociatedObject(self, pageSizeKey) unsignedIntegerValue];
}

- (void)setPageSize:(NSUInteger)pageSize{
    objc_setAssociatedObject(self, pageSizeKey, [NSNumber numberWithUnsignedInteger:pageSize], OBJC_ASSOCIATION_ASSIGN);
}


- (NSArray *)datas {
    return objc_getAssociatedObject(self, datasKey);
}

- (void)setDatas:(NSArray *)datas{
    objc_setAssociatedObject(self, datasKey, datas, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (LoadBlock )loadBlock {
    return objc_getAssociatedObject(self, loadBlockKey);
}

- (void)setLoadBlock:(LoadBlock)loadBlock{
    objc_setAssociatedObject(self, loadBlockKey, loadBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (DidSlectedRowBlock )didSelectedBlock {
    return objc_getAssociatedObject(self, selectedBlockKey);
}

- (void)setDidSelectedBlock:(DidSlectedRowBlock)didSelectedBlock{
    objc_setAssociatedObject(self, selectedBlockKey, didSelectedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)separatorInsetZero
{
    return [objc_getAssociatedObject(self, separatorInsetZeroKey) boolValue];
}

- (void)setSeparatorInsetZero:(BOOL)separatorInsetZero
{
    objc_setAssociatedObject(self, separatorInsetZeroKey, @(separatorInsetZero), OBJC_ASSOCIATION_ASSIGN);
    
    if (separatorInsetZero) {
        
        if ([self isKindOfClass:[UITableView class]]) {
            if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
                [(UITableView *)self setSeparatorInset:UIEdgeInsetsZero];
            }
            
            if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
                [self setLayoutMargins:UIEdgeInsetsZero];
            }
        }
    }
}
@end

