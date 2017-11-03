//
//  BannerCell.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/2.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BannerCell.h"
#import <UIImageView+WebCache.h>
@implementation BannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(BannerModel *)model{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:[UIImage imageNamed:@"banner"]];
    self.titleLabel.text = _model.desc;
}
@end
