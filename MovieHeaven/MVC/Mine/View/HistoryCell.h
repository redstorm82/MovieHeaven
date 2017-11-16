//
//  HistoryCell.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/16.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryModel.h"
@interface HistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *imgBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *actorsLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) HistoryModel *model;
@end
