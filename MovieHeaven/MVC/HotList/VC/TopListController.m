//
//  TopListController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/7.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "TopListController.h"
#import <Masonry.h>
#import "UITools.h"
#import "EmptyView.h"
#import "VideoSectionCell.h"
#import "TopDoubanCell.h"
#import "TopDouBanMoreController.h"
#import "MoreDoubanTopicController.h"
#import "MoreDoulistController.h"
#import "DouListInfoItemController.h"
static NSString *VideoSectionCellId = @"VideoSectionCell";
static NSString *TopDoubanCellId = @"TopDoubanCell";

@interface TopListController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    EmptyView *_emptyView;
    
    NSMutableArray <TopDoubanModel *> *_doubanList;
    NSMutableArray <TopSubjectsModel *> *_doubanTopicList;
    NSMutableArray <TopVideoItemModel> *_suggestions;
}

@end

@implementation TopListController
-(void)awakeFromNib{
    [super awakeFromNib];
    self.arrowType = noArrow;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"榜单";
    [self createUI];
    [self initData];
    [self requestTop:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault) animated:NO];
}
#pragma mark -- 初始化数据
- (void)initData{
    
    _doubanList = @[].mutableCopy;
    _doubanTopicList = @[].mutableCopy;
    _suggestions = @[].mutableCopy;
}
#pragma mark -- 创建UI
- (void)createUI{
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
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
    [_tableView registerClass:[VideoSectionCell class] forCellReuseIdentifier:VideoSectionCellId];
    [_tableView registerNib:[UINib nibWithNibName:@"TopDoubanCell" bundle:nil] forCellReuseIdentifier:TopDoubanCellId];
    _tableView.separatorColor = KECColor;
    _tableView.mj_header = [UITool MJRefreshGifHeaderWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestTop:NO];
    }];
    
    _emptyView = [[EmptyView alloc]initWithFrame:_tableView.bounds icon:nil tip:nil tapBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestTop:YES];
    }];
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf.view);
    }];
    
//    _emptyView.hidden = YES;
}

- (void)requestTop:(BOOL)showHUD {
    _emptyView.tip = EmptyLoadingTip;
    [HttpHelper GET:TopIndex headers:nil parameters:nil HUDView:showHUD ? self.view : nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *response) {
        _emptyView.tip = EmptyDefaultTip;
        if ([response[@"code"]integerValue] != 0) {
            [[ToastView sharedToastView]show:response[@"message"] inView:nil];
            _emptyView.hidden = NO;
        }else{
            _emptyView.hidden = YES;
            
            NSDictionary *body = response[@"body"];
            NSArray *doubanList = body[@"doubanList"];
            NSArray *doubanTopicList = body[@"doubanTopicList"];
            NSArray *suggestions = body[@"suggestions"];
            
            [_doubanList removeAllObjects];
            [_suggestions removeAllObjects];
            [_doubanTopicList removeAllObjects];
            
            for (NSDictionary *douban in doubanList) {
                TopDoubanModel *model = [[TopDoubanModel alloc]initWithDictionary:douban error:nil];
                [_doubanList addObject:model];
            }
            for (NSDictionary *douban in doubanTopicList) {
                TopSubjectsModel *model = [[TopSubjectsModel alloc]initWithDictionary:douban error:nil];
                [_doubanTopicList addObject:model];
            }
            for (NSDictionary *suggestion in suggestions) {
                TopVideoItemModel *model = [[TopVideoItemModel alloc]initWithDictionary:suggestion error:nil];
                [_suggestions addObject:model];
            }
            
            [_tableView reloadData];
        }
        
        
        [_tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        _emptyView.tip = EmptyDefaultTip;
        _emptyView.hidden = NO;
        [_tableView.mj_header endRefreshing];
    }];
}

