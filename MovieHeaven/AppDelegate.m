//
//  AppDelegate.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/10/31.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import "KeysDefine.h"
#import <AFNetworking.h>
#import <ZFDownloadManager.h>
#import "KeysDefine.h"
#import <IQKeyboardManager.h>
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _window.backgroundColor = [UIColor whiteColor];
    
    [self registerNotification];
    [self configBugly];
    [self configPgyer];
    [self startMonitoring];
    [self initSet];
    [self requestNewIP];
    [self configUM];
    [self configIQKeyboardManager];
    return YES;
}
#pragma mark -- 注册通知
- (void)registerNotification{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                         |UIUserNotificationTypeSound
                                                                                         |UIUserNotificationTypeAlert) categories:nil];
    
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}
#pragma mark -- 配置IQKeyboardManager
- (void)configIQKeyboardManager{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = NO;
    manager.shouldResignOnTouchOutside = YES;
}
#pragma mark -- 配置bugly
- (void)configBugly{
    
    BuglyConfig *config = [[BuglyConfig alloc]init];
#if DEBUG
    config.debugMode = YES;
#endif
    
    config.blockMonitorEnable = YES;
    [Bugly startWithAppId:BuglyAppId config:config];
    
}
#pragma mark -- 配置友盟
- (void)configUM {
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UM_APP_KEY];
    
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_APPID appSecret:WX_SECRET redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_API_ID  appSecret:nil redirectURL:@"http://www.gallifrey.cn"];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SINA_APP_KEY  appSecret:SINA_APP_SECRET redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
     [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
}
#pragma mark --配置蒲公英
- (void)configPgyer{
    
    // 设置用户反馈界面激活方式为三指拖动
    [[PgyManager sharedPgyManager]setFeedbackActiveType:kPGYFeedbackActiveTypeThreeFingersPan];
    
    // 设置用户反馈界面激活方式为摇一摇
    //    [[PgyManager sharedPgyManager] setFeedbackActiveType:kPGYFeedbackActiveTypeShake];
    //启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:PgyerId];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PgyerId];
    [[PgyManager sharedPgyManager] setThemeColor:SystemColor];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
}
#pragma mark --开启网络监听
- (void)startMonitoring{
    UserDefaultsSet(@(AFNetworkReachabilityStatusUnknown) ,NetStatus );
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //        if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
        //            [[ToastView sharedToastView]show:@"正在使用移动网络" inView:nil];
        //        }else if(status == AFNetworkReachabilityStatusReachableViaWiFi){
        //            [[ToastView sharedToastView]show:@"正在使用wifi" inView:nil];
        //        }
        //同步存入状态
        UserDefaultsSet(@(status) ,NetStatus );
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NetChange object:@(status)];
        //如果不允许移动网络下载 则暂停下载
        if (![UserDefaultsGet(WWANDownloading) boolValue]) {
            if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
                @try {
                    NSArray *downingList =  [[ZFDownloadManager sharedDownloadManager].downinglist copy];
                    for (ZFHttpRequest *request in downingList) {
                        [[ZFDownloadManager sharedDownloadManager]stopRequest:request];
                    }
                } @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                } @finally {
                    
                }
                
                
                
            }
            
        }
        
    }];
}
#pragma mark -- 初始化设置
- (void)initSet{
    if (!UserDefaultsGet(IPKey)) {
        UserDefaultsSet(@"http://116.62.60.110/newmovie", IPKey);
    }
    if (!UserDefaultsGet(SrearchHistory)) {
        UserDefaultsSet(@[].mutableCopy, SrearchHistory);
    }
    if (!UserDefaultsGet(ShowNotiName)) {
        UserDefaultsSet(@(NO), ShowNotiName);
    }
    if (!UserDefaultsGet(WWANPlay)) {
        UserDefaultsSet(@(NO), WWANPlay);
    }
    if (!UserDefaultsGet(WWANDownloading)) {
        UserDefaultsSet(@(NO), WWANDownloading);
    }
    if (!UserDefaultsGet(MaxDownloadCount)) {
        UserDefaultsSet(@"3", MaxDownloadCount);
    }
    
}
#pragma mark -- 获取新ip
- (void)requestNewIP{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *newIP = [NSString stringWithContentsOfURL:[NSURL URLWithString:NewIP] encoding:(NSUTF8StringEncoding) error:nil];
        
        if (newIP) {
            UserDefaultsSet(([NSString stringWithFormat:@"http://%@",newIP]),IPKey);
        }
        
    });
}
    // 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
    {
        //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
        if (!result) {
            
        }
        return result;
    }

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
