//
//  MineHeaderView.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/12.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "MineHeaderView.h"

@implementation MineHeaderView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.avatarImgBtn.layer.cornerRadius = 40;
    self.avatarImgBtn.clipsToBounds = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
