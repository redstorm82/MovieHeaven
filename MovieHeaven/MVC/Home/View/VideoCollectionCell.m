//
//  VideoCollectionCell.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/2.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "VideoCollectionCell.h"


@implementation VideoCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(VideoItemModel *)model{
    _model = model;
    
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:_model.img] placeholder:[UIImage imageNamed:@"movie_item_img_holder.jpg"]];

    self.titleLabel.text = _model.name;
    self.gradeLabel.text = [NSString stringWithFormat:@"%.1f",_model.score];
    if (_model.status.length > 0) {
        self.statusLabel.hidden = NO;
        self.statusLabel.text = _model.status;
    }else{
        self.statusLabel.hidden = YES;
    }
}
@end
