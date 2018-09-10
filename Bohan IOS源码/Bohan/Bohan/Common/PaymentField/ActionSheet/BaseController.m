//
//  BaseController.m
//  Bohan
//
//  Created by summer on 2018/9/10.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()

@end

@implementation BaseController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = UIColor.whiteColor;
    self.view = view;
    
    // The label that shows info.
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 150, ScreenWidth-30, 50)];
    self.infoLabel.textColor = UIColor.blackColor;
    self.infoLabel.numberOfLines = 0;
    [self.view addSubview:self.infoLabel];
    
    // clear button
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clearButton.frame = CGRectMake(15, 200, ScreenWidth-30, 50);
    self.clearButton.backgroundColor = UIColor.blueColor;
    [self.clearButton setTitle:@"clear" forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clearButton];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)clearButtonClicked:(UIButton *)button
{
    [self.securityField clear];
}

@end
