//
//  VideoSectionCell.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/2.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoSectionModel.h"

#define VideoItemWidth (kScreenWidth - 10.f * 4.f) / 3.f
#define VideoItemHeight (VideoItemWidth) / 3.f * 5.f

@interface VideoSectionCell : UITableViewCell
@property (nonatomic, strong) VideoSectionModel *model;
@end
