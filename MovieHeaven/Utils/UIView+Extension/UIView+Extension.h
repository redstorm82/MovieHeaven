//
//  UIView+Extension.h
//  HaoWeibo
//
//  Created by 张仁昊 on 16/3/9.
//  Copyright © 2016年 张仁昊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)


@property(nonatomic,assign)CGFloat x;
@property(nonatomic,assign)CGFloat y;
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,assign)CGSize size;
@property(nonatomic,assign)CGPoint origin;

@property(nonatomic,assign)CGFloat centerX;
@property(nonatomic,assign)CGFloat centerY;

@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;

/**
 设置圆角

 @param cornerRadius 圆角大小
 */
-(void)setCornerRadius:(CGFloat)cornerRadius;

/**
 设置不同方向圆角
 
 @param cornerRadius 圆角大小
 @param rectCorner 圆角方向
 */
-(void)setCornerRadius:(CGFloat)cornerRadius rectCorner:(UIRectCorner )rectCorner;

@end
