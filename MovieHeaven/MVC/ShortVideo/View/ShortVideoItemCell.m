//
//  ShortVideoItemCell.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/9.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "ShortVideoItemCell.h"
#import <UIImageView+YYWebImage.h>
#import <Masonry.h>
#import "UITools.h"
@implementation ShortVideoItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bannerImageView.tag = 101;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"jc_play_normal"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.bannerImageView addSubview:self.playBtn];
    TO_WEAK(self, weakSelf)
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.center.equalTo(strongSelf.bannerImageView);
        make.width.height.mas_equalTo(60);
    }];
    self.titleLabel = [LabelTool createLableWithFrame:CGRectZero textColor:[UIColor whiteColor] textFontOfSize:15];
    self.titleLabel.numberOfLines = 3;
    [self.bannerImageView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.left.equalTo(strongSelf.bannerImageView).mas_equalTo(14);
        make.top.equalTo(strongSelf.bannerImageView).mas_equalTo(8);
        make.right.equalTo(strongSelf.bannerImageView).mas_equalTo(-14);
    }];
}
-(void)setModel:(ShortVideoItemModel *)model {
    _model = model;
    [self.bannerImageView yy_setImageWithURL:[NSURL URLWithString:_model.banner] placeholder:nil];
    self.wemediaTitleLabel.text = _model.wemedia.title;
    [self.coverImageView yy_setImageWithURL:[NSURL URLWithString:_model.wemedia.headImg] placeholder:nil];
    self.durationAndCountLabel.text = [NSString stringWithFormat:@"播放%@次/时长%@",_model.playCount,_model.duration];
    self.titleLabel.text = _model.title;
}

- (void)play:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
