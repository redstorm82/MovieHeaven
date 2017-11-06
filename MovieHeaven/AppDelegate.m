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
