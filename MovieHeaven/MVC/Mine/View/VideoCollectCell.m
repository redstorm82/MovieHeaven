//
//  VideoCollectCell.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/15.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "VideoCollectCell.h"
#import <UIImageView+YYWebImage.h>
@implementation VideoCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgBgView.layer.shadowColor = SystemColor.CGColor;
    self.imgBgView.layer.shadowOffset = CGSizeMake(2, 2);
    self.imgBgView.layer.shadowRadius = 2;
    self.imgBgView.layer.shadowOpacity = 0.8;
}
-(void)setModel:(CollectionModel *)model {
    _model = model;
    [self.imgView  yy_setImageWithURL:[NSURL URLWithString:_model.img] placeholder:[UIImage imageNamed:@"movie_item_img_holder"]];
    self.scoreLabel.text = _model.score;
    self.nameLabel.text = _model.videoName;
    self.statusLabel.text = _model.videoStatus;
    self.dateLabel.text = [NSString stringWithFormat:@"收藏时间：%@",_model.create_time];
    self.typeLabel.text = [NSString stringWithFormat:@"类型：%@",_model.videoType];
    self.actorsLabel.text = [NSString stringWithFormat:@"演员：%@",_model.actors];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
