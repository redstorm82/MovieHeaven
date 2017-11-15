//
//  VideoCollectCell.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/15.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"
@interface VideoCollectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *imgBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *actorsLabel;
@property (nonatomic, strong) CollectionModel *model;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end
