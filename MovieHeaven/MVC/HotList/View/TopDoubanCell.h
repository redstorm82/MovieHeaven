//
//  TopDoubanCell.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/7.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopDoubanModel.h"
@interface TopDoubanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *followsersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraintInsert;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraintInsert;
@property (nonatomic,strong) TopDoubanModel *model;
@end
