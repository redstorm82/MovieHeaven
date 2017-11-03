//
//  VideoItemModel.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/2.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseModel.h"
@protocol VideoItemModel
@end
@interface VideoItemModel : BaseModel

@property (nonatomic, assign) BOOL album;
@property (nonatomic, strong) NSString * doubanId;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSString * lastUpdateTime;
@property (nonatomic, assign) NSInteger movieId;
@property (nonatomic, strong) NSString * movieTypeName;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger publishTime;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, strong) NSString * status;
@end
