//
//  TimeSettingViewController.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/19.
//  Copyright © 2018年 Bohan. All rights reserved.
//

static CGFloat cellHight = 50;
static CGFloat headerHight = 65;

#define kViewWidth  ScreenWidth - 20
static NSString * const timeReuseIdentifier = @"TimeSettingCollectionCell";

static NSString * const footerReuseIdentifier = @"TimeSettingFooterViewIdentifier";

static NSString * const heaterModel = @"180023007F000000007F000000007F000000007F000000007F000000007F000000007F000000007F000000007F03";
static NSString * const fishModel = @"000001007F020003007F040005007F060007007F080015007F160017007F180019007F200021007F220023007F03";
static NSString * const lightModel = @"000006007F220023597F000000007F000000007F000000007F000000007F000000007F000000007F000000007F03";
static NSString * const mosquitoModel = @"200023597F000006007F000000007F000000007F000000007F000000007F000000007F000000007F000000007F03";
static NSString * const apparatusModel = @"180023597F000006007F000000007F000000007F000000007F000000007F000000007F000000007F000000007F03";
static NSString * const parentModel = @"17002000FF0000000000000000000000000000000000000000000000000000000000000000000000000000000003";

#import "TimeSettingViewController.h"
#import "TimeSettingListViewController.h"
#import "TimeSettingModel.h"
#import "SGActionView.h"
#import "TimeModelCollectionViewCell.h"
#import "DebuggingANDPublishing.pch"
@interface TimeSettingViewController ()<UICollectionViewDataSource>
{
    NSArray *loopModels;
    __weak IBOutlet UIButton *openBtn;
    __weak IBOutlet UIButton *closeBtn;
    NSDateFormatter *formatter;
    NSArray *modelContents;
    NSIndexPath *selectedIndexPath;
    BOOL isParentModel;

}
@property (nonatomic, strong)NSMutableArray *datas;
@end

@implementation TimeSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"时段设置");
    if (@available(iOS 11.0, *)){
        [(UIScrollView *)self.view setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self setUp];
    [self loadData];
    [self loopOpenCloseTime];
}

- (void)setUp
{
    self.datas = [NSMutableArray array];
    loopModels = @[Localize(@"热水器"), Localize(@"鱼缸"), Localize(@"小夜灯"), Localize(@"蚊香"), Localize(@"取暖器"), Localize(@"家长模式")];
    modelContents = @[heaterModel, fishModel, lightModel, mosquitoModel, apparatusModel,parentModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:CHANGETIMEMODEL object:nil];

    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    UICollectionViewFlowLayout *lay = [[UICollectionViewFlowLayout alloc] init];
    lay.itemSize = CGSizeMake(floor((kViewWidth - 40)/3), cellHight);
    lay.minimumLineSpacing = 20;
    lay.minimumInteritemSpacing = 10;
    lay.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    lay.footerReferenceSize = CGSizeMake(kViewWidth, headerHight);
    modelCollectionView.collectionViewLayout = lay;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [modelCollectionView registerNib:[UINib nibWithNibName:@"TimeModelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:timeReuseIdentifier];
    [modelCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerReuseIdentifier];
    
}

- (void)loadData
{
    
    
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0008";
    model.deviceNo = self.deviceNo;
    [self.view startLoading];
    
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        
        if (!error) {
            
            if (((NSString *)response).length == 120) {
                
                NSString *content = [response substringWithRange:NSMakeRange(((NSString *)response).length - 96, 92)];
                [weakSelf caculateWithString:content];
                
            }
            
        }else
        {
            [HintView showHint:Localize(@"加载数据失败")];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
        ZPLog(@"--------%@",response);
    }];
    
}

- (void)loopOpenCloseTime
{
    
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0028";
    model.deviceNo = self.deviceNo;
    [self.view startLoading];
    
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        
        if (!error) {
            
            if (((NSString *)response).length > 32) {
                
                NSString *content = [response substringWithRange:NSMakeRange(24, 8)];
                
                NSMutableString *openTime = [NSMutableString stringWithString:[content substringToIndex:4]];
                [openTime insertString:@":" atIndex:2];
                
                NSMutableString *closeTime = [NSMutableString stringWithString:[content substringFromIndex:4]];
                [closeTime insertString:@":" atIndex:2];

                [openBtn setTitle:openTime forState:UIControlStateNormal];
                [closeBtn setTitle:closeTime forState:UIControlStateNormal];
                
            }
            
        }else
        {
            [HintView showHint:error.localizedDescription];
        }
    }];
    
}

