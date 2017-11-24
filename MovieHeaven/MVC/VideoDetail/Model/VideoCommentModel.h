//
//  VideoCommentModel.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/24.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseModel.h"

@interface VideoCommentModel : BaseModel
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, assign) NSInteger cmid;
@property (nonatomic, strong) NSString * commentTime;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * partName;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, strong) NSString * sourceName;
@property (nonatomic, strong) NSString * sourceType;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger vid;
@property (nonatomic, assign) NSInteger videoId;
@property (nonatomic, strong) NSString * videoName;
@end
