//
//  FilterItemCell.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/7.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "FilterItemCell.h"

@implementation FilterItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.textColor = K33Color;
}
-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (_isSelected) {
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.backgroundColor =SystemColor;
    }else{
        self.textLabel.textColor = K33Color;
        self.textLabel.backgroundColor = [UIColor whiteColor];
    }
}
@end
