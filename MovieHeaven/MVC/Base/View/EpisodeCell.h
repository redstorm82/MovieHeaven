//
//  EpisodeCell.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/3.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SourceModel.h"
@interface EpisodeCell : UITableViewCell
@property (nonatomic,strong)NSArray <SourceModel *> *sources;
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,assign)BOOL isFull;
@property (nonatomic,copy)void(^clickVideoItem)(NSInteger index);
@end
