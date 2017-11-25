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
#import "Tools.h"
#import "VideoDetailController.h"
#import "UserInfo.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@import GoogleMobileAds;
@interface AppDelegate () <JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _window.backgroundColor = [UIColor whiteColor];
    
//    [self registerNotification];
    [self initJpush:launchOptions];
    [self configBugly];
//    [self configPgyer];
    [self startMonitoring];
    [self initSet];
    [self requestNewIP];
    [self configUM];
    [self initADMOB];
    [self configIQKeyboardManager];
//    [Tools saveCookie];
    
    [self handleLaunchByNotification:launchOptions];
    
    return YES;
}
#pragma mark -- 处理通过点击通知启动的
- (void)handleLaunchByNotification:(NSDictionary *)launchOptions {
    
    [self resetBadge];
    NSDictionary *userInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (userInfo) {
        // 取得 APNs 标准信息内容
        NSDictionary *aps = [userInfo valueForKey:@"aps"];
        NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
        NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
        NSString *sound = [aps valueForKey:@"sound"]; //播放的声音


        NSString *target = [userInfo valueForKey:@"target"];
        if (target && [target isEqualToString:@"check_update"]) {
            //
        } else {
            [Tools executeWithClassName:[userInfo valueForKey:@"className"] method:[userInfo valueForKey:@"method"] withObject:[userInfo valueForKey:@"object"] afterDelay:[userInfo[@"delay"] doubleValue] isClassMethod:[userInfo[@"isClassMethod"] intValue]];
            
        }
    }
}
#pragma mark -- 注册通知
- (void)registerNotification{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                         |UIUserNotificationTypeSound
                                                                                         |UIUserNotificationTypeAlert) categories:nil];
    
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}
#pragma mark -- 初始化极光
- (void)initJpush:(NSDictionary *)launchOptions {
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#ifdef DEBUG
    [JPUSHService setupWithOption:launchOptions appKey:JpushKey
                          channel:@"http://www.gallifrey.cn"
                 apsForProduction:NO
            advertisingIdentifier:nil];
#else
    [JPUSHService setupWithOption:launchOptions appKey:JpushKey
                          channel:@"http://www.gallifrey.cn"
                 apsForProduction:YES
            advertisingIdentifier:nil];
#endif
    
    //监听自定义消息
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegisterNotification:) name:kJPFNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLoginNotification:) name:kJPFNetworkDidLoginNotification object:nil];
}
#pragma mark -- 初始化ADMOB
- (void)initADMOB {
    [GADMobileAds configureWithApplicationID:ADMOB_ID];
    
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
    config.channel = @"www.gallifrey.cn";
    config.blockMonitorEnable = YES;
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
    
     [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sms)]];
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
#ifdef DEBUG
    
#else
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
#endif

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
        UserDefaultsSet(DefaultAPI, IPKey);
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    if (!UserDefaultsGet(SrearchHistory)) {
        UserDefaultsSet(@[].mutableCopy, SrearchHistory);
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
    // 获取最新Api (GET http://ip.941pk.cn/newip.txt)
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    [manager GET:GetNewIP parameters:nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *newIP = [[NSString alloc]initWithData:(NSData *)responseObject encoding:(NSUTF8StringEncoding)];
        if ([newIP containsString:@"html"]) {
            [self requestNewIP];
        }
        NSLog(@"newip--%@",newIP);
        
        if (newIP) {
            newIP = [NSString stringWithFormat:@"http://%@",newIP];
            if ([newIP isEqualToString: UserDefaultsGet(IPKey)]) {
                return ;
            }
            UserDefaultsSet(newIP,IPKey);
            [[NSUserDefaults standardUserDefaults]synchronize];
            //            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到配置更新,请重启以更新配置" preferredStyle:(UIAlertControllerStyleAlert)];
            //            [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //                exit(0);
            //            }]];
            //            if (_window.rootViewController) {
            //                [_window.rootViewController presentViewController:alter animated:YES completion:NULL];
            //            }
        } else {
            [self requestNewIP];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestNewIP];
    }];

