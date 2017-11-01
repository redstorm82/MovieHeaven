//
//  UITools.h
//  QRTProject
//
//  Created by 石文文 on 2017/10/19.
//  Copyright © 2017年 aohuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BlockButton.h"
#pragma mark - <LabelTool>
@interface LabelTool : NSObject

/**
 *  创建lable，设置标题颜色（颜色为nil时，为黑色） 文本字体大小
 *
 *  @param frame     frame description
 *  @param textColor textColor description
 *  @param size      size description
 *
 *  @return lable
 */
+ (UILabel *)createLableWithFrame:(CGRect)frame textColor:(UIColor *)textColor textFontOfSize:(CGFloat)size;


/**
 创建lable，设置标题颜色（颜色为nil时，为黑色） 文本字体大小
 
 @param frame frame
 @param textColor textColor
 @param font font
 @return return a label
 */
+ (UILabel *)createLableWithFrame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font;


+ (UILabel *)createLableWithTextColor:(UIColor *)textColor textFontOfSize:(CGFloat)size;
+ (UILabel *)createLableWithTextColor:(UIColor *)textColor font:(UIFont *)font;

@end
#pragma mark - <ButtonTool>
@interface ButtonTool : NSObject
+ (UIButton *)createButtonWithImageName:(NSString *)imageName
                              addTarget:(id)target
                                 action:(SEL)action;
+ (BlockButton *)createButtonWithImageName:(NSString *)imageName
                                     block:(void(^)(UIButton *button))block;

+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName
                                addTarget:(id)target
                                   action:(SEL)action;

+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName
                                addTarget:(id)target
                                   action:(SEL)action
                                    title:(NSString *)title
                               titleColor:(UIColor *)titleColor
                              isSizeToFit:(BOOL)isSizeToFit;

/**根据传入的图片大小生成一个Button*/
+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName
                                addTarget:(id)target
                                   action:(SEL)action
                                    title:(NSString *)title
                               titleColor:(UIColor *)titleColor;

/**根据传入的图片大小生成一个Button, 并添加到父视图上*/
+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName
                                addTarget:(id)target
                                   action:(SEL)action
                                    title:(NSString *)title
                               titleColor:(UIColor *)titleColor
                                superView:(UIView *)superView;

+ (UIButton *)createButtonWithTitle:(NSString *)title
                         titleColor:(UIColor *)titleColor
                          titleFont:(UIFont *)font
                          addTarget:(id)target
                             action:(SEL)action;

+ (BlockButton *)createBlockButtonWithTitle:(NSString *)title
                                 titleColor:(UIColor *)titleColor
                                  titleFont:(UIFont *)font
                                      block:(void(^)(UIButton *button))block;

+ (void)addTarget:(id)target
           action:(SEL)action
         onButton:(UIButton *)btn;

+ (UIButton *)createButtonWithBGNormalImageName:(NSString *)bgImageName
                                 hightImageName:(NSString *)hightImageName
                                      addTarget:(id)target
                                         action:(SEL)action
                                    isSizeToFit:(BOOL)isSizeToFit;

+ (void)setTitle:(NSString *)title
           color:(UIColor *)color
            font:(NSInteger)fontSize
        onButton:(UIButton *)btn;
/*
 改变按钮
 */
//设置按钮圆角
+ (void)setBtnCorner:(UIButton *)btn;

@end
