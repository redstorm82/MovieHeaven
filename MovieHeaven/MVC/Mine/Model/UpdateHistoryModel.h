//
//  UpdateHistoryModel.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/22.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseModel.h"

@interface UpdateHistoryModel : BaseModel
@property (nonatomic, strong) NSString * appName;
@property (nonatomic, assign) NSInteger build;
@property (nonatomic, strong) NSString * bundleId;
@property (nonatomic, strong) NSString * updateContent;
@property (nonatomic, assign) NSInteger forceUpdate;
@property (nonatomic, strong) NSString * update_time;
@property (nonatomic, strong) NSString * version;
@end