- (void)openLoopModel
{
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0027";
    model.deviceNo = self.deviceNo;
    NSMutableString *content = [NSMutableString stringWithString:[openBtn.titleLabel.text stringByAppendingString:closeBtn.titleLabel.text]];
    model.content = [content stringByReplacingOccurrencesOfString:@":" withString:@""];
    [self.view startLoading];
    
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        
        if (!error) {
            
            [HintView showHint:Localize(@"已开启循环通断模式")];
            
            [self configRunModelWithModelStr:@"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005" isLoop:YES];

        }else
        {
            [HintView showHint:error.localizedDescription];
        }
        
        ZPLog(@"--------%@",response);
    }];
}


- (void)changeModel:(NSString *)content isParentCancel:(BOOL)cancel
{
    
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0009";
    model.deviceNo = self.deviceNo;
    model.content = [content substringToIndex:content.length - 2];
    [self.view startLoading];
    
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        
        if (cancel) {
            
            if (!error) {
                isParentModel = NO;
                [self caculateWithString:@"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004"];
                
                selectedIndexPath = nil;
                
                UIButton *customHeader = [modelCollectionView viewWithTag:200];
                customHeader.layer.borderColor = [UIColor getColor:@"cccccc"].CGColor;
                [customHeader setBackgroundColor:[UIColor whiteColor]];
                [modelCollectionView reloadData];

            }else
            {
                [HintView showHint:error.localizedDescription];
            }
        }else
        {
            if (!error) {
                
                UIButton *customHeader = [modelCollectionView viewWithTag:200];
                customHeader.layer.borderColor = [UIColor getColor:@"cccccc"].CGColor;
                [customHeader setBackgroundColor:[UIColor whiteColor]];
                
                [weakSelf caculateWithString:content];
                [HintView showHint:Localize(@"模式已切换")];
                
            }else
            {
                [HintView showHint:Localize(@"模式切换失败")];
            }
        }
        
        
    }];
    
}


- (void)configRunModelWithModelStr:(NSString *)modelStr isLoop:(BOOL)isLoop
{
    //        [status setText:@"设备正在执行时段运行模式，请点击查看(长按查看默认时段)"];
    
    if (isLoop) {
        
        selectedIndexPath = nil;
        settingBtn.hidden = YES;
        [status setText:Localize(@"设备正在执行循环通断模式")];
        [loopView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(status.mas_bottom).offset(30);
        }];

    }else
    {
        settingBtn.hidden = NO;
        
        [loopView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(settingBtn.mas_bottom).offset(20);
        }];
        [status setText:Localize(@"设备正在执行时段运行模式，请点击查看")];
        
        [settingBtn setTitle:Localize(@"查看") forState:UIControlStateNormal];

    }
    [self.view updateConstraints];

//    [];
    [status setTextColor:[UIColor greenColor]];

    UIButton *customHeader = [modelCollectionView viewWithTag:200];
    
    if (isParentModel || [modelContents containsObject:modelStr]) {
        customHeader.layer.borderColor = [UIColor getColor:@"cccccc"].CGColor;
        [customHeader setBackgroundColor:[UIColor whiteColor]];
        if (isParentModel) {
            
            selectedIndexPath = [NSIndexPath indexPathForItem:5 inSection:0];
        }else {
            selectedIndexPath = [NSIndexPath indexPathForItem:[modelContents indexOfObject:modelStr] inSection:0];
        }
    }else if(!isLoop)
    {
        selectedIndexPath = nil;
        customHeader.layer.borderColor = RGBColor(61, 141, 241, 0.8).CGColor;
        [customHeader setBackgroundColor:RGBColor(61, 141, 241, 0.8)];
    }
    [modelCollectionView reloadData];
}

