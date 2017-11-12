//
//  HttpHelper.m
//  WolfVideo
//
//  Created by 石文文 on 16/8/6.
//  Copyright © 2016年 石文文. All rights reserved.
//

#import "HttpHelper.h"
#import "NSDictionary+Description.h"
#import "UIImage+Gif.h"
#import <MBProgressHUD.h>
#import "Tools.h"
typedef void(^Success)(NSURLSessionDataTask * _Nonnull task, NSDictionary *response);
typedef void(^Failure)(NSError *error);

@implementation HttpHelper

+(AFHTTPSessionManager * _Nullable)GET:(NSString * _Nonnull)url headers:(NSDictionary * _Nullable)headers parameters:(NSDictionary * _Nullable)params HUDView:(UIView * _Nullable)view progress:(void (^ _Nullable)(NSProgress * _Nonnull progress))downloadProgress
                                success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) )success
                                failure:(void (^ _Nullable)(NSError * _Nullable error))failure{
    
    
    if (view) {
        
        dispatch_main_async_safe(^{
            [MBProgressHUD hideHUDForView:view animated:YES];
            UIImage *image = [UIImage animatedGIFNamed:@"loading_big"];
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:view animated:YES];
            hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
            hud.bezelView.backgroundColor = [UIColor clearColor];
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = imageView;
        })
        
    }
    if (!(AFNetworkReachabilityManager.sharedManager.isReachable || AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusUnknown)){
            //无网络
        if (view) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               [MBProgressHUD hideHUDForView:view animated:YES];
                
            });
        }
        
        failure([NSError errorWithDomain:@"无网络" code:4444 userInfo:nil]);
        
        [[ToastView sharedToastView]show:@"网络开小差了o(╯□╰)o,请稍后重试" inView:nil];
        
        
    }else{
       //有网络
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 60;
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        if (headers && headers.count > 0) {
            for (NSString *key in headers.allKeys) {
                [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
            }
            
        }
        [manager.requestSerializer setValue:@"android" forHTTPHeaderField:@"platform"];
        [manager.requestSerializer setValue:@"true" forHTTPHeaderField:@"xigua"];
        [manager.requestSerializer setValue:@"true" forHTTPHeaderField:@"thunder"];
        [manager.requestSerializer setValue:@"com.ghost.movieheaven" forHTTPHeaderField:@"package"];
        [manager.requestSerializer setValue:@"ASXv4M7Vq30DANPxSdX7nbZV" forHTTPHeaderField:@"userId"];

        [manager GET:[NSString stringWithFormat:@"%@",url] parameters:params progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"GET:---%@ --\nparams:%@------\n response:%@",url,params.description,((NSDictionary *)responseObject).my_description);
            if (view) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:view animated:YES];
                    
                });
            }
            
            success(task, (NSDictionary *)responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            if (error.code != -1016) {
                [[ToastView sharedToastView]show:@"请求失败，请稍后重试" inView:nil];
            }
            
            if (view) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:view animated:YES];
                    
                });
            }
            failure(error);
            
        }];
        return manager;
    }
    return nil;
    
  

}
+(AFHTTPSessionManager * _Nullable)POST:(NSString * _Nonnull)url headers:(NSDictionary * _Nullable)headers parameters:(NSDictionary * _Nullable)params HUDView:(UIView * _Nullable)view progress:(void (^ _Nullable)(NSProgress * _Nonnull progress))downloadProgress
                                success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) )success
                                failure:(void (^ _Nullable)(NSError * _Nullable error))failure{
    
    
    if (view) {
        dispatch_main_async_safe(^{
            [MBProgressHUD hideHUDForView:view animated:YES];
            UIImage *image = [UIImage animatedGIFNamed:@"loading_big"];
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:view animated:YES];
            hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
            hud.bezelView.backgroundColor = [UIColor clearColor];
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = imageView;
        })
        
    }
    if (!(AFNetworkReachabilityManager.sharedManager.isReachable || AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusUnknown)){
        //无网络
        if (view) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:view animated:YES];
                
            });
        }
        
        failure([NSError errorWithDomain:@"无网络" code:4444 userInfo:nil]);
        [[ToastView sharedToastView]show:@"网络开小差了o(╯□╰)o,请稍后重试" inView:nil];
        
    }else{
        //有网络
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 60;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        if (headers) {
            for (NSString *key in headers.allKeys) {
                [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
            }
        }
        [manager POST:[NSString stringWithFormat:@"%@",url] parameters:params progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"POST:---%@ --\nparams:%@------\n response:%@",url,params.description,((NSDictionary *)responseObject).my_description);
            if (view) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:view animated:YES];
                    
                });
            }
            
            success(task, (NSDictionary *)responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            if (error.code != -1016) {
                [[ToastView sharedToastView]show:@"请求失败，请稍后重试" inView:nil];
            }
            if (view) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:view animated:YES];
                    
                });
            }
            failure(error);
            
        }];
        return manager;
    }
    return nil;
    
    
}



