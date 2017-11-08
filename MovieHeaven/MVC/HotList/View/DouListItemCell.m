//
//  DouListItemCell.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/8.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "DouListItemCell.h"
#import <UIImageView+YYWebImage.h>
@implementation DouListItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftconstraint.constant = KContentEdge;
    self.rightconstraint.constant = KContentEdge;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(DouListItemModel *)model {
    _model = model;
    [self.movieImageView yy_setImageWithURL:[NSURL URLWithString:_model.img] placeholder:[UIImage imageNamed:@"movie_item_img_holder"]];
    self.nameLabel.text = _model.name;
    self.scoreLabel.text = [NSString stringWithFormat:@"%.2f",_model.score];
    self.descLabel.text = _model.movieDesc;
    self.commentLabel.hidden = _model.comment.length < 1;
    self.commentLabel.text = _model.comment;
}
@end
