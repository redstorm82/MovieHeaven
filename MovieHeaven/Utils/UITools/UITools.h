//
//  UITools.h
//  QRTProject
//
//  Created by 石文文 on 2017/10/19.
//  Copyright © 2017年 aohuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BlockButton.h"
#import <MJRefresh.h>
#pragma mark - <ImageTool>

@interface ImageTool : NSObject

/**创建单色image图片*/
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;

//返回特定尺寸的UImage  ,  image参数为原图片，size为要设定的图片大小
/**压缩图片，会失真的压缩，简单的裁剪*/
+ (UIImage*)resizeImageToSize:(CGSize)size image:(UIImage*)image;

/**返回指定view生成的图片*/
+ (UIImage *)imageFromView:(UIView *)view;

/**返回指定视图中指定范围生成的image图片*/
+ (UIImage *)imageFromView:(UIView *)view inRect:(CGRect)rect;

/**把图片写入到手机相册*/
+ (void)writeImageToSavedPhotosAlbum:(UIImage *)image;

@end


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

@interface UITool : NSObject

/**
 MJRefreshGifHeader

 @param refreshingBlock refreshingBlock
 @return MJRefreshGifHeader
 */
+ (MJRefreshGifHeader *)MJRefreshGifHeaderWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;

@end