/*
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *newIP = [NSString stringWithContentsOfURL:[NSURL URLWithString:NewIP] encoding:(NSUTF8StringEncoding) error:nil];
        NSLog(@"newip--%@",newIP);
        
        if (newIP) {
            newIP = [NSString stringWithFormat:@"http://%@",newIP];
            if ([newIP isEqualToString: UserDefaultsGet(IPKey)]) {
                return ;
            }
            UserDefaultsSet(newIP,IPKey);
            [[NSUserDefaults standardUserDefaults]synchronize];
//            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到配置更新,请重启以更新配置" preferredStyle:(UIAlertControllerStyleAlert)];
//            [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                exit(0);
//            }]];
//            if (_window.rootViewController) {
//                [_window.rootViewController presentViewController:alter animated:YES completion:NULL];
//            }
        } else {
            [self requestNewIP];
        }
        
    });
 */
}

#pragma mark -- 推送相关'
//自定义消息
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    
}
- (void)networkDidRegisterNotification:(NSNotification *)notification {
    UserInfo *user = [UserInfo read];
    if (user) {
        if (user.uid > 0) {
            [JPUSHService setAlias:[NSString stringWithFormat:@"%ld",user.uid] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
            } seq:0];
        } else {
            [HttpHelper GETWithWMH:WMH_USER_INFO headers:nil parameters:nil HUDView:nil progress:^(NSProgress * _Nonnull progress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
                if ([data[@"status"] isEqualToString:@"B0000"]) {
                    NSDictionary *userInfo = data[@"userInfo"];
                    UserInfo *user = [[UserInfo alloc]initWithDictionary:userInfo error:nil];
                    [user save];
                    NSString *ailas = [NSString stringWithFormat:@"%ld",user.uid];
                    [JPUSHService setAlias:ailas completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                        
                    } seq:0];
                }else{
                    
                }
            } failure:^(NSError * _Nullable error) {
                
            }];
        }
        
    }
}
- (void)networkDidLoginNotification:(NSNotification *)notification {
    UserInfo *user = [UserInfo read];
    if (user && user.uid > 0) {
        [JPUSHService setAlias:[NSString stringWithFormat:@"%ld",user.uid] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
        } seq:0];
    }
}
//注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
//实现注册APNs失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
// iOS 10 Support
//iOS10以上 APP在前台 接收到消息 处理 觉得显不显示
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    // Required
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        
    }
    else {
        // 本地通知
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}
// iOS 10 Support
//iOS10 以上 点击通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [Tools executeWithClassName:[userInfo valueForKey:@"className"] method:[userInfo valueForKey:@"method"] withObject:[userInfo valueForKey:@"object"] afterDelay:[userInfo[@"delay"] doubleValue] isClassMethod:[userInfo[@"isClassMethod"] integerValue]];
    }
    else {
        // 本地通知
    }
    [self resetBadge];
    completionHandler();  // 系统要求执行这个方法
}
#endif
//iOS7 以上 点击通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field  =[%@]",content,badge,sound,customizeField1);

    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    
    [self resetBadge];
    [Tools executeWithClassName:[userInfo valueForKey:@"className"] method:[userInfo valueForKey:@"method"] withObject:[userInfo valueForKey:@"object"] afterDelay:[userInfo[@"delay"] doubleValue] isClassMethod:[userInfo[@"isClassMethod"] integerValue]];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark -- 清空Badge
- (void)resetBadge{
    [JPUSHService resetBadge];
    UIApplication.sharedApplication.applicationIconBadgeNumber = 0;
}

    // 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
        if ([url.scheme isEqualToString:@"watchmovieheaven"]) {
            NSRange range = [url.absoluteString rangeOfString:@"videoId="];
            if (range.location != NSNotFound) {
                NSString *videoId = [url.absoluteString substringFromIndex:range.location + range.length];
                
                NSScanner* scan = [NSScanner scannerWithString:videoId];
                int val;
                if ([scan scanInt:&val] && [scan isAtEnd]) {
                    [AppDelegate toVideoDetail:videoId];
                }
            }
            return true;
        }
        //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
        if (!result) {
            
        }
        return result;
}
#pragma mark -- 跳转到视频详情
+ (void)toVideoDetail:(NSString *)videoId{
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    if (window) {
        VideoDetailController *detailVC = [[VideoDetailController alloc]init];
        detailVC.videoId = videoId.integerValue;
        
        detailVC.from = @"index";
        UITabBarController *tab = (UITabBarController *)window.rootViewController;
        UINavigationController *navi = tab.viewControllers[tab.selectedIndex];
        [navi pushViewController:detailVC animated:YES];
    }
    
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
    [self resetBadge];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
