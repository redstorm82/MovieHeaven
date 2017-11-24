//
//  StartView.h
//
//  Created by 石文文 on 17/7/12
//  Copyright © 2017年 UI. All rights reserved.
//


typedef void(^ClickStarBlock)(NSInteger currentIndex);
@interface StarView : UIView

/**
 星星视图

 @param frame 大小 宽度设定无效 宽度会自动计算为 height * 星星总数 + height / 5 * (星星总数-1)
 @param totalCount 星星总数
 @param lightStarCount 亮的星星
 @param isEditable 是否可以点击编辑
 @param clickBlock 点击星星的回调
 @return 星星视图
 */
-(instancetype)initWithFrame:(CGRect)frame starTotalCount:(NSInteger)totalCount lightStarCount:(NSInteger)lightStarCount isEditable:(BOOL)isEditable WhenClickStar:(ClickStarBlock)clickBlock;

/**
 亮的星星数
 */
@property (nonatomic,assign) NSInteger lightStarCount;

/**
 点击星星的回调
 */
@property (nonatomic,copy) ClickStarBlock clickStarBlock;

/**
 是否可以点击编辑
 */
@property (nonatomic,assign)BOOL isEditable;
@end
