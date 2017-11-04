//
//  AlertView.h
//  BBPartTimeJob
//
//  Created by 石文文 on 2017/7/7.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseView.h"
#import "SourceTypeModel.h"
typedef void(^ClickBlock)(NSInteger index);

@interface AlertView : BaseView

/**
 
 单按钮弹框
 @param text 内容 字符串或者属性字符串
 @param buttonTitle 按钮标题
 @param clickBlock 按钮事件
 @return 弹框
 */
-(nonnull instancetype)initWithText:(nullable id)text buttonTitle:(nullable NSString *)buttonTitle clickBlock:(nullable ClickBlock)clickBlock;
/**
 双按钮弹框

 @param text 内容
 @param cancelTitle 取消标题 默认 取消
 @param sureTitle 确认标题 默认 确认
 @param cancelBlock 取消按钮回调事件
 @param sureBlock 确认按钮回调事件
 @return 弹框
 */
-(nonnull instancetype)initWithText:(nullable NSString *)text cancelTitle:(nullable NSString *)cancelTitle sureTitle:(nullable NSString *)sureTitle cancelBlock:(nullable ClickBlock)cancelBlock sureBlock:(nullable ClickBlock)sureBlock;


/**
 列表选择弹框

 @param title 标题
 @param items 选项
 @param cancelTitle 取消标题
 @param sureTitle 确认标题
 @param cancelBlock 取消回调
 @param sureBlock 确认回调
 @return 弹框
 */
-(nonnull instancetype)initWithTitle:(nullable NSString *)title items:(nonnull NSArray<SourceTypeModel *>*)items cancelTitle:(nullable NSString *)cancelTitle sureTitle:(nullable NSString *)sureTitle cancelBlock:(nullable ClickBlock)cancelBlock sureBlock:(nullable ClickBlock)sureBlock;

/**
 显示
 */
- (void)show;
@property(nonatomic,assign)NSInteger selectedIndex;

@end
