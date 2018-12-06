//
//  LanguageController.m
//  Bohan
//
//  Created by summer on 2018/7/11.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "LanguageController.h"
#import "NSBundle+Language.h"
#import "DebuggingANDPublishing.pch"
//#import "UIViewController+NavigationBar.h"
#import "CALayer+UIColor.h"
#import "UIViewController+LLProgress.h"
#import "UIButton+countDown.h"
@interface LanguageController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray * TitleArray;
@property (nonatomic, assign) BOOL noNeed;

@end

@implementation LanguageController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBar];
    [self initUI];
    //  数据持久化
    NSString * la = [[NSUserDefaults standardUserDefaults] objectForKey:@"Language"];
    NSIndexPath * index ;
    if ([la isEqualToString:@"zh-Hans"]) {
        index = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableview cellForRowAtIndexPath:index].accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(adjustStatusBar:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

// UI
- (void)initUI {
    self.title = NSLocalizedString(@"Language", nil);
    [self.tableview registerNib:[UINib nibWithNibName:@"LanguangTableViewCell" bundle:nil] forCellReuseIdentifier:@"LanguangTableViewCell"];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [[UIView alloc]init]; // 隱藏tableviewcell多余的線條
    self.TitleArray = [NSArray arrayWithObjects:@"English",@"简体中文", nil];
}

// NavigationBar按钮
- (void)addNavigationBar {
    __weak LanguageController  * Language = self;
    [self addNavigationBarItemWithType:LLNavigationBarItemTypeRightFirst handler:^(UIButton * button) {
        [button setTitle:NSLocalizedString(@"Complete", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:Language action:@selector(CompleteBut:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

// 完成按钮
- (void)CompleteBut:(UIButton *)sender {
    int a = 0;
    for (int i = 0; i < self.TitleArray.count; i ++ ) {
        UITableViewCell * cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.accessoryType  == 3) {
            a = i+1;
        }
    }
    if (a == 0) {
        return;
    }
    switch (a) {
        case 1:
            [self changeLanguageTo:@"en"];
            break;
        case 2:
            [self changeLanguageTo:@"zh-Hans"];
            break;
        default:
            break;
    }
}

// 语言设置
- (void)changeLanguageTo:(NSString *)language {
    //  设置语言
    [NSBundle setLanguage:language];
    //  然后将设置好的语言存储好，下次进来直接加载
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:@"Language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

//适当的位置移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- UItableviewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.TitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"ssss";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (!self.noNeed) {
        NSString * la = [[NSUserDefaults standardUserDefaults] objectForKey:@"Language"];
        if ([la isEqualToString:@"zh-Hans"] && indexPath.row == 0) {
            self.noNeed = YES;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else if ([la isEqualToString:@"en"] && indexPath.row == 1){
            self.noNeed = YES;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    cell.textLabel.text = self.TitleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //这里写你的选中颜色
    for (UITableViewCell *cell in tableView.visibleCells) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    return indexPath;
}

// 热点被接入，子类重写
- (void)adjustStatusBar:(NSNotification *)notification {
    NSValue * rectValue = [notification.userInfo objectForKey:UIApplicationStatusBarFrameUserInfoKey];
    CGRect statusRect = [rectValue CGRectValue];
    CGFloat height = statusRect.size.height;
    if (height > 20) {
        appD.window.frame = CGRectMake(0, 0, ZP_Width, ZP_height);
    }else{
        appD.window.frame = CGRectMake(0, 0, ZP_Width, ZP_height);
    }
}


@end
