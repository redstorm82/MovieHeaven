//
//  BannerModel.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/2.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseModel.h"

@interface BannerModel : BaseModel
@property (nonatomic, copy) NSString * desc;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, copy) NSString * img;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger vid;
@end
