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
@interface SettingController () <UITableViewDelegate, UITableViewDataSource>{
    
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
                            @"title":@"版本号",
                            @"detail":[NSString stringWithFormat:@"v%@",APP_VERSION],
                            @"accessoryType":@(0),
                            @"action":@""
                            },],
                        @[@{
                              @"title":@"免责声明",
                              @"detail":@"点击查看",
                              @"accessoryType":@(1),
                              @"action":@"toDisclaimer"
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
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        
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
#pragma mark -- 退出登录
- (void)signOut{
    
}

@end
