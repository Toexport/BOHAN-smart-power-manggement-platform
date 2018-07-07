//
//  WebViewController.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/5.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController

//@property (nonatomic, copy) NSString *url;
//@property (nonatomic, copy) NSString *titleStr;

- (instancetype)initWithTitle:(NSString *)name urlStr:(NSString *)url;
@end
