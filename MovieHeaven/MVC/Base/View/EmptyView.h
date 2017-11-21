//
//  EmptyView.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/3.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseView.h"
#define EmptyDefaultTip @"数据跑路了，点击重新加载(つ•̀ω•́)つ"
#define EmptyLoadingTip @"数据加载中~~~~"

@interface EmptyView : BaseView

/**
 空占位图

 @param frame 大小
 @param icon 图标
 @param tip 提示
 @param tapBlock 点击回调
 @return 占位图
 */
-(instancetype _Nonnull)initWithFrame:(CGRect)frame icon:(NSString * _Nullable)icon tip:(NSString * _Nullable)tip tapBlock:(void(^ _Nullable)(void))tapBlock;
@property (nonatomic,copy,nullable)void(^tapBlock)(void) ;
@property (nonatomic,copy,nullable)NSString * icon;
@property (nonatomic,copy,nullable)NSString * tip;
@end
