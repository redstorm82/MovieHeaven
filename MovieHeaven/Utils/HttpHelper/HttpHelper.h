//
//  HttpHelper.h
//  WolfVideo
//
//  Created by 石文文 on 16/8/6.
//  Copyright © 2016年 石文文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking.h>
@interface HttpHelper : NSObject
/**
 *  POST请求
 *
 *  @param url              url
 *  @param headers          headers
 *  @param params           参数
 *  @param view  加载loading的父视图
 *  @param downloadProgress 进度回调
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+(AFHTTPSessionManager * _Nullable)POST:(NSString * _Nonnull)url headers:(NSDictionary * _Nullable)headers parameters:(NSDictionary *  _Nullable)params HUDView:(UIView * _Nullable)view progress:(void (^ _Nullable)(NSProgress * _Nonnull progress))downloadProgress
    success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) )success
    failure:(void (^ _Nullable)(NSError * _Nullable error))failure;
/**
 *  GET请求
 *
 *  @param url              url
 *  @param headers          headers
 *  @param params           参数
 *  @param view  加载loading的父视图
 *  @param downloadProgress 进度回调
 *  @param success          成功回调
 *  @param failure          失败回调
 */
+(AFHTTPSessionManager * _Nullable)GET:(NSString * _Nonnull)url headers:(NSDictionary * _Nullable)headers parameters:(NSDictionary *  _Nullable)params HUDView:(UIView * _Nullable)view progress:(void (^ _Nullable)(NSProgress * _Nonnull progress))downloadProgress
                                success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) )success
                                failure:(void (^ _Nullable)(NSError * _Nullable error))failure;

@end
