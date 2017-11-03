//
//  VideoSectionModel.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/2.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseModel.h"
#import "VideoItemModel.h"
@interface VideoSectionModel : BaseModel
@property (nonatomic, strong) NSString * moreUrl;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSArray <VideoItemModel> * videos;
@end
