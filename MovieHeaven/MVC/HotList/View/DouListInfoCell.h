//
//  DouListInfoCell.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/8.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DouListInfoModel.h"
@interface DouListInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;
@property (nonatomic, strong) DouListInfoModel *model;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@end
