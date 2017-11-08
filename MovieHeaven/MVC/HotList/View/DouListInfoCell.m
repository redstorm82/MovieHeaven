//
//  DouListInfoCell.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/8.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "DouListInfoCell.h"
#import <UIImageView+YYWebImage.h>
@implementation DouListInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setModel:(DouListInfoModel *)model {
    _model = model;
    [self.infoImageView yy_setImageWithURL:[NSURL URLWithString:_model.merged_cover_url] placeholder:[UIImage imageNamed:@"movie_item_img_holder"]];
    self.countLabel.text = [NSString stringWithFormat:@"%ld浏览",(long)_model.followers_count];
    self.descLabel.text = _model.desc;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
