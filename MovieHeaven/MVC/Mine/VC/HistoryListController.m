//
//  HistoryListController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/16.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "HistoryListController.h"
#import "EmptyView.h"
#import "VideoDetailController.h"
#import <Masonry.h>
#import "UITools.h"
#import "HistoryCell.h"
static const NSInteger PageSize = 20;
static NSString *HistoryCellId = @"HistoryCell";
@interface HistoryListController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    EmptyView *_emptyView;
    NSUInteger _page;
    NSMutableArray <HistoryModel *> *_historyList;
    
}

@end

@implementation HistoryListController
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
    self.title = @"观看记录";
    [self createUI];
    [self initData];
    [self requestHistoryList:YES];
}

#pragma mark -- 初始化数据
- (void)initData{
    _page = 0;
    _historyList = @[].mutableCopy;
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if (self.navigationController.viewControllers.count > 2) {
//        [self requestHistoryList:NO];
//    }
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
    [_tableView registerNib:[UINib nibWithNibName:@"HistoryCell" bundle:nil] forCellReuseIdentifier:HistoryCellId];
    _tableView.separatorColor = KECColor;
    _tableView.mj_header = [UITool MJRefreshGifHeaderWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        strongSelf->_page = 0;
        [strongSelf requestHistoryList:NO];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestHistoryList:NO];
    }];
    _emptyView = [[EmptyView alloc]initWithFrame:_tableView.bounds icon:nil tip:@"还没有任何观看记录哦╮(￣▽￣)╭" tapBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestHistoryList:YES];
    }];
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf.view);
    }];
    
    //    _emptyView.hidden = YES;
}

- (void)requestHistoryList:(BOOL)showHUD {
    _emptyView.tip = EmptyLoadingTip;
    [HttpHelper GETWithWMH:WMH_HISTORY_LIST headers:nil parameters:@{@"pageNum":@(_page),@"pageSize":@(PageSize)} HUDView:showHUD ? self.view : nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *data) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (![data[@"status"] isEqualToString:@"B0000"]) {
            [[ToastView sharedToastView]show:data[@"txt"] inView:nil];
            _emptyView.tip = EmptyDefaultTip;
        }else{
            
            NSArray *historyList = data[@"historyList"];
            if (_page == 0) {
                [_historyList removeAllObjects];
            }
            
            
            for (NSDictionary *history in historyList) {
                HistoryModel *model = [[HistoryModel alloc]initWithDictionary:history error:nil];
                [_historyList addObject:model];
            }
            if (historyList.count < PageSize) {
                dispatch_main_async_safe(^{
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                })
                
            }
            [_tableView reloadData];
            _emptyView.tip = @"还没有任何观看记录哦╮(￣▽￣)╭";
            _emptyView.hidden = _historyList.count > 0;
            _page ++ ;
        }
        
    } failure:^(NSError *error) {
        _emptyView.tip = EmptyDefaultTip;
        _emptyView.hidden = _historyList.count > 0;
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

#pragma mark -- tableView-----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _historyList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:HistoryCellId forIndexPath:indexPath];
    cell.model = _historyList[indexPath.row];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __block HistoryModel *model = _historyList[indexPath.row];
    VideoDetailController *videoDetail = [[VideoDetailController alloc]init];
    __block NSIndexPath *blockIndexPath = indexPath;
    videoDetail.videoId = model.videoId;
    videoDetail.videoName = model.videoName;
    videoDetail.historyUpdate = ^(NSString *partName, NSTimeInterval playingTime) {
        model.playingTime = playingTime;
        model.partName = partName;
        dispatch_main_async_safe(^{
            [_tableView reloadRowsAtIndexPaths:@[blockIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        });
    };
    [self.navigationController pushViewController:videoDetail animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除记录";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HistoryModel *model = _historyList[indexPath.row];
        NSDictionary *data = @{
                               @"hid": @(model.hid),
                               };
        
        [HttpHelper POSTWithWMH:WMH_HISTORY_DELETE headers:nil parameters:data HUDView:self.view progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
            [[ToastView sharedToastView] show:data[@"txt"] inView:nil];
            if ([data[@"status"] isEqualToString:@"B0000"]) {
                [_historyList removeObject:model];
                dispatch_main_async_safe(^{
                    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
                    _emptyView.hidden = _historyList.count > 0;
                })
                
            }else {
                
            }
        } failure:^(NSError * _Nullable error) {
            
        }];
    }
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
