//
//  SettingController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/12.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "SettingController.h"
#import "UserInfo.h"
#import <Masonry.h>
#import "DisclaimerController.h"
#import "UITools.h"
#import "UserInfo.h"
#import <MessageUI/MessageUI.h>
#import "AlertView.h"
#import <PgyUpdate/PgyUpdateManager.h>
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
@interface SettingController () <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>{
    
    UITableView *_tableView;
    NSArray <NSArray<NSDictionary *> *> *_setingItemList;
    
}

@end

@implementation SettingController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self createUI];
    [self initData];
    
}

#pragma mark -- 初始化数据
- (void)initData{
    
    _setingItemList = @[
                        @[@{
                              @"title":@"免责声明",
                              @"detail":@"点击查看",
                              @"accessoryType":@(1),
                              @"action":@"toDisclaimer"
                              },
                          @{
                              @"title":@"联系我",
                              @"detail":@"shiwenwendevelop@163.com",
                              @"accessoryType":@(1),
                              @"action":@"toConnectMe"
                              },],
                        @[@{
                            @"title":@"版本号",
                            @"detail":[NSString stringWithFormat:@"v%@",APP_VERSION],
                            @"accessoryType":@(0),
                            @"action":@""
                            },
                          @{
                              @"title":@"更新",
                              @"detail":@"点击检查更新",
                              @"accessoryType":@(1),
                              @"action":@"checkUpdate"
                              },
                          @{
                              @"title":@"觉得还不错?",
                              @"detail":@"分享给好友",
                              @"accessoryType":@(1),
                              @"action":@"shareAPP"
                              },
                          ]
                        
                      ];
    
}

#pragma mark -- 创建UI
- (void)createUI{
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    TO_WEAK(self, weakSelf)
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf.view);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if (@available(iOS 11.0,*)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    
    
    _tableView.separatorColor = KECColor;
    if ([UserInfo read]) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
        
        UIButton *signOutBtn = [ButtonTool createButtonWithTitle:@"退出登录" titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:17] addTarget:self action:@selector(signOut)];
        signOutBtn.layer.cornerRadius = 20;
        
        signOutBtn.layer.shadowOffset = CGSizeMake(1, 2);
        signOutBtn.layer.shadowColor = SystemColor.CGColor;
        signOutBtn.layer.shadowOpacity = 2;
        signOutBtn.layer.shadowRadius = 5;
        [footerView addSubview:signOutBtn];
        [signOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(footerView).mas_offset(UIEdgeInsetsMake(5, 30, 5, 30));
        }];
        signOutBtn.backgroundColor = SystemColor;
        _tableView.tableFooterView = footerView;
        [footerView addSubview:signOutBtn];
    }
    
}

