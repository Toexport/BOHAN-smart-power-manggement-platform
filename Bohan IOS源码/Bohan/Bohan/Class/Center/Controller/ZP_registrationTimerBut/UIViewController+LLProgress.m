//
//  UIViewController+LLProgress.m
//  FrameworkTest
//
//  Created by APPLE on 2017/9/7.
//  Copyright © 2017年 com.icue. All rights reserved.
//

#import "UIViewController+LLProgress.h"

#define MBPROGRESSHUD_TAG 9999999
#define PROGRESS_OPACITY 0.6   //透明度
#define MAX_TIME 65535

#define LOADING_TAG 500

@implementation UIViewController (LLProgress)

- (void)addNavigationBarItemWithType:(LLNavigationBarItemType)itemType
                             handler:(void (^)(UIButton *))handler {
    
    UIButton *button = [self getButtonWithType:itemType];
    if (handler) {
        handler(button);
    }
    [button sizeToFit];
    CGRect frame = button.frame;
    frame.size.width += frame.size.width +2;
}

- (UIButton *)getButtonWithType:(LLNavigationBarItemType)itemType {
    if (itemType == LLNavigationBarItemTypeLeftFirst) {
        
        UIBarButtonItem *item = [self leftFirstBarButton];
        return item.customView;
    }else if (itemType == LLNavigationBarItemTypeLeftSecond) {
        
        UIBarButtonItem *item = [self leftSecondBarButton];
        return item.customView;
    }else if (itemType == LLNavigationBarItemTypeRightFirst) {
        
        UIBarButtonItem *item = [self rightFirstBarButton];
        return item.customView;
    }else if (itemType == LLNavigationBarItemTypeRightSecond) {
        
        UIBarButtonItem *item = [self rightSecondBarButton];
        return item.customView;
    }else if (itemType == LLNavigationBarItemTypeRightThird) {
        
        UIBarButtonItem *item = [self rightThirdBarButton];
        return item.customView;
    }
    
    return nil;
}

//左邊第一個UIBarButtonItem
- (UIBarButtonItem *)leftFirstBarButton {
    
    NSArray *array = self.navigationItem.leftBarButtonItems;
    UIBarButtonItem *item = [self findBarButtonItemInArray:array tag:1];
    if (!item) {
        
        item = [self creteBarButtonItem];
        item.tag = 1;
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];;
        [newArray insertObject:item atIndex:0];
        self.navigationItem.leftBarButtonItems = newArray;
    }
    return item;
}

//左邊第二個UIBarButtonItem
- (UIBarButtonItem *)leftSecondBarButton {

    NSArray *array = self.navigationItem.leftBarButtonItems;
    UIBarButtonItem *item = [self findBarButtonItemInArray:array tag:2];
    if (!item) {
        
        item = [self creteBarButtonItem];
        item.tag = 2;
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];;
        [newArray addObject:item];
        self.navigationItem.leftBarButtonItems = newArray;
    }
    return item;
}

//右邊第一個UIBarButtonItem
- (UIBarButtonItem *)rightFirstBarButton {
    
    NSArray *array = self.navigationItem.rightBarButtonItems;
    UIBarButtonItem *item = [self findBarButtonItemInArray:array tag:1];
    if (!item) {
        
        item = [self creteBarButtonItem];
        item.tag = 1;
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];
        
//        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [newArray insertObject:item atIndex:0];
        self.navigationItem.rightBarButtonItems = newArray;
    }
    return item;
}

//右邊第二個UIBarButtonItem
- (UIBarButtonItem *)rightSecondBarButton {
    
    NSArray *array = self.navigationItem.rightBarButtonItems;
    UIBarButtonItem *item = [self findBarButtonItemInArray:array tag:2];
    if (!item) {
        
        item = [self creteBarButtonItem];
        item.tag = 2;
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];;
        if (newArray.count == 2) {
            
            [newArray insertObject:item atIndex:1];
        }else {
            
            [newArray addObject:item];
        }
        self.navigationItem.rightBarButtonItems = newArray;
    }
    return item;
}

- (UIBarButtonItem *)rightThirdBarButton {
    
    NSArray *array = self.navigationItem.rightBarButtonItems;
    UIBarButtonItem *item = [self findBarButtonItemInArray:array tag:3];
    if (!item) {
        
        item = [self creteBarButtonItem];
        item.tag = 3;
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];;
        [newArray addObject:item];
        self.navigationItem.rightBarButtonItems = newArray;
    }
    return item;
}

//創建UIBarButtonItem
- (UIBarButtonItem *)creteBarButtonItem {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

//根據tag 查找UIBarButtonItem
- (UIBarButtonItem *)findBarButtonItemInArray:(NSArray *)array tag:(NSInteger)tag {
    
    if (array.count == 0) {
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tag = %d",tag];
    NSArray *filterArray = [array filteredArrayUsingPredicate:predicate];
    return filterArray.firstObject;
}

- (UIFont *) getTitltFont {
    
    return [UIFont systemFontOfSize:16];
}


@end
