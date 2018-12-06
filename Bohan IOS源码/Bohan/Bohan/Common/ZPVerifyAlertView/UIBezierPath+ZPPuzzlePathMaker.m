//
//  UIBezierPath+ZPPuzzlePathMaker.m
//  Bohan
//
//  Created by summer on 2018/12/3.
//  Copyright © 2018 Bohan. All rights reserved.
//

#import "UIBezierPath+ZPPuzzlePathMaker.h"
#import "ZPPuzzlePathMaker.h"
@implementation UIBezierPath (ZPPuzzlePathMaker)

+ (instancetype)bezierPathWithPathMaker:(void(^)(ZPPuzzlePathMaker *maker))maker {
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (maker) {
        ZPPuzzlePathMaker *pathMaker = [[ZPPuzzlePathMaker alloc] initWithBezierPath:path];
        maker(pathMaker);
    }
    return path;
}
@end