#pragma mark -- tableView-----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _setingItemList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _setingItemList[section].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"SETTING_CELL"];
    if (!itemCell) {
        itemCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SETTING_CELL"];
        
    }
    NSDictionary *item = _setingItemList[indexPath.section][indexPath.row];
    itemCell.accessoryType = [item[@"accessoryType"] integerValue];
    itemCell.selectionStyle = [item[@"accessoryType"]integerValue] == 1 ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
    itemCell.textLabel.text = item[@"title"];
    itemCell.detailTextLabel.text = item[@"detail"];
    return itemCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = _setingItemList[indexPath.section][indexPath.row];
    SEL selector = NSSelectorFromString(item[@"action"]);
    if (selector && [self respondsToSelector:selector]) {
        [self performSelector:selector withObject:nil afterDelay:0];
    }
}
#pragma mark -- 查看免责声明
- (void)toDisclaimer{
    DisclaimerController *disclaimerController = [[DisclaimerController alloc]init];
    [self.navigationController pushViewController:disclaimerController animated:YES];
    
}
#pragma mark -- 联系我
- (void)toConnectMe {
    //判断用户是否已设置邮件账户
    if ([MFMailComposeViewController canSendMail]) {
        [self sendEmailAction]; // 调用发送邮件的代码
    }else{
        //给出提示,设备未开启邮件服务
        [[[AlertView alloc]initWithText:@"设备未设置邮箱账号，无法发送邮件，是否去设置?" cancelTitle:@"取消" sureTitle:@"去设置" cancelBlock:^(NSInteger index) {
            
        } sureBlock:^(NSInteger index) {
            [[UIApplication sharedApplication]openURL:[NSURL   URLWithString:@"MESSAGE://"]];
        }] show] ;
    }
}
#pragma mark -- 检查更新
- (void)checkUpdate {
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    
    NSDictionary *params = @{
                             @"bundleId":bundleId ? bundleId : @"",
                             @"build":build ? build : @""
                             };
    [HttpHelper GETWithWMH:WMH_APP_UPDATE_CHECK headers:nil parameters:params HUDView:self.view progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
        if ([data[@"status"] isEqualToString:@"B0000"]) {
            if ([data[@"need_update"] integerValue] == 1) {
                //强制
                if ([data[@"forceUpdate"] integerValue] == 1) {
                    dispatch_main_async_safe((^{
                        [[[AlertView alloc]initWithText:[NSString stringWithFormat:@"检查到版本更新\n\n%@",data[@"description"]] buttonTitle:@"立即更新" clickBlock:^(NSInteger index) {
                            [UIApplication.sharedApplication openURL:[NSURL URLWithString:data[@"url"]]];
                        }]show];
                    }))
                    
                    
                } else {
                    dispatch_main_async_safe((^{
                        [[[AlertView alloc]initWithText:[NSString stringWithFormat:@"检查到版本更新\n\n%@",data[@"description"]] cancelTitle:@"暂不更新" sureTitle:@"立即更新" cancelBlock:^(NSInteger index) {
                            
                        } sureBlock:^(NSInteger index) {
                            
                            [UIApplication.sharedApplication openURL:[NSURL URLWithString:data[@"url"]]];
                        }]show];
                    }))
                    
                }
            } else {
                [[ToastView sharedToastView]show:@"暂无可用更新" inView:nil];
            }
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
#ifdef DEBUG
    
#else
    
#endif
}
-(void)sendEmailAction{
    // 创建邮件发送界面
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置收件人
    [mailCompose setToRecipients:@[@"shiwenwendevelop@163.com"]];
    // 设置抄送人
    [mailCompose setCcRecipients:@[@"s13731984233@163.com"]];
    // 设置密送人
//    [mailCompose setBccRecipients:@[@"1152164614@qq.com"]];
    // 设置邮件主题
    [mailCompose setSubject:@"观影天堂"];
    //设置邮件的正文内容
//    NSString *emailContent = @"我是邮件内容";
    // 是否为HTML格式
//    [mailCompose setMessageBody:"" isHTML:NO];
    // 如使用HTML格式，则为以下代码
    // [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    //添加附件
//    UIImage *image = [UIImage imageNamed:@"qq"];
//    NSData *imageData = UIImagePNGRepresentation(image);
//    [mailCompose addAttachmentData:imageData mimeType:@"" fileName:@"qq.png"];
//    NSString *file = [[NSBundle mainBundle] pathForResource:@"EmptyPDF" ofType:@"pdf"];
//    NSData *pdf = [NSData dataWithContentsOfFile:file];
//    [mailCompose addAttachmentData:pdf mimeType:@"" fileName:@"EmptyPDF.pdf"];
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}
#pragma mark -- 分享APP
- (void)shareAPP {
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        if (platformType == 1000) {
            NSString *url = WMH_APP_INATALL;
            NSLog(@"shareURL : %@",url);
            UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
            
            pasteboard.string = url;
            AlertView *alert = [[AlertView alloc]initWithText:[NSString stringWithFormat:@"分享\n\n下载链接\n%@\n已经复制到粘贴板",url] buttonTitle:@"确定" clickBlock:^(NSInteger index) {
                
            }];
            [alert show];
        }else{
            [self shareWebPageToPlatformType:platformType];
        }
        
    }];
    
    
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    

    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"观影天堂-资源齐全的免费视频APP,没有会员也可以看你想看的视频" descr:@"观影天堂，各大视频网站资源应有尽有，免费观看~" thumImage:[UIImage imageNamed:@"icon-qq-512"]];
    //设置网页地址
    
    //                shareObject.webpageUrl = ShareVideo((long)self.videoId);
    shareObject.webpageUrl = WMH_APP_INATALL;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            if (error.code == UMSocialPlatformErrorType_Cancel) {
                [[ToastView sharedToastView]show:[NSString stringWithFormat:@"%@",@"分享取消"] inView:nil];
            }else {
                [[ToastView sharedToastView]show:[NSString stringWithFormat:@"%@",error.userInfo[@"message"]] inView:nil];
            }
            
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                [[ToastView sharedToastView]show:@"分享成功" inView:nil];
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        
        
    }];

    
}
#pragma mark -- 退出登录
- (void)signOut{
    [[[AlertView alloc]initWithText:@"是否退出登录?" cancelTitle:@"退出登录" sureTitle:@"取消" cancelBlock:^(NSInteger index) {
        [HttpHelper GETWithWMH:WMH_SIGN_OUT headers:nil parameters:nil HUDView:nil progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
            [[ToastView sharedToastView] show:data[@"txt"] inView:nil];
            if ([data[@"status"] isEqualToString:@"B0000"]) {
                _tableView.tableFooterView = nil;
                [UserInfo clean];
                [UserInfo resetOptions];
            }
        } failure:^(NSError * _Nullable error) {
            
        }];
    } sureBlock:^(NSInteger index) {
       
    }]show];
    
}
#pragma mark - MFMailComposeViewControllerDelegate的代理方法：
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled: 用户取消编辑");
            [[ToastView sharedToastView]show:@"已取消编辑" inView:nil];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: 用户保存邮件");
            [[ToastView sharedToastView]show:@"邮件已保存" inView:nil];
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent: 用户点击发送");
            [[ToastView sharedToastView]show:@"邮件已发送" inView:nil];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@ : 用户尝试保存或发送邮件失败", [error localizedDescription]);
            [[ToastView sharedToastView]show:@"保存或发送邮件失败" inView:nil];
            break;
    }
    // 关闭邮件发送视图
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
