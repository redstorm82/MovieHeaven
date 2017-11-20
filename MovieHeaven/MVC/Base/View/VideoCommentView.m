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
#import "EmptyView.h"
@implementation VideoCommentView {
    EmptyView *_emptyView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    _emptyView = [[EmptyView alloc]initWithFrame:CGRectZero icon:nil tip:@"暂无评论" tapBlock:^{
        
    }];
    [self addSubview:_emptyView];
    TO_WEAK(self, weakSelf);
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf);
        make.edges.equalTo(strongSelf);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
