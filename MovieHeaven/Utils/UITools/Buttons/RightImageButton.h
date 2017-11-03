//
//  RightImageButton.h
//  GoToSchool
//
//  Created by 石文文 on 16/7/26.
//  Copyright © 2016年 UI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightImageButton : UIButton
@property (nonatomic,strong)UILabel *textLabel;//文字视图
@property (nonatomic,assign)CGFloat interstice;//图片与文字的空隙 默认5
@property (nonatomic,assign)BOOL isAutoLayout;//是否自动调整大小
@property (nonatomic,assign)CGSize maxSize;//最大的大小 开启自动调整后有效
@end