- (void)caculateWithString:(NSString *)content {

    NSString *str = [content substringFromIndex:content.length - 2];
    if ([str isEqualToString:@"03"]) {
        
        
        [self.datas removeAllObjects];
        BOOL parent = NO;
        BOOL isValidate = NO;
        
        for (NSInteger i = 0; i < 9; i++) {
            
            NSString *time= [content substringWithRange:NSMakeRange(i*10, 10)];
            
            TimeSettingModel *model = [[TimeSettingModel alloc] init];
            
            NSMutableString *start = [[time substringToIndex:4] mutableCopy];
            [start insertString:@":" atIndex:2];
            
            NSMutableString *end = [[time substringWithRange:NSMakeRange(4, 4)] mutableCopy];
            [end insertString:@":" atIndex:2];
            
            model.startTime = start;
            model.endTime = end;
            model.week = [time substringFromIndex:time.length - 2];
            
            NSString *week = [Utils getBinaryByHex:model.week];
            
            if ([[week substringToIndex:1] isEqualToString:@"1"]) {
                parent = YES;
            }
//            isParentModel = parent;
            //家长模式
//            if (isParentModel) {
//                isValidate = YES;
//                model.open = [[week substringToIndex:1] isEqualToString:@"1"]?YES:NO;
//            }else
//            {
//                if (([start isEqualToString:end] || ([[time substringToIndex:4] integerValue] > [[time substringWithRange:NSMakeRange(4, 4)] integerValue])) || [[week substringFromIndex:1] isEqualToString:@"0000000"]) {
//                    model.open = NO;
//                }else
//                {
//                    model.open = YES;
//                    isValidate = YES;
//                }
//            }

//            [self.datas addObject:model];

        } 
//
        //有效的时段设置模式
        if (isValidate) {
            [self configRunModelWithModelStr:content isLoop:NO];

            return;
        }

    }else if([str isEqualToString:@"05"])
    {
        [self configRunModelWithModelStr:content isLoop:YES];
        return;
    }
    
    selectedIndexPath = nil;
    isParentModel = NO;
    settingBtn.hidden = NO;
    [loopView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(settingBtn.mas_bottom).offset(20);
    }];
    [status setText:Localize(@"设备未设置时段数据，请点击设置")];
    [status setTextColor:[UIColor getColor:@"fd5b55"]];
    [settingBtn setTitle:Localize(@"设置") forState:UIControlStateNormal];
    [self.view updateConstraints];

    
    UIButton *customHeader = [modelCollectionView viewWithTag:200];
    customHeader.layer.borderColor = [UIColor getColor:@"cccccc"].CGColor;
    [customHeader setBackgroundColor:[UIColor whiteColor]];
    [modelCollectionView reloadData];

//    [self configNoData];
    
}

//- (void)configNoData
//{
//    NSMutableArray *arr = [NSMutableArray array];
//    for (int i = 0; i < 9 ; i++) {
//        TimeSettingModel *model = [[TimeSettingModel alloc] init];
//
//        model.startTime = @"00:00";
//        model.endTime = @"00:00";
//        model.week = @"00";
//        model.open = NO;
//        [arr addObject:model];
//    }
//
//    self.datas = arr;
//}


- (void)viewDidLayoutSubviews
{
    [modelCollectionView.superview setFrame:CGRectChangeHeight(modelCollectionView.superview.frame, modelCollectionView.contentSize.height + 72)];
    [modelCollectionView setFrame:CGRectChangeHeight(modelCollectionView.frame, 260)];

    [(UIScrollView *)self.view setContentSize:CGSizeMake(ScreenWidth, CGRectGetMaxY(modelCollectionView.superview.frame)+ 10)];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//时段设置的设置
- (IBAction)settingAction {
    
    TimeSettingListViewController *list = [[TimeSettingListViewController alloc] init];
    list.datas = self.datas;
    list.deviceNo = self.deviceNo;
    list.isParentModel = isParentModel;
    [self.navigationController pushViewController:list animated:YES];

}

- (IBAction)openAction {
    
    [self openLoopModel];
}

- (IBAction)cancelAction {
    
    [CommonOperation cancelDeviceRunModel:self.deviceNo result:^(id response, NSError *error) {
        if (!error) {
            isParentModel = NO;
            [HintView showHint:Localize(@"取消成功")];
            [openBtn setTitle:@"00:00" forState:UIControlStateNormal];
            [closeBtn setTitle:@"00:00" forState:UIControlStateNormal];
            
            [self caculateWithString:@"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004"];
            
        }else
        {
            [HintView showHint:error.localizedDescription];
        }
        
    }];
}
- (IBAction)timeSelectAction:(UIButton *)sender {
    
    
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowHourMinute scrollToDate:[formatter dateFromString:sender.titleLabel.text] CompleteBlock:^(NSDate *selectDate) {
        [sender setTitle:[formatter stringFromDate:selectDate] forState:UIControlStateNormal];

    }];
    datepicker.hideBackgroundYearLabel = YES;
    datepicker.dateLabelColor = kDefualtColor;
    datepicker.doneButtonColor = kDefualtColor;
    [datepicker show];

}

