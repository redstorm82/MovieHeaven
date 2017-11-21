//
//  VideoCollectionController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/15.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "VideoCollectionController.h"
#import "VideoCollectCell.h"
#import "EmptyView.h"
#import "VideoDetailController.h"
#import <Masonry.h>
#import "UITools.h"
static const NSInteger PageSize = 20;
static NSString *VideoCollectCellId = @"VideoCollectCell";
@interface VideoCollectionController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    EmptyView *_emptyView;
    NSUInteger _page;
    NSMutableArray <CollectionModel *> *_collests;
    
}

@end

@implementation VideoCollectionController
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
    self.title = @"我的收藏";
    [self createUI];
    [self initData];
    [self requestCollects:YES];
}

#pragma mark -- 初始化数据
- (void)initData{
    _page = 0;
    _collests = @[].mutableCopy;
    
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
    [_tableView registerNib:[UINib nibWithNibName:@"VideoCollectCell" bundle:nil] forCellReuseIdentifier:VideoCollectCellId];
    _tableView.separatorColor = KECColor;
    _tableView.mj_header = [UITool MJRefreshGifHeaderWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        strongSelf->_page = 0;
        [strongSelf requestCollects:NO];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestCollects:NO];
    }];
    _emptyView = [[EmptyView alloc]initWithFrame:_tableView.bounds icon:nil tip:@"还没有收藏任何视频哦╮(￣▽￣)╭" tapBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestCollects:YES];
    }];
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf.view);
    }];
    
//    _emptyView.hidden = YES;
}

- (void)requestCollects:(BOOL)showHUD {
    _emptyView.tip = EmptyLoadingTip;
    [HttpHelper GETWithWMH:WMH_COLLECTION_LIST headers:nil parameters:@{@"pageNum":@(_page),@"pageSize":@(PageSize)} HUDView:showHUD ? self.view : nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *data) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (![data[@"status"] isEqualToString:@"B0000"]) {
            [[ToastView sharedToastView]show:data[@"txt"] inView:nil];
            _emptyView.tip = EmptyDefaultTip;
        }else{
            
            NSArray *collects = data[@"collects"];
            if (_page == 0) {
                [_collests removeAllObjects];
            }
            
            
            for (NSDictionary *collect in collects) {
                CollectionModel *model = [[CollectionModel alloc]initWithDictionary:collect error:nil];
                [_collests addObject:model];
            }
            if (collects.count < PageSize) {
                dispatch_main_async_safe(^{
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                })
                
            }
            [_tableView reloadData];
            _emptyView.tip = @"还没有收藏任何视频哦╮(￣▽￣)╭";
            _emptyView.hidden = _collests.count > 0;
            _page ++ ;
        }
        
    } failure:^(NSError *error) {
        _emptyView.tip = EmptyDefaultTip;
        _emptyView.hidden = _collests.count > 0;
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

#pragma mark -- tableView-----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _collests.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoCollectCellId forIndexPath:indexPath];
    cell.model = _collests[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CollectionModel *model = _collests[indexPath.row];
    VideoDetailController *videoDetail = [[VideoDetailController alloc]init];
    videoDetail.videoId = model.videoId;
    videoDetail.videoName = model.videoName;
    videoDetail.collectStateChange = ^{
        [_tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:videoDetail animated:YES];
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"取消收藏";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CollectionModel *model = _collests[indexPath.row];
        NSDictionary *data = @{
                               @"cid": @(model.cid),
                               };

        [HttpHelper POSTWithWMH:WMH_COLLECT_CANCEL headers:nil parameters:data HUDView:self.view progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
            [[ToastView sharedToastView] show:data[@"txt"] inView:nil];
            if ([data[@"status"] isEqualToString:@"B0000"]) {
                [_collests removeObject:model];
                dispatch_main_async_safe(^{
                    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
                    _emptyView.hidden = _collests.count > 0;
                })
            }else {
                
            }
        } failure:^(NSError * _Nullable error) {
            
        }];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
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
