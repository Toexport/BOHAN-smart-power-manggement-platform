//
//  CenterViewController.m
//  Bohan
//
//  Created by Yang Lin on 2017/12/24.
//  Copyright © 2017年 Bohan. All rights reserved.
//

#import "CenterViewController.h"
#import "WebViewController.h"
#import "FeedbackViewController.h"
#import "UIButton+EdgeInsets.h"
#import "NSBundle+AppLanguageSwitch.h"

//#import "UIImageView+WebCache.h"
@interface CenterViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    NSString *userImg;
    UIImageView *headerImg;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *footerBtn;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic, strong) UILabel * detailTextLabel; //电话

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"个人中心");
    self.hidesBottomBarWhenPushed = NO;
    if (@available(iOS 11.0, *)){
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:AppLanguageDidChangeNotification object:nil];

    headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    headerImg.image = [UIImage imageNamed:@"mini_avatar"];
    headerImg.layer.cornerRadius = 22;
    headerImg.layer.masksToBounds = YES;
    [headerImg setBackgroundColor:[UIColor getColor:@"eeeeee"]];
    
    [self.view addSubview:self.tableView];
    
}


- (void)languageChange {
//    [super languageChange];
    _data = nil;
    self.title = Localize(@"个人中心");
    [self.tableView reloadData];
    [_footerBtn setTitle:Localize(@"注销登录") forState:UIControlStateNormal];

}

- (void)logoutAction:(UIButton *)sender {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message: NSLocalizedString(@"确定要注销登录吗?", nil)preferredStyle:UIAlertControllerStyleActionSheet];
    //  设置popover指向的item
    alert.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItem;
    //  確定按钮
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)  style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUTNOTIFICATION object:nil];
        //        清除所有的数据
        
        NSLog(@"点击了确定按钮");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消按钮");
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    
    [_data setArray:@[@{@"item":USERNAME,@"image":@"small_user"}, @{@"item":Localize(@"操作指南"),@"image":@"small_info"},@{@"item":Localize(@"意见与反馈"),@"image":@"ic_launcher363"}, @{@"item":Localize(@"版本信息"),@"image":@"ic_launcher"}, @{@"item":Localize(@"客服电话"),@"image":@"phone"},@{@"item":Localize(@"语言设置"),@"image":@"small_version"}]];

    return _data;
}


-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight+5, ScreenWidth, ScreenHeight- (kNavBarHeight+5)) style:UITableViewStyleGrouped];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setTableFooterView:self.footerBtn];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)footerBtn
{
    if (!_footerBtn) {
        _footerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
        [_footerBtn setBackgroundColor:[UIColor getColor:@"c0b9ca"]];
        [_footerBtn setImage:[UIImage imageNamed:@"ic_launcher789"] forState:UIControlStateNormal];
        [_footerBtn addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerBtn setTitle:Localize(@"注销登录") forState:UIControlStateNormal];
        _footerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);
        _footerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 180, 0, 0);
    }

    return _footerBtn;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentify = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentify];
    }
    NSDictionary *dict_ = self.data[indexPath.row];
    cell.textLabel.text = dict_[@"item"];
    cell.textLabel.textColor = kTextColor;
    cell.textLabel.font = Font(15);
    cell.detailTextLabel.font = Font(15);
    cell.selectionStyle = UITableViewCellSelectionStyleNone; // 取消Cell变灰效果
    cell.imageView.image = [UIImage imageNamed:dict_[@"image"]];
    
    if (indexPath.row == 0) {
        cell.accessoryView = headerImg;
        
    }else if(indexPath.row == 3 || indexPath.row == 4)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (indexPath.row == 3) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@V%@",Localize(@"当前版本"),CURRENTSHORTVERSION];
        }else
        {
            self.detailTextLabel = cell.detailTextLabel;
            self.detailTextLabel.text = @"0769-22890660";
            //     1. 创建一个点击事件，点击时触发labelClick方法
            UITapGestureRecognizer * TapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnLabel:)];
            // 2. 将点击事件添加到label上
            [cell.detailTextLabel addGestureRecognizer:TapGestureRecognizer1];
            cell.detailTextLabel.userInteractionEnabled = YES; // 可以理解为设置label可被点击
            self.detailTextLabel = cell.detailTextLabel;
            
        }

    }else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 60;
    }
    return 45;
}

// 3. 在此方法中设置点击label后要触发的操作
- (void)handleTapOnLabel:(id)sender {
    NSString * ph1 = @"lte";
    ph1 = [ph1 stringByAppendingString:self.detailTextLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ph1]];
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.001;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        NSString *language = [df objectForKey:@"App_Language_Switch_Key"];
        
//        NSString *localeLanguageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
        NSString *localeLanguageCode = [NSLocale preferredLanguages][0];
        localeLanguageCode = [[localeLanguageCode componentsSeparatedByString:@"-"] firstObject];

        NSString *urlStr = @"http://www.bohanserver.top:8088/APPHelp_en.html";

        if ((language && [language isEqualToString:@"zh-Hans"]) || (!language && [localeLanguageCode isEqualToString:@"zh"])) {
            urlStr = @"http://www.bohanserver.top:8088/APPHelp.html";
        }
        
        WebViewController *help = [[WebViewController alloc] initWithTitle:Localize(@"操作指南") urlStr:urlStr];
        help.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:help animated:YES];
    }else if (indexPath.row == 2)
    {
        FeedbackViewController *feedback = [[FeedbackViewController alloc] init];
        feedback.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:feedback animated:YES];
    }else if (indexPath.row == 5)
    {
        UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:Localize(@"语言选择") message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *chinessAction = [UIAlertAction actionWithTitle:Localize(@"中文") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [NSBundle setCusLanguage:@"zh-Hans"];
        }];
        UIAlertAction *englishAction = [UIAlertAction actionWithTitle:Localize(@"英文") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [NSBundle setCusLanguage:@"en"];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localize(@"取消") style:UIAlertActionStyleCancel handler:nil];
        [actionSheetController addAction:chinessAction];
        [actionSheetController addAction:englishAction];
        [actionSheetController addAction:cancelAction];
        
        [self presentViewController:actionSheetController animated:YES completion:nil];
    }
}


@end