- (IBAction)perideRunCancel {
    
    if (isParentModel) {
        
        NSString *contentStr = @"";
        for (TimeSettingModel *model in self.datas) {
            
            NSString *item = [model.startTime stringByReplacingOccurrencesOfString:@":" withString:@""];
            item = [item stringByAppendingString:[model.endTime stringByReplacingOccurrencesOfString:@":" withString:@""]];
            
            NSString *week = [Utils getBinaryByHex:model.week];
            week = [week stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"0"];
            model.week = [Utils getHexByBinary:week];
            item = [item stringByAppendingString:model.week];
            
            contentStr = [contentStr stringByAppendingString:item];
        }
        contentStr = [contentStr stringByAppendingString:@"03"];

        [self changeModel:contentStr isParentCancel:YES];
        
    }else
    {
        [CommonOperation cancelDeviceRunModel:self.deviceNo result:^(id response, NSError *error) {
            if (!error) {
                
                [self caculateWithString:@"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004"];
                
                [HintView showHint:Localize(@"取消成功")];
                
                selectedIndexPath = nil;
                
                UIButton *customHeader = [modelCollectionView viewWithTag:200];
                customHeader.layer.borderColor = [UIColor getColor:@"cccccc"].CGColor;
                [customHeader setBackgroundColor:[UIColor whiteColor]];
                [modelCollectionView reloadData];

                
            }else
            {
                [HintView showHint:error.localizedDescription];
            }
            
        }];
        
    }

}

- (void)customAction
{
    TimeSettingListViewController *list = [[TimeSettingListViewController alloc] init];
    
    NSMutableArray *arr;
    if (!selectedIndexPath) {
        arr = [NSMutableArray array];
        for (int i = 0; i<9; i++) {
            
            TimeSettingModel *model = [[TimeSettingModel alloc] init];
            model.startTime = @"00:00";
            model.endTime = @"00:00";
            model.week = @"00";
            
            [arr addObject:model];
        }
    }else
    {
        arr = self.datas;
    }
    list.datas = arr;

    list.deviceNo = self.deviceNo;
    [self.navigationController pushViewController:list animated:YES];

}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TimeModelCollectionViewCell *cell = (TimeModelCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:timeReuseIdentifier forIndexPath:indexPath];
    
    [cell.name setText:loopModels[indexPath.row]];
    if (selectedIndexPath && selectedIndexPath.row == indexPath.row) {
        [cell setSelected:YES];
    }else
    {
        [cell setSelected:NO];
    }
    
    return cell;
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerReuseIdentifier forIndexPath:indexPath];
        
        if (!header) {
            header = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 10, kViewWidth, headerHight)];
        }
        
        UIButton *customHeader = [header viewWithTag:200];
        if (!customHeader) {
            
            customHeader = [[UIButton alloc] init];
            
            [customHeader setTag:200];
            [header addSubview:customHeader];
            
            [customHeader.titleLabel setFont:Font(15)];
            [customHeader setTitleColor:[UIColor getColor:@"333333"] forState:UIControlStateNormal];
            [customHeader setBackgroundColor:[UIColor clearColor]];
            [customHeader setTitle:Localize(@"自定义") forState:UIControlStateNormal];
            customHeader.layer.borderWidth = 1;
            customHeader.layer.cornerRadius = 5;
            customHeader.layer.borderColor = [UIColor getColor:@"cccccc"].CGColor;
            [customHeader addTarget:self action:@selector(customAction) forControlEvents:UIControlEventTouchUpInside];
            
            [customHeader mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(header).with.mas_offset(UIEdgeInsetsMake(20, 10, 0, 10));
            }];
        }
        
        return header;
        
    }
    return nil;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath = indexPath;
    [collectionView reloadData];
    [self changeModel:modelContents[indexPath.row] isParentCancel:NO];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
