//
//  HistoryModel.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/16.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseModel.h"

@interface HistoryModel : BaseModel
@property (nonatomic, strong) NSString * actors;
@property (nonatomic, assign) NSInteger hid;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, assign) NSInteger isFinish;
@property (nonatomic, strong) NSString * partName;
@property (nonatomic, assign) double playingTime;
@property (nonatomic, strong) NSString * score;
@property (nonatomic, strong) NSString * sourceName;
@property (nonatomic, strong) NSString * sourceType;
@property (nonatomic, strong) NSString * update_time;
@property (nonatomic, assign) NSInteger vid;
@property (nonatomic, assign) NSInteger videoId;
@property (nonatomic, strong) NSString * videoName;
@property (nonatomic, strong) NSString * videoStatus;
@property (nonatomic, strong) NSString * videoType;
@end
