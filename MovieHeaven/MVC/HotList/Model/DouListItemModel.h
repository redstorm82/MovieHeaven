//
//  DouListItemModel.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/8.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseModel.h"

@interface DouListItemModel : BaseModel

@property (nonatomic, assign) BOOL album;
@property (nonatomic, strong) NSString * comment;
@property (nonatomic, strong) NSString * doubanId;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString * movieDesc;
@property (nonatomic, assign) NSInteger movieId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * pid;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, strong) NSString * topicId;
@property (nonatomic, assign) BOOL v3Show;
@end
