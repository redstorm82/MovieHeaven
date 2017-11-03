//
//  FilterModel.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/2.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseModel.h"

@interface FilterModel : BaseModel
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * url;
@end
