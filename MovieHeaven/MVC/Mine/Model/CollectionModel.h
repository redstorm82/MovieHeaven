//
//  CollectionModel.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/15.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseModel.h"

@interface CollectionModel : BaseModel
@property (nonatomic, strong) NSString * actors;
@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, strong) NSString * score;
@property (nonatomic, assign) NSInteger videoId;
@property (nonatomic, strong) NSString * videoName;
@property (nonatomic, strong) NSString * videoStatus;
@property (nonatomic, strong) NSString * videoType;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *create_time;
@end
