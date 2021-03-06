//
//  TopDoubanModel.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/7.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseModel.h"

@interface TopDoubanModel : BaseModel
@property (nonatomic, assign) NSInteger followers_count;
@property (nonatomic, assign) NSInteger  id;
@property (nonatomic, strong) NSString * merged_cover_url;
@property (nonatomic, strong) NSString * title;
@end
