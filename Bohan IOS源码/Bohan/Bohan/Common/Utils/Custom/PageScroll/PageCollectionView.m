//
//  PageCollectionView.m
//  AppKit
//
//  Created by YangLin on 2017/12/26.
//  Copyright © 2017年 YangLin. All rights reserved.
//

#import "PageCollectionView.h"
#import "TablePageModel.h"
#import "ContentTableView.h"
#import "DebuggingANDPublishing.pch"
static NSString * const pageCellIdentifier = @"PageCollectionViewCell";

//@interface PageCollectionViewCell()
//{
//    Class tableClass;
//}
//@end

@implementation PageCollectionViewCell


- (UITableView *)tableView
{
    if (!_tableView) {

        Class tableClass = NSClassFromString(self.tableClassStr);
        NSString *error = [NSString stringWithFormat:@"当前类%@不存在",self.tableClassStr];
        NSAssert(tableClass != nil , error);

        
        _tableView = [[tableClass alloc] initWithFrame:self.bounds];
        
        if ([tableClass isKindOfClass:[UITableView class]]) {
            
            _tableView.currentPage = 1;
            _tableView.pageSize = 10;

        }
        if ([_tableView respondsToSelector:@selector(shouldRefresh:shouldPage:)]) {
            
            [_tableView shouldRefresh:YES shouldPage:NO];
        }
    }

    return _tableView;
}

@end

@interface PageCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation PageCollectionView


- (instancetype)initWithFrame:(CGRect)frame contentClassStr:(NSString *)classStr
{
    return [self initWithFrame:frame collectionViewLayout:[[UICollectionViewFlowLayout alloc] init] contentClassStr:classStr];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout contentClassStr:(NSString *)classStr
{
    self = [super initWithFrame:frame collectionViewLayout:[self flowLayout]];

    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        
        _datas = [NSArray array];
        self.tableClassStr = classStr;
        
        [self registerClass:[PageCollectionViewCell class] forCellWithReuseIdentifier:pageCellIdentifier];
    }

    return self;
}


-(UICollectionViewFlowLayout *)flowLayout{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight - kTopHeight - kNavBarHeight - 45);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    return  flowLayout;
}

- (void)setDatas:(NSArray *)datas
{
    _datas = datas;
    [self reloadData];
}


#pragma mark - contentCollectionView的代理方法和数据源方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  self.datas.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pageCellIdentifier forIndexPath:indexPath];
    cell.tableClassStr = self.tableClassStr;
    //此处是特殊需求
    ((ContentTableView *)cell.tableView).actionDelegate = self.actionDelegate;
    if (cell.tableView.superview != cell.contentView) {
        
        [cell.contentView addSubview:cell.tableView];
    }
    TablePageModel *model = self.datas[indexPath.row];

    if (!cell.tableView.loadBlock) {
        cell.tableView.loadBlock = self.loadBlock;
    }
    if (!cell.tableView.didSelectedBlock) {
        cell.tableView.didSelectedBlock = self.didSelectedBlock;
    }
    model.currentTable = cell.tableView;
    if (model.pageNo >0) {
        model.currentTable.currentPage = model.pageNo;
    }
    if (model.pageSize > 0) {
        model.currentTable.pageSize = model.pageSize;
    }
    
    [cell.tableView setDatas:model.datas];
    [cell.tableView reloadData];
    
    return cell;
    
}

#pragma mark - 上下联动的实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (self.indexBlock) {
        self.indexBlock(self.contentOffset.x /self.bounds.size.width);
    }

}


@end
