//
//  MineController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/12.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "MineController.h"
#import <Masonry.h>
#import "MineHeaderView.h"
#import <WXWaveView.h>
#import "LoginController.h"
#import <UIButton+YYWebImage.h>
#import "AlertView.h"
#import "SettingController.h"
@interface MineController () <UITableViewDelegate, UITableViewDataSource>{
    
    UITableView *_tableView;
    NSArray <NSArray<NSDictionary *> *> *_mineItemList;
    MineHeaderView *_headerView;
}

@end

@implementation MineController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self initData];
    [self requestInfo:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent) animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    UserInfo *user = [UserInfo read];
    if (user) {
        _headerView.backgroundColor = SystemColor;
        if (user.avatar) {
            [_headerView.avatarImgBtn yy_setBackgroundImageWithURL:[NSURL URLWithString:user.avatar] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"header"]];

        }
        _headerView.nameLabel.text = user.nickName;
    }else{

        [_headerView.avatarImgBtn setBackgroundImage:[UIImage imageNamed:@"header_gray"] forState:UIControlStateNormal];
        _headerView.backgroundColor = KD9Color;
        _headerView.nameLabel.text = @"未登录";
    }
    
    
    
}
#pragma mark -- 初始化数据
- (void)initData{
    
    _mineItemList = @[
                      @[@{
                          @"title":@"我的收藏",
                          @"icon":@"collect_icon",
                          @"detail":@"",
                          @"action":@"toCollect",
                          @"accessoryType":@(1)
                          },
                        @{
                            @"title":@"观看记录",
                            @"icon":@"history_icon",
                            @"detail":@"",
                            @"action":@"toHistory",
                            @"accessoryType":@(1)
                            },],
                      @[@{
                            @"title":@"设置",
                            @"icon":@"setting_icon",
                            @"detail":@"",
                            @"action":@"toSetting",
                            @"accessoryType":@(1)
                            },],
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
    [self createHeader];
    
}

- (void)createHeader {
    _headerView = [[NSBundle mainBundle]loadNibNamed:@"MineHeaderView" owner:nil options:nil].firstObject;
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, FIT_SCREEN_HEIGHT(230))];
    [tableHeaderView addSubview:_headerView];
    [_headerView.avatarImgBtn addTarget:self action:@selector(clickHeader) forControlEvents:UIControlEventTouchUpInside];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableHeaderView);
    }];
    
    WXWaveView *waveView = [WXWaveView addToView:tableHeaderView withFrame:CGRectMake(0, tableHeaderView.height - FIT_SCREEN_HEIGHT(10), kScreenWidth, FIT_SCREEN_HEIGHT(10))];
    [tableHeaderView addSubview:waveView];
    waveView.waveTime = 0;
    waveView.waveSpeed = 5.f;
    [waveView wave];
    _tableView.tableHeaderView = tableHeaderView;
}
- (void)requestInfo:(BOOL)showHUD {
    
    
}

#pragma mark -- tableView-----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _mineItemList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mineItemList[section].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"MINE_CELL"];
    if (!itemCell) {
        itemCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MINE_CELL"];
        
    }
    NSDictionary *item = _mineItemList[indexPath.section][indexPath.row];
    itemCell.accessoryType = [item[@"accessoryType"] integerValue];
    itemCell.selectionStyle = [item[@"accessoryType"]integerValue] == 1 ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
    itemCell.imageView.image = [UIImage imageNamed:item[@"icon"]];
    itemCell.textLabel.text = item[@"title"];
    itemCell.detailTextLabel.text = item[@"detail"];
    return itemCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = _mineItemList[indexPath.section][indexPath.row];
    SEL selector = NSSelectorFromString(item[@"action"]);
    if (selector && [self respondsToSelector:selector]) {
        [self performSelector:selector withObject:nil afterDelay:0];
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointZero;
    }
}
#pragma mark -- 检查登录
- (BOOL)checkLogin{
    if ([UserInfo read]) {
        return YES;
    }
    LoginController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"LoginController"];
    loginVC.completion = ^(UserInfo *user) {
        
    };
    [self presentViewController:loginVC animated:YES completion:NULL];
    return NO;
}
- (void)clickHeader {
    if ([self checkLogin]) {
        [[[AlertView alloc]initWithText:@"是否从QQ更新信息?" cancelTitle:@"取消" sureTitle:@"确定" cancelBlock:^(NSInteger index) {
            
        } sureBlock:^(NSInteger index) {
            LoginController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"LoginController"];
            loginVC.completion = ^(UserInfo *user) {
                
            };
            [self presentViewController:loginVC animated:YES completion:NULL];
        }] show];
    }
}
#pragma mark -- 去收藏
- (void)toCollect {
    
    if ([self checkLogin]) {
        
    }
}
#pragma mark -- 历史
- (void)toHistory {
    if ([self checkLogin]) {
        
    }
}
#pragma mark -- 设置
- (void)toSetting {
    if ([self checkLogin]) {
        SettingController *settingVC = [[SettingController alloc]init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}
- (void)emptyMethod {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
