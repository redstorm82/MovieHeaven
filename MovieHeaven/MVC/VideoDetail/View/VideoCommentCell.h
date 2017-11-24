//
//  VideoCommentCell.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/24.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCommentModel.h"
#import "StarView.h"
@interface VideoCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic,strong) StarView *starView;
@property (strong, nonatomic) VideoCommentModel *model;
@end
