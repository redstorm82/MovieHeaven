//
//  UpdateHistoryCell.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/22.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "UpdateHistoryCell.h"

@implementation UpdateHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setModel:(UpdateHistoryModel *)model {
    _model = model;
    self.nameAndVersionLabel.text = [NSString stringWithFormat:@"%@ 版本%@(%ld)",_model.appName,_model.version,(long)_model.build];
    self.dateLabel.text = _model.update_time;
    self.updateContentLabel.text = [NSString stringWithFormat:@"主要更新：%@\n",_model.updateContent];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
