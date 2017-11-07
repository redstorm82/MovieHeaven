//
//  VideoCollectionCell.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/2.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoItemModel.h"
#define VideoItemWidth (kScreenWidth - 10.f * 2.f - KContentEdge * 2) / 3.f
#define VideoItemHeight (VideoItemWidth) / 3.f * 5.f
@interface VideoCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) VideoItemModel *model;
@end
