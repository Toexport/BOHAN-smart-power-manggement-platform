//
//  SGSheetMenu.m
//  SGActionView
//
//  Created by Sagi on 13-9-6.
//  Copyright (c) 2013年 AzureLab. All rights reserved.
//

#import "SGTimePick.h"
//#import "CategoryModel.h"
#import <QuartzCore/QuartzCore.h>
#import "DebuggingANDPublishing.pch"
#define kMAX_SHEET_TABLE_HEIGHT   400
#define SELECT_BACK_COLOR     [UIColor colorWithRed:95.0/255 green:155.0/255 blue:255.0/255 alpha:1.0f]
#define SWITCH_START_TAG        10003
#define SWITCH_END_TAG          10004

@interface SGTimePick ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    enum ActionSheetType sheetType;
    UIButton *confirmBtn;
    UIButton *cancelBtn;
    NSDate *selectTime;
    UIDatePicker *_dataPick;
    UIPickerView *durationPick;
    int mininueindex,hourindex;
    NSString *selectedItem;
    NSString *selectedIndexStr;

}

@end

@implementation SGTimePick
@synthesize dataArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,216, ScreenWidth/2 - 10, 30)];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:SELECT_BACK_COLOR forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmBtn];
        
        
        cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2+10,216, ScreenWidth/2 - 10, 30)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setBackgroundColor:[UIColor clearColor]];
        cancelBtn.userInteractionEnabled = YES;
        [cancelBtn setTitleColor:SELECT_BACK_COLOR forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(touchCancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];

    }
    return self;
}

- (id)initWithTitle:(NSString *)title type:(ActionSheetType)currentType starTime:(NSDate *)starTimeDate withIndex:(NSString *)indexStr

{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self setupWithTitle:title type:currentType startTime:starTimeDate withIndex:indexStr];
    }
    return self;
}

- (void)setupWithTitle:(NSString *)title type:(ActionSheetType)currentType startTime:(NSDate*)startDate withIndex:(NSString*)indexStr
{
    sheetType =currentType;
    selectTime = startDate?startDate:[NSDate date];
    selectedIndexStr = indexStr;
    if (sheetType == ActionSheetTimeDate_Picker)
    {
        _dataPick = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 216)];
        _dataPick.backgroundColor = [UIColor whiteColor];
        [_dataPick setDate:[NSDate date]];
        
        [self addSubview:_dataPick];
        _dataPick.datePickerMode = UIDatePickerModeDateAndTime;
        [_dataPick setDate:selectTime];
    }
    else if (sheetType == ActionSheetDate_Picker)
    {
        _dataPick = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 216)];
        _dataPick.backgroundColor = [UIColor whiteColor];
        [_dataPick setDate:[NSDate date]];
        
        [self addSubview:_dataPick];
        _dataPick.datePickerMode = UIDatePickerModeDate;
        [_dataPick setDate:selectTime];
    }
    else if(sheetType == ActionSheetTime_Picker)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *dateStr = [dateFormatter stringFromDate:startDate];
        
        NSArray *array = [dateStr componentsSeparatedByString:@":"];
        
        hourindex = [[NSString stringWithFormat:@"%02d",[[array objectAtIndex:0] integerValue]] integerValue];
        mininueindex = [[NSString stringWithFormat:@"%02d",[[array objectAtIndex:1] integerValue]] integerValue];
        
        durationPick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 216)];
        durationPick.delegate = self;
        durationPick.dataSource = self;
        durationPick.backgroundColor = [UIColor whiteColor];
        durationPick.showsSelectionIndicator = YES;
        NSInteger max = 16384;
        NSInteger base1 = (max/2)-(max/2)%24 +hourindex;
        NSInteger base2 = (max/2)-(max/2)%60 +mininueindex;
        [durationPick selectRow:base1 inComponent:0 animated:NO];
        [durationPick selectRow:base2 inComponent:1 animated:NO];

        UILabel *hourlabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 -60 , durationPick.center.y -20 , 60, 40)];
        //    hourlabel.center = durationPick.center;
        hourlabel.backgroundColor = [UIColor clearColor];
        hourlabel.text = @"时";
        [durationPick addSubview:hourlabel];
        
        
        UILabel *minutelabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 +80, durationPick.center.y -20, 80, 40)];
        //    minutelabel.center = durationPick.center;
        minutelabel.backgroundColor = [UIColor clearColor];
        minutelabel.text = @"分";
        [durationPick addSubview:minutelabel];
        
        [self addSubview:durationPick];
    }else
    {

        durationPick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 216)];
        durationPick.delegate = self;
        durationPick.dataSource = self;
        durationPick.backgroundColor = [UIColor whiteColor];
        durationPick.showsSelectionIndicator = YES;
        
        [self addSubview:durationPick];
        
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component

