//
//  EpisodeCellCollectionCell.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/3.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "EpisodeCellCollectionCell.h"

@implementation EpisodeCellCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.textLabel setCornerRadius:5];
    self.textLabel.layer.borderColor = K33Color.CGColor;
    self.textLabel.clipsToBounds = YES;
}

@end
