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
                            },]
                        
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
