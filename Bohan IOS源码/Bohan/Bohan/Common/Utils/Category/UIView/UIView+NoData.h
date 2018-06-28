//
//  UIView+NoData.h
//  UFA
//
//  Created by YangLin on 2017/12/29.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NoDataViewDelegate;

@interface NoDataView : UIView

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *title;
@property (nonatomic, strong)UILabel *detail;
@property (nonatomic, strong)UIButton *reloadBtn;
@end


@protocol NoDataViewDelegate <NSObject>

@optional
- (void)reloadDidClick;

- (BOOL)shouldShowNoDataView;

@end

//@protocol NoDataViewDataSource <NSObject>
//
//@optional
//- (UIImage *)noDataImage;
//- (NSString *)noDataTitle;
//- (NSString *)noDataDetail;
//
//@end

@interface UIView (NoData)

@property (nonatomic, weak) id<NoDataViewDelegate> noDatadelegate;
//@property (nonatomic, weak) id<NoDataViewDataSource> noDataSource;
@property (nonatomic, copy) NSString * noDataImage;
@property (nonatomic, copy) NSString * noDataTitle;
@property (nonatomic, copy) NSString * noDataDetail;

- (void)noDataReload;

@end
