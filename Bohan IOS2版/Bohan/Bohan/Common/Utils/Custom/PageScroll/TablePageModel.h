//
//  TablePageModel.h
//  UFA
//
//  Created by YangLin on 2017/7/26.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface TablePageModel : NSObject

@property (nonatomic, weak)UITableView *currentTable;//当前tableview
@property (nonatomic, strong)NSMutableArray *datas;//数据源
@property (nonatomic, assign)BOOL isload;
@property (nonatomic, assign)NSUInteger pageNo;//当前页数
@property (nonatomic, assign)NSUInteger pageSize;//每页大小
@property (nonatomic, assign)NSUInteger totalSize;//总页数
@property (nonatomic, copy) NSString *message;

@end
