//
//  UIBezierPath+ZPPuzzlePathMaker.h
//  Bohan
//
//  Created by summer on 2018/12/3.
//  Copyright © 2018 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPPuzzlePathMaker.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (ZPPuzzlePathMaker)

+ (instancetype)bezierPathWithPathMaker:(void(^)(ZPPuzzlePathMaker *maker))maker;
@end

NS_ASSUME_NONNULL_END
