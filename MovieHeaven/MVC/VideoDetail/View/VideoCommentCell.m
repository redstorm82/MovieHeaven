//
//  VideoCommentCell.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/24.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "VideoCommentCell.h"
#import <UIImageView+YYWebImage.h>
#import <Masonry.h>
#import "UITools.h"
@implementation VideoCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftConstraint.constant = KContentEdge;
    self.rightConstraint.constant = KContentEdge;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.starView = [[StarView alloc]initWithFrame:CGRectMake(0, 0, 0, 15) starTotalCount:5 lightStarCount:0 isEditable:NO WhenClickStar:^(NSInteger currentIndex) {
        
    }];
    [self.contentView addSubview:self.starView];
    TO_WEAK(self, weakSelf);
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf);
        make.right.equalTo(strongSelf.contentView).mas_offset(-KContentEdge);
        make.centerY.equalTo(strongSelf.dateLabel);
        make.size.mas_equalTo(strongSelf.starView.size);
    }];
    _type = Normal;
    self.avatarImgView.layer.cornerRadius = 25;
    self.avatarImgView.layer.borderColor = KECColor.CGColor;
    self.avatarImgView.layer.borderWidth = 0.5;

}
- (void)setType:(CommentType)type {
    if (_type == type) {
        return;
    }
    _type = type;
    if (_type == Normal) {
        self.avatarImgView.layer.cornerRadius = 25;
        self.avatarImgView.layer.borderColor = KECColor.CGColor;
        self.avatarImgView.layer.borderWidth = 0.5;
    } else {
        self.imageWidthConstraint.constant = 80;
        self.imageHeightConstraint.constant = 100;
        self.avatarImgView.layer.cornerRadius = 0;
        self.avatarImgView.layer.borderWidth = 0;
        
    }
}
-(void)setModel:(VideoCommentModel *)model {
    _model = model;
    if (_type == Normal) {
        [self.avatarImgView yy_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholder:[UIImage imageNamed:@"header"]];
        self.nameLabel.text = _model.nickName;
    } else{
        [self.avatarImgView  yy_setImageWithURL:[NSURL URLWithString:_model.img] placeholder:[UIImage imageNamed:@"movie_item_img_holder"]];
        self.nameLabel.text = _model.videoName;
        
    }
    
    
    self.dateLabel.text = _model.commentTime;
    self.contentLabel.text = _model.content;
    self.starView.lightStarCount = _model.score;
    [self.contentLabel setLineSpace:5];
}
-(void)layoutSubviews{
    [super layoutSubviews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
