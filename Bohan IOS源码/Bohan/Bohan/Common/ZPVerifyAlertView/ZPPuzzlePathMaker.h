//
//  ZPPuzzlePathMaker.h
//  Bohan
//
//  Created by summer on 2018/12/3.
//  Copyright © 2018 Bohan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ZPPuzzlePathMaker;

typedef NS_ENUM(NSInteger, ZPPathMirrorAxis) {
    ZKPathMirrorAxisX,  // x 轴镜像
    ZKPathMirrorAxisY   // y 轴镜像
};

@interface ZPPuzzlePathMaker : NSObject

/** 原始路径 */
@property (nonatomic, strong) UIBezierPath *path;

/** 移动画笔至点 */
@property (nonatomic, copy) ZPPuzzlePathMaker *(^moveTo)(CGFloat x, CGFloat y);
/** 添加直线 */
@property (nonatomic, copy) ZPPuzzlePathMaker *(^addLineTo)(CGFloat x, CGFloat y);
/** 添加一次贝塞尔曲线 */
@property (nonatomic, copy) ZPPuzzlePathMaker *(^addQuadCurveTo)(CGFloat endX, CGFloat endY, CGFloat controlX, CGFloat controlY);
/** 添加二次贝塞尔曲线 */
@property (nonatomic, copy) ZPPuzzlePathMaker *(^addCurveTo)(CGFloat endX, CGFloat endY, CGFloat controlX1, CGFloat controlY1, CGFloat controlX2, CGFloat controlY2);
/** 添加弧线 */
@property (nonatomic, copy) ZPPuzzlePathMaker *(^addArcWithCenter)(CGFloat centerX, CGFloat centerY, CGFloat radius, CGFloat startAngle, CGFloat endAngle, BOOL clockwise);
@property (nonatomic, copy) ZPPuzzlePathMaker *(^addArcWithPoint)(CGFloat startX, CGFloat startY, CGFloat endX, CGFloat endY, CGFloat radius, BOOL clockwise, BOOL moreThanHalf);
/** 闭合曲线 */
@property (nonatomic, copy) ZPPuzzlePathMaker *(^closePath)(void);
/**
 添加正弦曲线
 
 @param A 振幅
 @param Omega 角速度
 @param Phi 相位差
 @param K 偏移量
 @param deltaX 曲线横向长度
 */
@property (nonatomic, copy) ZPPuzzlePathMaker *(^addSin)(CGFloat A, CGFloat Omega, CGFloat Phi, CGFloat K, CGFloat deltaX);
/** 镜像曲线 */
@property (nonatomic, copy) ZPPuzzlePathMaker *(^mirror)(ZPPathMirrorAxis axis, CGFloat x, CGFloat y, CGFloat width, CGFloat height);
/** 保证图形区域中心不变以比例形式缩放路径 */
@property (nonatomic, copy) ZPPuzzlePathMaker *(^scale)(CGFloat scale);
/** 保证图形区域中心不变以角度旋转路径 */
@property (nonatomic, copy) ZPPuzzlePathMaker *(^rotate)(CGFloat angle);
/** 平移路径 */
@property (nonatomic, copy) ZPPuzzlePathMaker *(^translate)(CGFloat offsetX, CGFloat offsetY);
/** 移动路径至原点 */
@property (nonatomic ,copy) ZPPuzzlePathMaker *(^moveToOrigin)(void);

/** 快捷初始化 */
- (instancetype)initWithBezierPath:(UIBezierPath *)path NS_DESIGNATED_INITIALIZER;
+ (instancetype)makerWithBezierPath:(UIBezierPath *)path;

@end

NS_ASSUME_NONNULL_END