{
    
    if (sheetType == ActionSheetOther_Picker) {
         return self.frame.size.width;
    }else if (sheetType == ActionSheetOtherTowRow_Picker || sheetType == ActionSheetCity_Picker)
    {
        return self.frame.size.width/2;
    }
    CGFloat componentWidth = 0.0;
    
    
    if (component == 0)
        
        componentWidth = 90.0; // 第一个组键的宽度
    
    else
        
        componentWidth =170.0; // 第2个组键的宽度
    
//    if (!isIos7)
//    {
//        componentWidth = 130;
//    }
    
    return componentWidth;
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (sheetType == ActionSheetOther_Picker) {
        return 1;
    }
    return 2;
}
-(void)timePickerValueChanged
{
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float height = 256 ;
    self.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, height)};
    if (selectedIndexStr) {
        
        if (sheetType == ActionSheetOther_Picker) {
            [durationPick selectRow:[selectedIndexStr integerValue] inComponent:0 animated:NO];
        }else if (sheetType == ActionSheetCity_Picker)
        {
            if ([selectedIndexStr containsString:@","]) {
                NSDictionary *dic = dataArray[[[[selectedIndexStr componentsSeparatedByString:@","] objectAtIndex:0] integerValue]];
                subDataArray = dic[@"cities"];
                
                [durationPick selectRow:[[[selectedIndexStr componentsSeparatedByString:@","] objectAtIndex:0] integerValue] inComponent:0 animated:NO];
                [durationPick selectRow:[[[selectedIndexStr componentsSeparatedByString:@","] objectAtIndex:1] integerValue] inComponent:1 animated:NO];
            }
        }
        
        if ([selectedIndexStr isEqualToString:@"0"] || [selectedIndexStr isEqualToString:@"0,0"]) {
            if ([self.dataArray count]>0) {
                if (sheetType == ActionSheetOther_Picker) {
                    
                    selectedItem = [self.dataArray objectAtIndex:0];
                    
                }else if (sheetType == ActionSheetOtherTowRow_Picker)
                {
                    
//                    CategoryModel *categoryMo = self.dataArray[0];
//                    selectedItem = categoryMo.CategoruName;
                    
                }else if (sheetType == ActionSheetCity_Picker)
                {
                    NSDictionary *dic = dataArray[0];
                    //3.取得城市列表
                    subDataArray = dic[@"cities"];
                    NSString *state = dic[@"state"];
                    NSString *cityName = subDataArray[0];
                    selectedItem = [NSString stringWithFormat:@"%@,%@",state,cityName];
                }
                
            }
            
        }
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (sheetType == ActionSheetOther_Picker) {
        return [self.dataArray count];
    }else if (sheetType == ActionSheetOtherTowRow_Picker)
    {
//        if (component == 0) {
//            return [self.dataArray count];
//        }else
//        {
//            if (!subDataArray) {
//                CategoryModel *categoryMo = self.dataArray[0];
//                subDataArray = categoryMo.SubCategoryArray;
//            }
//            return [subDataArray count];
//        }
    }else if (sheetType == ActionSheetCity_Picker)
    {
        if (component == 0) {
            return self.dataArray.count;
        }else
        {
            if (!subDataArray) {
                NSDictionary *dic = dataArray[[[[selectedIndexStr componentsSeparatedByString:@","] objectAtIndex:0] integerValue]];
                subDataArray = dic[@"cities"];
            }
            return [subDataArray count];
        }
    }
    
    return 16384;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (sheetType == ActionSheetOther_Picker) {
        return [self.dataArray objectAtIndex:row];
    }else if (sheetType == ActionSheetOtherTowRow_Picker)
    {
//        if (component == 0) {
//            CategoryModel *categoryMo = self.dataArray[row];
//            return categoryMo.CategoruName;
//        }else{
//            
//            CategoryModel *subCategoryMo = subDataArray[row];
//            return subCategoryMo.CategoruName;
//        }
    }else if (sheetType == ActionSheetCity_Picker)
    {
        if (component==0) {
            NSDictionary *Dic = dataArray[row];
            NSString *state = Dic[@"state"];
            return state;
        }else
        {
            NSString *city = subDataArray[row];
            return city;
        }
    }
    
    switch (component) {
        case 0:
            
            return [NSString stringWithFormat:@"%ld",(long)(row%24)];
        case 1:
            return [NSString stringWithFormat:@"%02ld",(long)(row%60)];
            
        default:
            return 0;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //    NSString *str = [NSString stringWithFormat:@"%02d:%02d",];
    
    if (sheetType == ActionSheetOther_Picker) {
        selectedItem = [self.dataArray objectAtIndex:row];
        return;
    }else if (sheetType == ActionSheetOtherTowRow_Picker)
    {
//        if (component == 0) {
//            
//            CategoryModel *categoryMo = self.dataArray[row];
//            selectedItem = categoryMo.CategoruName;
//            subDataArray = categoryMo.SubCategoryArray;
//            [pickerView reloadComponent:1];
//            [pickerView selectRow:0 inComponent:1 animated:YES];
//            
//        }else
//        {
//            CategoryModel *subCategoryMo = subDataArray[row];
//            selectedItem = subCategoryMo.CategoruName;
//        }
    }else if (sheetType == ActionSheetCity_Picker)
    {
        if (component == 0) {

            NSDictionary *dic = dataArray[row];
            
            //3.取得城市列表
            subDataArray = dic[@"cities"];
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            
            NSDictionary *Dic = dataArray[row];
            NSString *state = Dic[@"state"];
            
            NSString *cityName = subDataArray[0];
            selectedItem = [NSString stringWithFormat:@"%@,%@",state,cityName];
        }else if (component == 1){

            NSDictionary *Dic = dataArray[[pickerView selectedRowInComponent:0]];
            NSString *state = Dic[@"state"];
            //4.取得城市名字
            NSString *cityName = subDataArray[row];
            selectedItem = [NSString stringWithFormat:@"%@,%@",state,cityName];
        }
    }
    if (component == 0)
    {
        hourindex = row;
    }
    else
    {
        mininueindex = row;
    }
    
    
    //   self.actionSheetHandle( [NSString stringWithFormat:@"%02d:%02d",hourindex%24,mininueindex%60]);
}


#pragma mark - 

- (void)triggerSelectedAction:(void (^)(NSDate *startTime,NSString *selectedItem))actionHandle
{
    self.actionHandle = actionHandle;

}

#pragma mark -

-(void)confirm
{
    if (sheetType == ActionSheetTime_Picker) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        
        NSString *dateStr = [NSString stringWithFormat:@"%02d:%02d",hourindex%24,mininueindex%60];
        NSDate *myDate = [dateFormatter dateFromString:dateStr];
        self.actionHandle(myDate,nil);
    }else if (sheetType == ActionSheetOther_Picker || sheetType == ActionSheetOtherTowRow_Picker || sheetType == ActionSheetCity_Picker)
    {
        self.actionHandle(nil,selectedItem);
    }
    else
    {
        self.actionHandle([_dataPick date],nil);
    }
}

-(void)touchCancel
{
    self.actionHandle(nil,nil);
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.actionHandle) {
//        double delayInSeconds = 0.15;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            self.actionHandle(indexPath.row);
//        });
//    }
//}

@end
