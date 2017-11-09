//
//  WemediaModel.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/9.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseModel.h"
@protocol WemediaModel

@end
@interface WemediaModel : BaseModel
@property (nonatomic, assign) NSInteger fanscount;
@property (nonatomic, strong) NSString * headImg;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger videocount;
@end
