//
//  SGSheetMenu.m
//  SGActionView
//
//  Created by Sagi on 13-9-6.
//  Copyright (c) 2013年 AzureLab. All rights reserved.
//

#import "SGSheetMenu.h"
#import <QuartzCore/QuartzCore.h>

#define kMAX_SHEET_TABLE_HEIGHT   400

@interface SGSheetMenu () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *subItems;

@property (nonatomic, strong) void(^actionHandle)(NSInteger);
@end

@implementation SGSheetMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BaseMenuBackgroundColor(self.style);

        _selectedItemIndex = NSIntegerMax;
        _items = [NSArray array];
        _subItems = [NSArray array];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = BaseMenuTextColor(self.style);
        [self addSubview:_titleLabel];
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [self addSubview:_tableView];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self setupWithTitle:title items:itemTitles subItems:nil];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles subTitles:(NSArray *)subTitles
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self setupWithTitle:title items:itemTitles subItems:subTitles];
    }
    return self;
}

- (void)setupWithTitle:(NSString *)title items:(NSArray *)items subItems:(NSArray *)subItems;
{
    _titleLabel.text = title;
    _items = items;
    _subItems = subItems;
}

- (void)setStyle:(SGActionViewStyle)style{
    _style = style;
    
    self.backgroundColor = BaseMenuBackgroundColor(style);
    self.titleLabel.textColor = BaseMenuTextColor(style);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float height = 0;
//    float table_top_margin = 0;
    float table_bottom_margin = 5;
    
//    self.titleLabel.frame = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, 40)};
//    height += self.titleLabel.bounds.size.height;
//    height += table_top_margin;
    
    
    float contentHeight =self.tableView.contentSize.height;
    if (contentHeight > kMAX_SHEET_TABLE_HEIGHT) {
        contentHeight = kMAX_SHEET_TABLE_HEIGHT;
        self.tableView.scrollEnabled = YES;
    }else{
        self.tableView.scrollEnabled = NO;
    }
    self.tableView.frame = CGRectMake(0, height, self.bounds.size.width , contentHeight);
    height += self.tableView.bounds.size.height;
    
    height += table_bottom_margin;
    
    self.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, height)};
    self.roundedCorner = 4;//[self nicePerformance];
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
}

#pragma mark - 

- (void)triggerSelectedAction:(void (^)(NSInteger))actionHandle
{
    self.actionHandle = actionHandle;
}

#pragma mark - 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.subItems.count > 0) {
        return 55;
    }else{
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.textLabel.font = [UIFont systemFontOfSize:15];
//        cell.textLabel.textColor = BaseMenuTextColor(self.style);
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    UIView *hintView = [[UIView alloc] initWithFrame:CGRectMake(18, 17, 6, 6)];
    hintView.layer.cornerRadius = 3.0;
    hintView.layer.masksToBounds = YES;
    [cell.contentView addSubview:hintView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, cell.frame.size.width - 60, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.text = self.items[indexPath.row];
    label.textColor = BaseMenuTextColor(self.style);
    label.numberOfLines = 0;
    [cell.contentView addSubview:label];
    
//    cell.textLabel.text = self.items[indexPath.row];

    if (self.selectedItemIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        label.textColor = [UIColor getColor:@"2c97de"];
        hintView.backgroundColor = [UIColor getColor:@"2c97de"];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        label.textColor = BaseMenuTextColor(self.style);
        hintView.backgroundColor = BaseMenuTextColor(self.style);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedItemIndex != indexPath.row) {
        self.selectedItemIndex = indexPath.row;
        [tableView reloadData];
    }
    if (self.actionHandle) {
        double delayInSeconds = 0.15;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.actionHandle(indexPath.row);
        });
    }
}

@end
