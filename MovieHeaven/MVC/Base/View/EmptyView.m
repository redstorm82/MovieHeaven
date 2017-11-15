//
//  EmptyView.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/3.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "EmptyView.h"
#import <Masonry.h>
#import "TopImageBottomLabelButton.h"
#import "UITools.h"
@implementation EmptyView{
    TopImageBottomLabelButton *_contentBtn;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame icon:(NSString *)icon tip:(NSString *)tip tapBlock:(void (^)(void))tapBlock{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
        self.icon = icon ? icon : @"empty_content";
        self.tip = tip ? tip : @"数据跑路了，点击重新加载(つ•̀ω•́)つ";
        self.tapBlock = tapBlock;
    }
    return self;
}
- (void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    _contentBtn = [TopImageBottomLabelButton buttonWithType:UIButtonTypeCustom];
    [_contentBtn setTitleColor:K9BColor forState:UIControlStateNormal];
    [self addSubview:_contentBtn];
    [_contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self).mas_offset(-20);
        make.height.mas_equalTo(150);
    }];
    _contentBtn.spacing = 10;
    [_contentBtn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setIcon:(NSString *)icon{
    _icon = icon;
    [_contentBtn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
}
-(void)setTip:(NSString *)tip{
    _tip = tip;
    [_contentBtn setTitle:tip forState:UIControlStateNormal];
    _contentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
}

- (void)tapAction{
    
    if (self.tapBlock) {
        self.tapBlock();
    }
}
@end
