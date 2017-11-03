//
//  ToastView.h
//  WolfVideo
//
//  Created by 石文文 on 16/8/7.
//  Copyright © 2016年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastView : UIView{
    
    UIView *_blackBgView;
    
    UILabel *_contentLabel;
    
}
/**
 *  类方法实例化单例对象
 *
 *  @return
 */
+(instancetype)sharedToastView;
/**
 *  显示提示
 *
 *  @param title 文字内容
 *  @param view  显示的视图
 */
-(void)show:(NSString *)title inView:(UIView *)view;

@end
