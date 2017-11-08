//
//  DouListInfoModel.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/8.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseModel.h"

@interface DouListInfoModel : BaseModel

@property (nonatomic, strong) NSString * desc;
@property (nonatomic, assign) NSInteger followers_count;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * merged_cover_url;
@property (nonatomic, strong) NSString * title;

@end
