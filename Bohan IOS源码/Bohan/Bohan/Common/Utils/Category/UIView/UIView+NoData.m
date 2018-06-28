//
//  UIView+NoData.m
//  UFA
//
//  Created by YangLin on 2017/12/29.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "UIView+NoData.h"
#import <objc/runtime.h>
static const void *noDatadelegateKey = &noDatadelegateKey;
static const void *noDataImageKey = &noDataImageKey;
static const void *noDataTitleKey = &noDataTitleKey;
static const void *noDataDetailKey = &noDataDetailKey;
static const void *noDataViewKey = &noDataViewKey;

static const CGFloat IMAGEWIGHT = 91;
static const CGFloat TITLELEFT = 30;
static const CGFloat RELOADLEFT = 50;
static const CGFloat RELOADHIGHT = 40;

@implementation NoDataView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.imageView];
        [self addSubview:self.title];
        [self addSubview:self.detail];
        [self addSubview:self.reloadBtn];

    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];

    CGSize size = getTextSize(Font(15), self.title.text, ScreenWidth - 2*TITLELEFT);
    CGSize detailSize = getTextSize(Font(15), self.detail.text, ScreenWidth - 2*TITLELEFT);

    [self.imageView setFrame:CGRectChangeY(self.imageView.frame, (self.frame.size.height - IMAGEWIGHT - 40 - size.height - detailSize.height - RELOADHIGHT)/2.0)];
    [self.title setFrame:CGRectMake(TITLELEFT, CGRectGetMaxY(_imageView.frame) + 20, ScreenWidth-2*TITLELEFT, size.height)];
    [self.detail setFrame:CGRectMake(TITLELEFT, CGRectGetMaxY(_title.frame) + 10, ScreenWidth-2*TITLELEFT, detailSize.height)];
    [self.reloadBtn setFrame:CGRectMake(RELOADLEFT, CGRectGetMaxY(_detail.frame) + 10, ScreenWidth-2*RELOADLEFT, self.reloadBtn.bounds.size.height)];
    
}



- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGEWIGHT, IMAGEWIGHT)];
        _imageView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
        _imageView.image = [UIImage imageNamed:@"icon"];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _imageView;
}

- (UILabel *)title
{
    if (!_title) {
        
        _title = [[UILabel alloc]initWithFrame:CGRectMake(TITLELEFT, CGRectGetMaxY(_imageView.frame) + 20, ScreenWidth-2*TITLELEFT, TITLELEFT)];
        _title.font = Font(15.0f);
        _title.textColor = [UIColor getColor:@"999999"];
        _title.numberOfLines = 0;
        _title.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return _title;
}

- (UILabel *)detail
{
    if (!_detail) {
        
        _detail = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(_title.frame) + 10, ScreenWidth-2*TITLELEFT, TITLELEFT)];
        _detail.font = Font(15.0f);
        _detail.textColor = [UIColor getColor:@"999999"];
        _detail.numberOfLines = 0;
        _detail.textAlignment = NSTextAlignmentCenter;
        
    }
    return _detail;
}

- (UIButton *)reloadBtn
{
    if (!_reloadBtn) {
        _reloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(RELOADLEFT, CGRectGetMaxY(_detail.frame), ScreenWidth - 2*RELOADLEFT, RELOADHIGHT)];
        [_reloadBtn setTitle:Localize(@"重新加载") forState:UIControlStateNormal];
        _reloadBtn.titleLabel.font = Font(17);
        [_reloadBtn setTitleColor:[UIColor getColor:@"999999"] forState:UIControlStateNormal];
        _reloadBtn.layer.borderColor = [UIColor getColor:@"999999"].CGColor;
        _reloadBtn.layer.borderWidth = 1;
        _reloadBtn.layer.cornerRadius = 5;
        [_reloadBtn addTarget:self action:@selector(reloadAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _reloadBtn;
}


- (void)reloadAction{
    
    if (self.superview.noDatadelegate && [self.superview.noDatadelegate respondsToSelector:@selector(reloadDidClick)]) {

        [self.superview.noDatadelegate reloadDidClick];
        [self removeFromSuperview];

    }
}

@end


@interface UIView ()
@property (nonatomic, strong, readonly)NoDataView *noDataView;
@end

@implementation UIView (NoData)

#pragma mark - getter and setter 方法

- (id<NoDataViewDelegate>)noDatadelegate {
    return objc_getAssociatedObject(self, noDatadelegateKey);
}

- (void)setNoDatadelegate:(id<NoDataViewDelegate>)noDatadelegate{
    objc_setAssociatedObject(self, noDatadelegateKey, noDatadelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)noDataImage {
    NSString *image = objc_getAssociatedObject(self, noDataImageKey);
    if (!image) {
        image = @"logo";
    }
    return image;
}

- (void)setNoDataImage:(NSString *)noDataImage{
    objc_setAssociatedObject(self, noDataImageKey, noDataImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)noDataTitle {
    NSString *title = objc_getAssociatedObject(self, noDataTitleKey);
    if (!title) {
        title = @"暂无数据";
    }
    return title;
}

- (void)setNoDataTitle:(NSString *)noDataTitle{
    objc_setAssociatedObject(self, noDataTitleKey, noDataTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)noDataDetail {
    NSString *detail = objc_getAssociatedObject(self, noDataDetailKey);
    if (!detail) {
        detail = @"过会儿再来吧!";
    }
    return detail;
}

- (void)setNoDataDetail:(NSString *)noDataDetail{
    objc_setAssociatedObject(self, noDataDetailKey, noDataDetail, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NoDataView *)noDataView
{
    NoDataView *view = objc_getAssociatedObject(self, noDataViewKey);

    if (!view) {
        view = [[NoDataView alloc] initWithFrame:self.bounds];
        [view setBackgroundColor:[UIColor whiteColor]];
        objc_setAssociatedObject(self, noDataViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return view;
}


- (void)noDataReload
{
    
    BOOL shouldShow = YES;
    if ([self.noDatadelegate respondsToSelector:@selector(shouldShowNoDataView)]) {
        shouldShow = [self.noDatadelegate shouldShowNoDataView];
    }
    
    if (!shouldShow) {
        if ([self isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)self).scrollEnabled = YES;
        }
        [self.noDataView removeFromSuperview];
    }else
    {
        
        if ([self isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)self).scrollEnabled = NO;
        }
        
        if (!self.noDataView.superview) {
            [self addSubview:self.noDataView];
        }
    }
    
    [self.noDataView.imageView setImage:[UIImage imageNamed:self.noDataImage]];
    [self.noDataView.title setText:self.noDataTitle];
    [self.noDataView.detail setText:self.noDataDetail];
    [self layoutIfNeeded];
}

@end
