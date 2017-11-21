//
//  LoginController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/12.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "LoginController.h"
#import <Masonry.h>
#import <UMSocialCore/UMSocialCore.h>
#import "Tools.h"
@interface LoginController ()

@end

@implementation LoginController
-(void)awakeFromNib {
    [super awakeFromNib];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor clearColor];
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    [self.view insertSubview:effectView atIndex:0];
//    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginWithQQ:(id)sender {
    [self getUserInfoForPlatform:UMSocialPlatformType_QQ];
}
- (IBAction)cancelLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            if (error.code == UMSocialPlatformErrorType_Cancel) {
                [[ToastView sharedToastView]show:[NSString stringWithFormat:@"%@",@"授权取消"] inView:nil];
            }else {
                [[ToastView sharedToastView]show:[NSString stringWithFormat:@"%@",error.userInfo[@"message"]] inView:nil];
            }
            
            return ;
        }
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        
        [self loginWithPlatformType:platformType unionid:resp.uid nickName:resp.name avatar:resp.iconurl gender:resp.gender];
        
        
    }];
}
#pragma mark -- 登录
- (void)loginWithPlatformType:(UMSocialPlatformType)platformType unionid:(NSString *)unionid nickName:(NSString *)name avatar:(NSString *)avatar gender:(NSString *)gender {
    
    NSDictionary *params = @{
                             @"qq_unionid":unionid,
                             @"nickName":name,
                             @"gender":gender,
                             @"avatar":avatar
                             };
    [HttpHelper POSTWithWMH:WMH_LOGIN headers:nil parameters:params HUDView:self.view progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
        
        if ([data[@"status"] isEqualToString:@"B0000"]) {
            NSDictionary *userInfo = data[@"userInfo"];
            UserInfo *user = [[UserInfo alloc]initWithDictionary:userInfo error:nil];
            [user save];
//            [Tools saveCookie];
            dispatch_main_async_safe(^{
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
                if (self.completion) {
                    self.completion(user);
                }
            })
        }else{
            [[ToastView sharedToastView]show:data[@"txt"] inView:nil];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
