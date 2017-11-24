//
//  UserInfo.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/12.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfo : BaseModel <NSCoding>
@property (nonatomic, strong, nullable) NSString * avatar;
@property (nonatomic, strong, nullable) NSString * gender;
@property (nonatomic, strong, nullable) NSString * nickName;
@property (nonatomic) NSInteger accumulatedPoints; //积分
@property (nonatomic, assign) NSInteger uid;

/**
 保存用户信息
 */
- (void)save;

/**
 读取用户信息

 @return UserInfo
 */
+ (nullable instancetype)read;

/**
 清除用户信息
 */
+ (void)clean;

/**
 重置设置
 */
+ (void)resetOptions;
@end
