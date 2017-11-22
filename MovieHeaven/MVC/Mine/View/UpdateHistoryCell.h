//
//  UpdateHistoryCell.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/22.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateHistoryModel.h"
@interface UpdateHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameAndVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateContentLabel;
@property (nonatomic,assign) UpdateHistoryModel *model;
@end
