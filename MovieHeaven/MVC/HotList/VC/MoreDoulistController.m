//
//  MoreDoulistController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/8.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "MoreDoulistController.h"

#import <Masonry.h>
#import "UITools.h"
#import "EmptyView.h"
#import "TopDoubanCell.h"
#import "DouListInfoItemController.h"
static const NSInteger PageSize = 20;

static NSString *TopDoubanCellId = @"TopDoubanCell";
@interface MoreDoulistController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    EmptyView *_emptyView;
    NSUInteger _page;
    NSMutableArray <TopDoubanModel *> *_doubanList;
    
}

@end

@implementation MoreDoulistController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"影集";
    [self createUI];
    [self initData];
    [self requestMoreDoulist:YES];
}

#pragma mark -- 初始化数据
- (void)initData{
    _page = 1;
    _doubanList = @[].mutableCopy;
    
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
    [_tableView registerNib:[UINib nibWithNibName:@"TopDoubanCell" bundle:nil] forCellReuseIdentifier:TopDoubanCellId];
    _tableView.separatorColor = KECColor;
    _tableView.mj_header = [UITool MJRefreshGifHeaderWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        strongSelf->_page = 1;
        [strongSelf requestMoreDoulist:NO];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestMoreDoulist:NO];
    }];
    _emptyView = [[EmptyView alloc]initWithFrame:_tableView.bounds icon:nil tip:nil tapBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestMoreDoulist:YES];
    }];
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf.view);
    }];
    
    _emptyView.hidden = YES;
}

- (void)requestMoreDoulist:(BOOL)showHUD {
    
    [HttpHelper GET:MoreDoulist headers:nil parameters:@{@"page":@(_page),@"pageSize":@(PageSize)} HUDView:showHUD ? self.view : nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *response) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if ([response[@"code"]integerValue] != 0) {
            [[ToastView sharedToastView]show:response[@"message"] inView:nil];
        }else{
            
            NSArray *doubanList = response[@"body"];
            if (_page == 1) {
                [_doubanList removeAllObjects];
            }
            
            
            for (NSDictionary *douban in doubanList) {
                TopDoubanModel *model = [[TopDoubanModel alloc]initWithDictionary:douban error:nil];
                [_doubanList addObject:model];
            }
            if (doubanList.count < PageSize) {
                dispatch_main_async_safe(^{
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                })
                
            }
            [_tableView reloadData];
            _emptyView.hidden = _doubanList.count > 0;
            _page ++ ;
        }
        
    } failure:^(NSError *error) {
        _emptyView.hidden = _doubanList.count > 0;
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

#pragma mark -- tableView-----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _doubanList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TopDoubanCell *cell = [tableView dequeueReusableCellWithIdentifier:TopDoubanCellId forIndexPath:indexPath];
    cell.model = _doubanList[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DouListInfoItemController *douListInfoItemController = [[DouListInfoItemController alloc]init];
    TopDoubanModel *model = _doubanList[indexPath.row];
    douListInfoItemController.douId = model.id;
    douListInfoItemController.title = model.title;
    [self.navigationController pushViewController:douListInfoItemController animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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
