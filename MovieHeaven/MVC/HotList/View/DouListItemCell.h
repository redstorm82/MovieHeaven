//
//  DouListItemCell.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/8.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DouListItemModel.h"
@interface DouListItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftconstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightconstraint;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (nonatomic, strong) DouListItemModel *model;
@end
