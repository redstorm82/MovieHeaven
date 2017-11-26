//
//  MyCommentViewController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/26.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "MyCommentViewController.h"
#import "EmptyView.h"
#import "UITools.h"
#import <Masonry.h>
#import "VideoCommentCell.h"
#import "AddCommentController.h"
#import "BaseNavigationController.h"
#import "UserInfo.h"
#import "LoginController.h"
static NSString *VideoCommentCellId = @"VideoCommentCell";
static const NSInteger PageSize = 20;
@interface MyCommentViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    EmptyView *_emptyView;
    NSUInteger _page;
    NSMutableArray <VideoCommentModel *> *_comments;
}
@end
@implementation MyCommentViewController
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
    self.title = @"我的评论";
    [self createUI];
    [self initData];
    [self requestcomments:YES];
}
#pragma mark -- 初始化数据
- (void)initData{
    _page = 0;
    _comments = @[].mutableCopy;
    
}
#pragma mark -- 创建UI
- (void)createUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    TO_WEAK(self, weakSelf);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf);
        make.edges.equalTo(strongSelf.view);
        
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if (@available(iOS 11.0,*)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"VideoCommentCell" bundle:nil] forCellReuseIdentifier:VideoCommentCellId];
    
    _tableView.separatorColor = KECColor;
    _tableView.mj_header = [UITool MJRefreshGifHeaderWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        strongSelf->_page = 0;
        
        [strongSelf requestcomments:NO];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestcomments:NO];
    }];
    _emptyView = [[EmptyView alloc]initWithFrame:_tableView.bounds icon:nil tip:EmptyLoadingTip tapBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        strongSelf->_page = 0;
        [strongSelf requestcomments:YES];
    }];
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf);
        make.edges.equalTo(strongSelf.view);
    }];
    
    
}
- (void)requestcomments:(BOOL)showHUD {
    _emptyView.tip = EmptyLoadingTip;
    [HttpHelper GETWithWMH:WMH_COMMENT_LIST_SELF headers:nil parameters:@{@"pageNum":@(_page),@"pageSize":@(PageSize)} HUDView:showHUD ? self.view : nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *data) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (![data[@"status"] isEqualToString:@"B0000"]) {
            [[ToastView sharedToastView]show:data[@"txt"] inView:nil];
            _emptyView.tip = EmptyDefaultTip;
        }else{
            
            NSArray *comments = data[@"comments"];
            if (_page == 0) {
                [_comments removeAllObjects];
            }
            
            
            for (NSDictionary *comment in comments) {
                VideoCommentModel *model = [[VideoCommentModel alloc]initWithDictionary:comment error:nil];
                [_comments addObject:model];
            }
            if (comments.count < PageSize) {
                dispatch_main_async_safe(^{
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                })
                
            }
            [_tableView reloadData];
            _emptyView.tip = @"暂无评论哦(～￣▽￣)～";
            _emptyView.hidden = _comments.count > 0;
            _page ++ ;
        }
        
    } failure:^(NSError *error) {
        _emptyView.tip = EmptyDefaultTip;
        _emptyView.hidden = _comments.count > 0;
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

#pragma mark -- tableView-----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _comments.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoCommentCellId forIndexPath:indexPath];
    cell.type = Self;
    cell.model = _comments[indexPath.row];
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
    
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
