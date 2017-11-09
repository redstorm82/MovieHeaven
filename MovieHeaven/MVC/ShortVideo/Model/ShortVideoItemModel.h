//
//  ShortVideoItemModel.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/9.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseModel.h"
#import "WemediaModel.h"
@interface ShortVideoItemModel : BaseModel
@property (nonatomic, assign) NSInteger adsupport;
@property (nonatomic, strong) NSString * banner;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) NSString * cover;
@property (nonatomic, strong) NSString * duration;
@property (nonatomic, strong) NSString * playCount;
@property (nonatomic, strong) NSString * playurl;
@property (nonatomic, assign) NSInteger render;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) WemediaModel * wemedia;
@end