+(AFHTTPSessionManager * _Nullable)GETWithWMH:(NSString * _Nonnull)url headers:(NSDictionary * _Nullable)headers parameters:(NSDictionary * _Nullable)params HUDView:(UIView * _Nullable)view progress:(void (^ _Nullable)(NSProgress * _Nonnull progress))downloadProgress
                               success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) )success
                               failure:(void (^ _Nullable)(NSError * _Nullable error))failure{
    
    
    if (view) {
        
        dispatch_main_async_safe(^{
            [MBProgressHUD hideHUDForView:view animated:YES];
            UIImage *image = [UIImage animatedGIFNamed:@"loading_big"];
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:view animated:YES];
            hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
            hud.bezelView.backgroundColor = [UIColor clearColor];
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = imageView;
        })
        
    }
    if (!(AFNetworkReachabilityManager.sharedManager.isReachable || AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusUnknown)){
        //无网络
        if (view) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:view animated:YES];
                
            });
        }
        
        failure([NSError errorWithDomain:@"无网络" code:4444 userInfo:nil]);
        
        [[ToastView sharedToastView]show:@"网络开小差了o(╯□╰)o,请稍后重试" inView:nil];
        
        
    }else{
        //有网络
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 60;
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        if (headers && headers.count > 0) {
            for (NSString *key in headers.allKeys) {
                [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
            }
            
        }
        
        NSMutableDictionary *getParams = [NSMutableDictionary dictionaryWithDictionary:params];
        getParams[@"from"] = @"iOS";
        getParams[@"version"] = APP_VERSION;
        [manager GET:[NSString stringWithFormat:@"%@",url] parameters:getParams progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *responseDic = (NSDictionary *)responseObject;
            NSLog(@"GET:---%@ --\nparams:%@------\n response:%@",url,params.description,responseDic.my_description);
            if (view) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:view animated:YES];
                    
                });
            }
            
            if ([responseDic[@"code"] isEqualToString:@"0000"]) {
                success(task, responseDic[@"data"]);
            }else if ([responseDic[@"code"] isEqualToString:@"9995"]) {
                [[ToastView sharedToastView]show:responseDic[@"msg"] inView:nil];
//                登陆后操作
                
            }else{
                [[ToastView sharedToastView]show:responseDic[@"msg"] inView:nil];
                failure([NSError errorWithDomain:responseDic[@"msg"] code:[responseDic[@"code"] integerValue] userInfo:nil]);
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [[ToastView sharedToastView]show:@"请求失败，请稍后重试" inView:nil];
            if (view) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:view animated:YES];
                    
                });
            }
            failure(error);
            
        }];
        return manager;
    }
    return nil;
    
    
    
}
+(AFHTTPSessionManager * _Nullable)POSTWithWMH:(NSString * _Nonnull)url headers:(NSDictionary * _Nullable)headers parameters:(NSDictionary * _Nullable)params HUDView:(UIView * _Nullable)view progress:(void (^ _Nullable)(NSProgress * _Nonnull progress))downloadProgress
                                      success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) )success
                                      failure:(void (^ _Nullable)(NSError * _Nullable error))failure{
    
    
    if (view) {
        
        dispatch_main_async_safe(^{
            [MBProgressHUD hideHUDForView:view animated:YES];
            UIImage *image = [UIImage animatedGIFNamed:@"loading_big"];
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:view animated:YES];
            hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
            hud.bezelView.backgroundColor = [UIColor clearColor];
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = imageView;
        })
        
    }
    if (!(AFNetworkReachabilityManager.sharedManager.isReachable || AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusUnknown)){
        //无网络
        if (view) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:view animated:YES];
                
            });
        }
        
        failure([NSError errorWithDomain:@"无网络" code:4444 userInfo:nil]);
        
        [[ToastView sharedToastView]show:@"网络开小差了o(╯□╰)o,请稍后重试" inView:nil];
        
        
    }else{
        //有网络
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 60;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        if (headers && headers.count > 0) {
            for (NSString *key in headers.allKeys) {
                [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
            }
            
        }
        
        NSDictionary *postParams = @{
                                    @"from":@"iOS",
                                    @"version":APP_VERSION,
                                    @"data":params,
                                    @"sign":[Tools getMd5_32Bit_String:[Tools dictToStr:params]]
                                    };
        
        [manager POST:[NSString stringWithFormat:@"%@",url] parameters:postParams progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *responseDic = (NSDictionary *)responseObject;
            NSLog(@"GET:---%@ --\nparams:%@------\n response:%@",url,params.description,responseDic.my_description);
            if (view) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:view animated:YES];
                    
                });
            }
            
            if ([responseDic[@"code"] isEqualToString:@"0000"]) {
                success(task, responseDic[@"data"]);
            }else if ([responseDic[@"code"] isEqualToString:@"9995"]) {
                [[ToastView sharedToastView]show:responseDic[@"msg"] inView:nil];
                //                登陆后操作
                
            }else{
                [[ToastView sharedToastView]show:responseDic[@"msg"] inView:nil];
                failure([NSError errorWithDomain:responseDic[@"msg"] code:[responseDic[@"code"] integerValue] userInfo:nil]);
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [[ToastView sharedToastView]show:@"请求失败，请稍后重试" inView:nil];
            if (view) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:view animated:YES];
                    
                });
            }
            failure(error);
            
        }];
        return manager;
    }
    return nil;
    
    
    
}
@end
