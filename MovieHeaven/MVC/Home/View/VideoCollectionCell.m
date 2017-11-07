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
    self.statusLabel.hidden = YES;
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
-(void)setTopModel:(TopVideoItemModel *)topModel{
    _topModel = topModel;
    NSString *image = _topModel.img;
    NSURL *imgUrl = [NSURL URLWithString:image];
    [self.imageView yy_setImageWithURL:imgUrl placeholder:[UIImage imageNamed:@"movie_item_img_holder.jpg"] options:(YYWebImageOptionIgnoreFailedURL|YYWebImageOptionAllowBackgroundTask|YYWebImageOptionAllowInvalidSSLCertificates) completion:NULL];
    self.titleLabel.text = _topModel.name;
    self.gradeLabel.text = [NSString stringWithFormat:@"%.1f",_topModel.score];
    
}
@end
