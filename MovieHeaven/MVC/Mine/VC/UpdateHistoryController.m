//
//  UpdateHistoryController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/22.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "UpdateHistoryController.h"
#import "EmptyView.h"
#import <Masonry.h>
#import "UITools.h"
#import "UpdateHistoryCell.h"
static const NSInteger PageSize = 20;
static NSString *UpdateHistoryCellId = @"UpdateHistoryCell";
@interface UpdateHistoryController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    EmptyView *_emptyView;
    NSUInteger _page;
    NSMutableArray <UpdateHistoryModel *> *_historyList;
    
}

@end

@implementation UpdateHistoryController
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
    self.title = @"更新记录";
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
    _tableView.estimatedRowHeight = 91;
    [_tableView registerNib:[UINib nibWithNibName:@"UpdateHistoryCell" bundle:nil] forCellReuseIdentifier:UpdateHistoryCellId];
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
    _emptyView = [[EmptyView alloc]initWithFrame:_tableView.bounds icon:nil tip:EmptyLoadingTip tapBlock:^{
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
    NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    [HttpHelper GETWithWMH:WMH_APP_UPDATE_HISTORY headers:nil parameters:@{@"pageNum":@(_page),@"pageSize":@(PageSize),@"bundleId":bundleId ? bundleId : @""} HUDView:showHUD ? self.view : nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *data) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (![data[@"status"] isEqualToString:@"B0000"]) {
            [[ToastView sharedToastView]show:data[@"txt"] inView:nil];
            _emptyView.tip = EmptyDefaultTip;
        }else{
            
            NSArray *historyList = data[@"update_history"];
            if (_page == 0) {
                [_historyList removeAllObjects];
            }
            
            
            for (NSDictionary *history in historyList) {
                UpdateHistoryModel *model = [[UpdateHistoryModel alloc]initWithDictionary:history error:nil];
                [_historyList addObject:model];
            }
            if (historyList.count < PageSize) {
                dispatch_main_async_safe(^{
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                })
                
            }
            [_tableView reloadData];
            _emptyView.tip = @"还没有任何更新记录哦╮(￣▽￣)╭";
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
    
    UpdateHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:UpdateHistoryCellId forIndexPath:indexPath];
    cell.model = _historyList[indexPath.row];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


@end
