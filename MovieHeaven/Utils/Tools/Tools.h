//
//  Tools.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/2.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject
/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
+ (nullable NSMutableDictionary *)getURLParameters:(nonnull NSString *)urlStr;
/**
 *  转换为Base64编码
 */
+ (nullable NSString *)base64EncodedString:(nonnull NSString *)orgString;
/**
 *  将Base64编码还原
 */
+ (nullable NSString *)base64DecodedString:(nonnull NSString *)encodedString;

/**
 迅雷地址解析

 @param thunderUrl 迅雷地址
 @return 原地址
 */
+ (nullable NSString *)thunderUrlToOrgUrl:(nonnull NSString *)thunderUrl;

//32位MD5加密方式
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString;
// 将字典装换成字符串 用于签名
+ (NSString *)dictToStr:(NSDictionary *)dict;

//字典转JSON字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
@end
