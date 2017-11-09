//
//  ShortVideoItemCell.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/9.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShortVideoItemModel.h"
@interface ShortVideoItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *wemediaTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationAndCountLabel;
@property (weak, nonatomic) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, copy  ) void(^playBlock)(UIButton *);
@property (nonatomic, strong) ShortVideoItemModel *model;
@end
