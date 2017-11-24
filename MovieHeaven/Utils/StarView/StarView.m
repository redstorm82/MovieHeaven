//
//  StartView.m
//
//  Created by 石文文 on 17/7/12
//  Copyright © 2017年 UI. All rights reserved.
//

#import "StarView.h"
#import "UIView+Extension.h"
#import "UITools.h"
@implementation StarView

-(instancetype)initWithFrame:(CGRect)frame starTotalCount:(NSInteger)totalCount lightStarCount:(NSInteger)lightStarCount isEditable:(BOOL)isEditable WhenClickStar:(ClickStarBlock)clickBlock{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.clickStarBlock = clickBlock;
        _isEditable = isEditable;
        CGFloat startSize = frame.size.height;
        CGFloat interval = startSize / 5;
        self.width = startSize * totalCount + interval * (totalCount - 1);
        if (lightStarCount > totalCount) {
            lightStarCount = totalCount;
        }
        CGFloat left = 0;
        for (int i = 0; i < totalCount; i ++) {
            UIButton *starButton = [ButtonTool createButtonWithImageName:@"Star1" addTarget:self action:@selector(clickstarAction:)];
            [starButton setImage:[UIImage imageNamed:@"Star2"] forState:UIControlStateSelected];
            starButton.frame = CGRectMake(left, 0, startSize, startSize);
            starButton.tag = i;
            left = starButton.right + interval;
            [self addSubview:starButton];
            
            if (i < lightStarCount) {
                starButton.selected = YES;
            }
        }
        
    }
    return self;
}
-(void)setLightStarCount:(NSInteger)lightStarCount{
    _lightStarCount = lightStarCount;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *star = obj;
        if (idx < lightStarCount) {
            star.selected = YES;
        }else{
            star.selected = NO;
        }
    }];
}

- (void)clickstarAction:(UIButton *)starButton{
    if (!_isEditable) {
        return;
    }
    NSInteger lightStarCount = starButton.tag + 1;
    
    [self setLightStarCount:lightStarCount];
    if (self.clickStarBlock) {
        self.clickStarBlock(lightStarCount - 1);
    }
}

@end
