//
//  SourceModel.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/2.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseModel.h"

@interface SourceModel : BaseModel
@property (nonatomic, assign) NSInteger aid;
@property (nonatomic, strong) NSString * detail;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * playUrl;
@property (nonatomic, assign) NSInteger vid;
@end
