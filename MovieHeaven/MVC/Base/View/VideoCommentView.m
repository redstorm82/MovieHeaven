//
//  VideoCommentView.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/3.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "VideoCommentView.h"
#import "UITools.h"
#import <Masonry.h>
@implementation VideoCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    UILabel *fuckLabel = [LabelTool createLableWithFrame:CGRectZero textColor:K33Color textFontOfSize:17];
    fuckLabel.numberOfLines = 0;
    fuckLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:fuckLabel];
    [fuckLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(KContentEdge, KContentEdge, KContentEdge, KContentEdge));
    }];
    fuckLabel.text = @"抱歉!!!!\n\n功能暂未开通";
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
