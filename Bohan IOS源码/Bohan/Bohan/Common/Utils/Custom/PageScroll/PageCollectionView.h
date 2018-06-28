//
//  PageCollectionView.h
//  AppKit
//
//  Created by YangLin on 2017/12/26.
//  Copyright © 2017年 YangLin. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ContentTableView.h"
#import "UIScrollView+Refresh.h"
typedef void(^PageIndexBlock)(NSUInteger index);

@interface PageCollectionViewCell:UICollectionViewCell
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,copy) NSString* tableClassStr;


//-(instancetype)initWithFrame:(CGRect)frame tableViewStr:(NSString *)tableStr;
@end

@interface PageCollectionView : UICollectionView

@property (nonatomic, copy) NSArray *datas;
@property (nonatomic, copy) LoadBlock loadBlock;
@property (nonatomic, copy) PageIndexBlock indexBlock;
@property (nonatomic,copy) NSString* tableClassStr;
//@property (nonatomic, copy)DidSlectedRowBlock didSelectedBlock;
@property (nonatomic, weak) id actionDelegate;

- (instancetype)initWithFrame:(CGRect)frame contentClassStr:(NSString *)classStr;
@end
