//
//  VideoDetailTextCell.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/3.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "VideoDetailTextCell.h"
#import "UITools.h"
@implementation VideoDetailTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.contentTextView setLineSpace:5];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
