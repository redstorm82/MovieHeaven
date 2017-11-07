//
//  VideoSectionCell.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/2.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoSectionModel.h"
#import "VideoCollectionCell.h"
#import "TopSubjectsModel.h"
@interface VideoSectionCell : UITableViewCell
@property (nonatomic, strong) VideoSectionModel *model;
@property (nonatomic, strong) TopSubjectsModel *topSubjectsModel;
@end
