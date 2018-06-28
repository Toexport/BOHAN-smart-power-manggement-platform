//
//  WifiView.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/10.
//  Copyright © 2018年 Bohan. All rights reserved.
//
typedef void(^AddBlock)(NSString *ssid, NSString *pwd);

#import <UIKit/UIKit.h>
#import "EdgetTextField.h"

@interface WifiView : UIView
{
    __weak IBOutlet UILabel *steps;
    
}
@property (nonatomic, copy) AddBlock addBock;
@property (weak, nonatomic) IBOutlet EdgetTextField *ssidTF;
@property (weak, nonatomic) IBOutlet EdgetTextField *pwdTF;

@end
