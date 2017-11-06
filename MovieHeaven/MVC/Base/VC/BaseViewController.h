//
//  BaseViewController.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/1.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    backArrow= 1,//返回箭头
    noArrow,//无返回箭头
} ArrowType;

@interface BaseViewController : UIViewController

@property (nonatomic,weak) UIViewController *backViewController;
@property(nonatomic,assign)ArrowType arrowType;

/**设置返回按钮标题*/
- (void)setBackItemTitle:(NSString *)title;

/**设置导航栏图片按钮*/
- (void)setNavItemWithImage:(NSString *)imageName
            imageHightLight:(NSString *)hightLight
                     isLeft:(BOOL)isLeft
                     target:(id)target
                     action:(SEL)action;

/**设置导航栏文字按钮*/
- (void)setNavItemWithTitle:(NSString *)title
                     isLeft:(BOOL)isLeft
                     target:(id)target
                     action:(SEL)action;
/**隐藏导航栏按钮*/
- (void)setNavItemWithTitle:(NSString *)title isLeft:(BOOL)isLeft;


/**返回键,子类不重写默认返回上一页*/
- (void)goBack;

/**隐藏返回按钮*/
- (void)hiddenBackBtn;

/**
 收回键盘
 */
- (void)hiddenKeyBoard;
/**显示返回按钮*/
- (void)showBackBtn;

/**设置导航栏的颜色*/
- (void)setNavBarColor:(UIColor *)color;

/**
 隐藏导航栏底部的线
 */
- (void)hiddenNavigationBarBottomLine;

/**
 显示导航栏底部的线
 */
- (void)showNavigationBarBottomLine;
/**
 开启滑动返回手势
 */
- (void)openSlideBack;
/**
 关闭滑动返回手势
 */
- (void)closeSlideBack;


@end
