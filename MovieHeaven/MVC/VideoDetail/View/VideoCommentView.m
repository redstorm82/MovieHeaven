//
//  VideoCommentView.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/3.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "VideoCommentView.h"
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
@interface VideoCommentView () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    EmptyView *_emptyView;
    NSUInteger _page;
    NSMutableArray <VideoCommentModel *> *_comments;
    UIButton *_commentBtn;
}

@end;
@implementation VideoCommentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self initData];
    }
    return self;
}
-(void)setVideoId:(NSInteger)videoId {
    _videoId = videoId;
    _page = 0;
    [self requestcomments:YES];
}

#pragma mark -- 初始化数据
- (void)initData{
    _page = 0;
    _comments = @[].mutableCopy;
    
}
#pragma mark -- 创建UI
- (void)createUI{
    
    _commentBtn = [ButtonTool createButtonWithTitle:@"评论" titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:17] addTarget:self action:@selector(addComment)];
    _commentBtn.backgroundColor = SystemColor;
    TO_WEAK(self, weakSelf);
    [self addSubview:_commentBtn];
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf);
        make.left.bottom.right.equalTo(strongSelf);
        make.height.mas_equalTo(40);
    }];
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [UIView new];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.left.top.right.equalTo(strongSelf);
        make.bottom.equalTo(strongSelf->_commentBtn.mas_top);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if (@available(iOS 11.0,*)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    _tableView.estimatedRowHeight = 117;
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
    [self addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf->_tableView);
    }];
    
    
}
#pragma mark -- 评论
- (void)addComment {
    if (![UserInfo read]) {
        //        登录
        LoginController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginController"];
        loginVC.completion = ^(UserInfo *user) {
            [self addComment];
        };
        [self.viewController presentViewController:loginVC animated:YES completion:NULL];
        return;
    }
    AddCommentController *addCommentController = [[UIStoryboard storyboardWithName:@"Comment" bundle:nil]instantiateInitialViewController];
    addCommentController.videoName = self.videoName;
    addCommentController.videoId = self.videoId;
    addCommentController.img = self.img;
    addCommentController.commentCompletion = ^{
        dispatch_main_async_safe(^{
            [_tableView.mj_header beginRefreshing];
        })
        
    };
    addCommentController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.viewController.definesPresentationContext = YES;
    BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:addCommentController];
    navi.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.viewController presentViewController:navi animated:YES completion:^{
        
    }];
    
}
- (void)requestcomments:(BOOL)showHUD {
    _emptyView.tip = EmptyLoadingTip;
    [HttpHelper GETWithWMH:WMH_COMMENT_LIST headers:nil parameters:@{@"pageNum":@(_page),@"pageSize":@(PageSize),@"videoId":@(self.videoId)} HUDView:showHUD ? self : nil progress:^(NSProgress *progress) {
        
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
            _emptyView.tip = @"快去评论一个吧(つ•̀ω•́)つ";
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
    cell.model = _comments[indexPath.row];
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
