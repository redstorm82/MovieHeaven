//
//  DouListInfoItemController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/8.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "DouListInfoItemController.h"


#import <Masonry.h>
#import "UITools.h"
#import "EmptyView.h"
#import "DouListInfoCell.h"
#import "DouListItemCell.h"
#import "VideoDetailController.h"
static const NSInteger PageSize = 20;

static NSString *DouListItemCellId = @"DouListItemCell";
static NSString *DouListInfoCellId = @"DouListInfoCell";

@interface DouListInfoItemController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    EmptyView *_emptyView;
    NSUInteger _page;
    NSMutableArray <DouListItemModel *> *_douListItemData;
    DouListInfoModel *_infoModel;
}

@end

@implementation DouListInfoItemController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createUI];
    [self initData];
    [self requestInfo];
    [self requestDouListItem:YES];
}

#pragma mark -- 初始化数据
- (void)initData{
    _page = 1;
    _douListItemData = @[].mutableCopy;
    
}
#pragma mark -- 创建UI
- (void)createUI{
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [UIView new];
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
    [_tableView registerNib:[UINib nibWithNibName:@"DouListInfoCell" bundle:nil] forCellReuseIdentifier:DouListInfoCellId];
    [_tableView registerNib:[UINib nibWithNibName:@"DouListItemCell" bundle:nil] forCellReuseIdentifier:DouListItemCellId];
    _tableView.separatorColor = KECColor;
    _tableView.mj_header = [UITool MJRefreshGifHeaderWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        strongSelf->_page = 1;
        [strongSelf requestInfo];
        [strongSelf requestDouListItem:NO];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestDouListItem:NO];
    }];
    _emptyView = [[EmptyView alloc]initWithFrame:_tableView.bounds icon:nil tip:nil tapBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestDouListItem:YES];
    }];
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf.view);
    }];
    
    _emptyView.hidden = YES;
}
- (void)requestInfo {
    [HttpHelper GET:DouListInfo headers:nil parameters:@{@"id":@(self.douId)} HUDView:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *response) {
        if ([response[@"code"]integerValue] != 0) {
            [[ToastView sharedToastView]show:response[@"message"] inView:nil];
        }else{
            _infoModel = [[DouListInfoModel alloc]initWithDictionary:response[@"body"] error:nil];
            dispatch_main_async_safe(^{
                self.title = _infoModel.title;
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            })
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)requestDouListItem:(BOOL)showHUD {
    
    [HttpHelper GET:DouListItem headers:nil parameters:@{@"page":@(_page),@"pageSize":@(PageSize),@"id":@(self.douId)} HUDView:showHUD ? self.view : nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *response) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if ([response[@"code"]integerValue] != 0) {
            [[ToastView sharedToastView]show:response[@"message"] inView:nil];
        }else{
            
            NSArray *doubanList = response[@"body"];
            if (_page == 1) {
                [_douListItemData removeAllObjects];
            }
            
            
            for (NSDictionary *douban in doubanList) {
                DouListItemModel *model = [[DouListItemModel alloc]initWithDictionary:douban error:nil];
                [_douListItemData addObject:model];
            }
            if (doubanList.count < PageSize) {
                dispatch_main_async_safe(^{
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                })
                
            }
            [_tableView reloadData];
            _emptyView.hidden = _douListItemData.count > 0;
            _page ++ ;
        }
        
    } failure:^(NSError *error) {
        _emptyView.hidden = _douListItemData.count > 0;
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

#pragma mark -- tableView-----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return _douListItemData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        DouListInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:DouListInfoCellId forIndexPath:indexPath];
        cell.model = _infoModel;
        return cell;
    }
    DouListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:DouListItemCellId forIndexPath:indexPath];
    cell.model = _douListItemData[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VideoDetailController *detailVC = [[VideoDetailController alloc]init];
    DouListItemModel *model = _douListItemData[indexPath.row];
    detailVC.videoId = model.movieId;
    detailVC.videoName = model.name;
    detailVC.from = @"doulist";
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

@end