#pragma mark -- tableView-----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _doubanTopicList.count + (_suggestions.count > 0 ? 1 : 0) + (_doubanList.count > 0 ? 1 : 0);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section < _doubanTopicList.count) {
        return 1;
    }else if (section == _doubanTopicList.count) {
        return 1;
    }else {
        return _doubanList.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section < _doubanTopicList.count) {
        VideoSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoSectionCellId forIndexPath:indexPath];
        cell.topSubjectsModel = _doubanTopicList[indexPath.section];
        return cell;
    }else if (indexPath.section == _doubanTopicList.count) {
        VideoSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoSectionCellId forIndexPath:indexPath];
        TopSubjectsModel *model = [[TopSubjectsModel alloc]init];
        model.subjects = _suggestions;
        cell.topSubjectsModel = model;
        return cell;
    }else {
        TopDoubanCell *cell = [tableView dequeueReusableCellWithIdentifier:TopDoubanCellId forIndexPath:indexPath];
        cell.model = _doubanList[indexPath.row];
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < _doubanTopicList.count) {
        NSInteger count = _doubanTopicList[indexPath.section].subjects.count;
        NSInteger row = count / 3 + (count % 3 == 0 ? 0 : 1);
        CGFloat height = row * VideoItemHeight + 10 * (row + 1);
        return height;
    }else if (indexPath.section == _doubanTopicList.count) {
        NSInteger count = _suggestions.count;
        NSInteger row = count / 3 + (count % 3 == 0 ? 0 : 1);
        CGFloat height = row * VideoItemHeight + 10 * (row + 1);
        return height;
    }else {
        return 100;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerSecView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerSecView.backgroundColor = KF7Color;
    UILabel *titleLabel = [LabelTool createLableWithFrame:CGRectMake(KContentEdge, 0, kScreenWidth - KContentEdge * 2, 40) textColor:K33Color font:[UIFont boldSystemFontOfSize:17]];
    [headerSecView addSubview:titleLabel];
    
    if (section < _doubanTopicList.count) {
        titleLabel.text = _doubanTopicList[section].name;
    }else if (section == _doubanTopicList.count) {
        titleLabel.text = @"你可能感兴趣";
    }else {
        titleLabel.text = @"发现好电影";
    }
    
    return headerSecView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerSecView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    footerSecView.backgroundColor = [UIColor whiteColor];
    
    
    TO_WEAK(self, weakSelf)
    UIButton *moreButton = [ButtonTool createBlockButtonWithTitle:@"更多" titleColor:[UIColor whiteColor] titleFont:[UIFont boldSystemFontOfSize:16] block:^(UIButton *button) {
        TO_WEAK(weakSelf, strongSelf)
        if (section < _doubanTopicList.count) {
            TopDouBanMoreController *moreVC = [[TopDouBanMoreController alloc]init];
            moreVC.title = _doubanTopicList[section].name;
            moreVC.moreId = _doubanTopicList[section].id;
            [strongSelf.navigationController pushViewController:moreVC animated:YES];
        }else if (section == _doubanTopicList.count) {
            MoreDoubanTopicController *moreDoubanTopicController = [[MoreDoubanTopicController alloc]init];
            [strongSelf.navigationController pushViewController:moreDoubanTopicController animated:YES];
            
        }else {
            MoreDoulistController *moreDoulistController = [[MoreDoulistController alloc]init];
            [strongSelf.navigationController pushViewController:moreDoulistController animated:YES];
            
        }
       
    }];
    if (section == _doubanTopicList.count) {
        [moreButton setTitle:@"更多榜单" forState:(UIControlStateNormal)];
    }
    moreButton.layer.borderWidth = 0.5;
    [moreButton setCornerRadius:3];
    moreButton.backgroundColor = SystemColor;
    moreButton.layer.borderColor = KD9Color.CGColor;
    moreButton.frame = CGRectMake(KContentEdge, 7.5, kScreenWidth - KContentEdge * 2, 30);
    [footerSecView addSubview:moreButton];
    
    return footerSecView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section > _doubanTopicList.count) {
        DouListInfoItemController *douListInfoItemController = [[DouListInfoItemController alloc]init];
        TopDoubanModel *model = _doubanList[indexPath.row];
        douListInfoItemController.douId = model.id;
        douListInfoItemController.title = model.title;
        [self.navigationController pushViewController:douListInfoItemController animated:YES];
    }
}
#pragma mark -- 线偏移
- (void)viewDidLayoutSubviews {
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
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
