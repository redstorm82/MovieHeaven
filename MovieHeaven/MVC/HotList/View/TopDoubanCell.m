//
//  TopDoubanCell.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/7.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "TopDoubanCell.h"

@implementation TopDoubanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(TopDoubanModel *)model{
    _model = model;
    self.titleLabel.text = _model.title;
    [self.coverImageView yy_setImageWithURL:[NSURL URLWithString:_model.merged_cover_url] placeholder:[UIImage imageNamed:@"movie_item_img_holder"]];
    self.followsersLabel.text = [NSString stringWithFormat:@"%d浏览",_model.followers_count];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
