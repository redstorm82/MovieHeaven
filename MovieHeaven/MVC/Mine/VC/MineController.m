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
#import "Tools.h"
#import "VideoCollectionController.h"
#import "HistoryListController.h"
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
}
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent) animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UserInfo *user = [UserInfo read];
    if (user) {
        _headerView.backgroundColor = SystemColor;
        if (user.avatar) {
            [_headerView.avatarImgBtn yy_setBackgroundImageWithURL:[NSURL URLWithString:user.avatar] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"header"]];
            
        }
        _headerView.nameLabel.text = user.nickName;
        _headerView.accumulatedPointsLabel.text = [NSString stringWithFormat:@"积分:%ld",(long)user.accumulatedPoints];
        [self requestInfo];
    }else{
        
        [_headerView.avatarImgBtn setBackgroundImage:[UIImage imageNamed:@"header_gray"] forState:UIControlStateNormal];
        _headerView.backgroundColor = KD9Color;
        _headerView.nameLabel.text = @"未登录";
    }
    if (!UserDefaultsGet(@"accumulatedPoints")) {
        [[[AlertView alloc]initWithText:@"新增积分功能\n\n观看视频,对视频进行评论就可以获得积分，积分在未来版本可以兑换相应权益" buttonTitle:@"知道了" clickBlock:^(NSInteger index) {
            UserDefaultsSet(@(true), @"accumulatedPoints");
        }]show];
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
    [_headerView.accumulatedPointsLabel.superview addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(howToGetAccumulatedPoints)]];
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, FIT_SCREEN_HEIGHT(230))];
    [tableHeaderView addSubview:_headerView];
    [_headerView.avatarImgBtn addTarget:self action:@selector(clickHeader) forControlEvents:UIControlEventTouchUpInside];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableHeaderView);
    }];
    
    WXWaveView *waveView = [WXWaveView addToView:tableHeaderView withFrame:CGRectMake(0, tableHeaderView.height - FIT_SCREEN_HEIGHT(10), kScreenWidth, FIT_SCREEN_HEIGHT(10))];
    waveView.waveTime = 0;
    waveView.waveSpeed = 5.f;
    waveView.alpha = 0.9;
    [waveView wave];
    WXWaveView *alph08aWave = [WXWaveView addToView:tableHeaderView withFrame:waveView.frame];
    alph08aWave.waveTime = 0;
    alph08aWave.waveSpeed = 6.f;
    alph08aWave.alpha = 0.7;
    alph08aWave.angularSpeed = 2.f;
    [alph08aWave wave];
    alph08aWave.frame = CGRectMake(0, tableHeaderView.height - FIT_SCREEN_HEIGHT(12), kScreenWidth, FIT_SCREEN_HEIGHT(12));
    [tableHeaderView addSubview:alph08aWave];
    
    WXWaveView *alpha05Wave = [WXWaveView addToView:tableHeaderView withFrame:waveView.frame];
    alpha05Wave.waveTime = 0;
    alpha05Wave.waveSpeed = 4.f;
    alpha05Wave.alpha = 0.5;
    alpha05Wave.angularSpeed = 3.f;
    [alpha05Wave wave];
    [tableHeaderView addSubview:alpha05Wave];
    alph08aWave.frame = CGRectMake(0, tableHeaderView.height - FIT_SCREEN_HEIGHT(14), kScreenWidth, FIT_SCREEN_HEIGHT(14));
    [tableHeaderView addSubview:waveView];
    
    _tableView.tableHeaderView = tableHeaderView;
}
- (void)requestInfo {
    
    [HttpHelper GETWithWMH:WMH_USER_INFO headers:nil parameters:nil HUDView:nil progress:^(NSProgress * _Nonnull progress) {
 
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
        if ([data[@"status"] isEqualToString:@"B0000"]) {
            NSDictionary *userInfo = data[@"userInfo"];
            UserInfo *user = [[UserInfo alloc]initWithDictionary:userInfo error:nil];
            [user save];
//            [Tools saveCookie];
            _headerView.backgroundColor = SystemColor;
            if (user.avatar) {
                [_headerView.avatarImgBtn yy_setBackgroundImageWithURL:[NSURL URLWithString:user.avatar] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"header"]];
                
            }
            _headerView.nameLabel.text = user.nickName;
            _headerView.accumulatedPointsLabel.text = [NSString stringWithFormat:@"积分:%ld",(long)user.accumulatedPoints];
        }else{
            
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
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
        VideoCollectionController *videoCollectionVC = [[VideoCollectionController alloc]init];
        [self.navigationController pushViewController:videoCollectionVC animated:YES];
    }
}
#pragma mark -- 历史
- (void)toHistory {
    if ([self checkLogin]) {
        HistoryListController *historyListController = [[HistoryListController alloc]init];
        [self.navigationController pushViewController:historyListController animated:YES];
    }
}
#pragma mark -- 设置
- (void)toSetting {
    SettingController *settingVC = [[SettingController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}
#pragma mark -- 怎样获取积分
- (void)howToGetAccumulatedPoints {
    [[[AlertView alloc]initWithText:@"如何获取积分？\n观看视频,对视频进行评论就可以获得积分，积分在未来版本可以兑换相应权益" buttonTitle:@"知道了" clickBlock:^(NSInteger index) {
        
    }]show];
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
