//
//  ShortVideoListView.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/9.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "ShortVideoListView.h"
#import "EmptyView.h"
#import "UITools.h"
#import "UITools.h"
#import <Masonry.h>
#import "ZFPlayerView.h"
#import "ShortVideoItemCell.h"
#import "AlertView.h"
static NSString *ShortVideoItemCellId = @"ShortVideoItemCell";

@interface ShortVideoListView () <UITableViewDelegate, UITableViewDataSource,ZFPlayerDelegate> {
    UITableView *_tableView;
    EmptyView *_emptyView;
    NSUInteger _page;
    NSMutableArray <ShortVideoItemModel *> *_shortVideoList;
}
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@end;
@implementation ShortVideoListView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self initData];
        
    }
    return self;
}


#pragma mark -- 初始化数据
- (void)initData{
    _page = 1;
    _shortVideoList = @[].mutableCopy;
    
}
#pragma mark -- 创建UI
- (void)createUI{
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [UIView new];
    [self addSubview:_tableView];
    TO_WEAK(self, weakSelf)
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if (@available(iOS 11.0,*)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"ShortVideoItemCell" bundle:nil] forCellReuseIdentifier:ShortVideoItemCellId];
    
    _tableView.separatorColor = KECColor;
    _tableView.mj_header = [UITool MJRefreshGifHeaderWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)

        [strongSelf->_shortVideoList removeAllObjects];
        [strongSelf requestShortVideoList:NO];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestShortVideoList:NO];
    }];
    _emptyView = [[EmptyView alloc]initWithFrame:_tableView.bounds icon:nil tip:EmptyLoadingTip tapBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf->_shortVideoList removeAllObjects];
        [strongSelf requestShortVideoList:YES];
    }];
    [self addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf);
    }];
    
    
}
- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
//         _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
        // 移除屏幕移除player
        // _playerView.stopPlayWhileCellNotVisable = YES;
    }
    return _playerView;
}
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}
-(void)resetPlayer {
    [self.playerView resetPlayer];
    [_playerView removeFromSuperview];
    _playerView = nil;
}
- (void)requestShortVideoList:(BOOL)showHUD {
    _emptyView.tip = EmptyLoadingTip;
    [HttpHelper GET:HotShortVideoList headers:nil parameters:@{@"page":@(_page),@"tid":@(self.tid)} HUDView:showHUD ? self : nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *response) {
        _emptyView.tip = EmptyDefaultTip;
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if ([response[@"code"]integerValue] != 0) {
            [[ToastView sharedToastView]show:response[@"message"] inView:nil];
        }else{
            
            NSArray *doubanList = response[@"body"];
            
            
            
            for (NSDictionary *douban in doubanList) {
                ShortVideoItemModel *model = [[ShortVideoItemModel alloc]initWithDictionary:douban error:nil];
                [_shortVideoList addObject:model];
            }
            if (doubanList.count < 1) {
                dispatch_main_async_safe(^{
                    _page = 0;
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                })
                
            }
            [_tableView reloadData];
            _emptyView.hidden = _shortVideoList.count > 0;
            _page ++ ;
        }
        
    } failure:^(NSError *error) {
        _emptyView.tip = EmptyDefaultTip;
        _emptyView.hidden = _shortVideoList.count > 0;
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

#pragma mark -- tableView-----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _shortVideoList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ShortVideoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ShortVideoItemCellId forIndexPath:indexPath];
    
    __block ShortVideoItemModel *model = _shortVideoList[indexPath.row];
    cell.model = model;
    __block NSIndexPath *weakIndexPath = indexPath;
    __block ShortVideoItemCell *weakCell     = cell;
    TO_WEAK(self, weakSelf)
    cell.playBlock = ^(UIButton * button) {
        TO_STRONG(weakSelf, strongSelf)
        if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
            [[[AlertView alloc]initWithText:@"当前为移动网络，是否继续播放?" cancelTitle:@"取消" sureTitle:@"播放" cancelBlock:^(NSInteger index) {
                
            } sureBlock:^(NSInteger index) {
                
                [strongSelf playerVideoWithCell:weakCell shortVideoModel:model index:weakIndexPath];
                
            }]show];
        } else {
            
            [strongSelf playerVideoWithCell:weakCell shortVideoModel:model index:weakIndexPath];
        }
        
        
        
    };

    
    return cell;
    
}

- (void)playerVideoWithCell:(ShortVideoItemCell *)cell shortVideoModel:(ShortVideoItemModel *)model index:(NSIndexPath *)indexPath {
    
    __block ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
    playerModel.title = model.title;
    playerModel.videoURL = [NSURL URLWithString:model.url];
    playerModel.placeholderImageURLString = model.banner;
    playerModel.scrollView = _tableView;
    playerModel.indexPath = indexPath;
    // player的父视图tag
    playerModel.fatherViewTag = cell.bannerImageView.tag;
    
    // 设置播放控制层和model
    [self.playerView playerControlView:nil playerModel:playerModel];
    //        [strongSelf.playerView autoPlayTheVideo];
    [HttpHelper GET:model.url headers:nil parameters:nil HUDView:nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {
        if ([response[@"errno"]integerValue] == 0) {
            [HttpHelper GET:response[@"data"][@"playLink"] headers:nil parameters:nil HUDView:nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {
                if ([response[@"errno"]integerValue] == 0) {
                    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
                    playerModel.title = model.title;
                    playerModel.videoURL = [NSURL URLWithString:response[@"data"][@"url"]];
                    playerModel.placeholderImageURLString = model.banner;
                    playerModel.scrollView = _tableView;
                    playerModel.indexPath = indexPath;
                    // player的父视图tag
                    playerModel.fatherViewTag = cell.bannerImageView.tag;
                    
                    // 设置播放控制层和model
                    [self.playerView playerControlView:nil playerModel:playerModel];
                    
                    // 自动播放
                    [self.playerView autoPlayTheVideo];
                    
                }else{
                    [[ToastView sharedToastView]show:response[@"errmsg"] inView:nil];
                }
            } failure:^(NSError * _Nullable error) {
                
            }];
            
        }else{
            [[ToastView sharedToastView]show:response[@"errmsg"] inView:nil];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScreenWidth / 16 * 9 + 42;

}
#pragma mark - ZFPlayerDelegate

- (void)zf_playerDownload:(NSString *)url {
   
}

@end
