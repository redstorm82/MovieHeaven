//
//  MoreDoubanTopicController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/8.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "MoreDoubanTopicController.h"
#import <Masonry.h>
#import "UITools.h"
#import "EmptyView.h"
#import "VideoSectionCell.h"
#import "TopDouBanMoreController.h"

static const NSInteger PageSize = 20;
static NSString *VideoSectionCellId = @"VideoSectionCell";

@interface MoreDoubanTopicController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    EmptyView *_emptyView;
    NSUInteger _page;
    NSMutableArray <TopSubjectsModel *> *_doubanTopicList;
    
}

@end

@implementation MoreDoubanTopicController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"更多榜单";
    [self createUI];
    [self initData];
    [self requestTop:YES];
}

#pragma mark -- 初始化数据
- (void)initData{
    _page = 1;
    _doubanTopicList = @[].mutableCopy;
    
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
    _tableView.separatorColor = KECColor;
    _tableView.mj_header = [UITool MJRefreshGifHeaderWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        strongSelf->_page = 1;
        [strongSelf requestTop:NO];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
    
    _emptyView.hidden = YES;
}

- (void)requestTop:(BOOL)showHUD {
    
    [HttpHelper GET:MoreDoubanTopicList headers:nil parameters:@{@"page":@(_page),@"pageSize":@(PageSize)} HUDView:showHUD ? self.view : nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *response) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if ([response[@"code"]integerValue] != 0) {
            [[ToastView sharedToastView]show:response[@"message"] inView:nil];
        }else{
            
            NSArray *doubanTopicList = response[@"body"];
            if (_page == 1) {
                [_doubanTopicList removeAllObjects];
            }
            
            
            for (NSDictionary *douban in doubanTopicList) {
                TopSubjectsModel *model = [[TopSubjectsModel alloc]initWithDictionary:douban error:nil];
                [_doubanTopicList addObject:model];
            }
            if (doubanTopicList.count < PageSize) {
                dispatch_main_async_safe(^{
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                })
                
            }
            [_tableView reloadData];
            _emptyView.hidden = _doubanTopicList.count > 0;
            _page ++ ;
        }
        
    } failure:^(NSError *error) {
        _emptyView.hidden = _doubanTopicList.count > 0;
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

#pragma mark -- tableView-----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _doubanTopicList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoSectionCellId forIndexPath:indexPath];
    cell.topSubjectsModel = _doubanTopicList[indexPath.section];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = _doubanTopicList[indexPath.section].subjects.count;
    NSInteger row = count / 3 + (count % 3 == 0 ? 0 : 1);
    CGFloat height = row * VideoItemHeight + 10 * (row + 1);
    return height;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerSecView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerSecView.backgroundColor = KECColor;
    UILabel *titleLabel = [LabelTool createLableWithFrame:CGRectMake(KContentEdge, 0, kScreenWidth - KContentEdge * 2, 40) textColor:K33Color font:[UIFont boldSystemFontOfSize:17]];
    [headerSecView addSubview:titleLabel];
    titleLabel.text = _doubanTopicList[section].name;
    return headerSecView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerSecView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    footerSecView.backgroundColor = [UIColor whiteColor];
    
    
    TO_WEAK(self, weakSelf)
    UIButton *moreButton = [ButtonTool createBlockButtonWithTitle:@"更多" titleColor:[UIColor whiteColor] titleFont:[UIFont boldSystemFontOfSize:16] block:^(UIButton *button) {
        TO_WEAK(weakSelf, strongSelf)
        TopDouBanMoreController *moreVC = [[TopDouBanMoreController alloc]init];
        moreVC.title = _doubanTopicList[section].name;
        moreVC.moreId = _doubanTopicList[section].id;
        [strongSelf.navigationController pushViewController:moreVC animated:YES];
        
    }];
    moreButton.layer.borderWidth = 0.5;
    [moreButton setCornerRadius:3];
    moreButton.backgroundColor = SystemColor;
    moreButton.layer.borderColor = KD9Color.CGColor;
    moreButton.frame = CGRectMake(KContentEdge, 7.5, kScreenWidth - KContentEdge * 2, 30);
    [footerSecView addSubview:moreButton];
    
    return footerSecView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
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
