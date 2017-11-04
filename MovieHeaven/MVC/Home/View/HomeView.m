//
//  HomeView.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/1.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "HomeView.h"
#import <Masonry.h>
#import "UITools.h"
#import <TYCyclePagerView.h>
#import <TYPageControl.h>
#import "BannerCell.h"
#import "VideoSectionModel.h"
#import "FilterModel.h"
#import "VideoSectionCell.h"
#import "VideoDetailController.h"
#import "UIView+UIViewController.h"
#import "EmptyView.h"
static NSString *BannerCellId = @"BannerCell";
static NSString *VideoSectionCellId = @"VideoSectionCell";
@interface HomeView()<UITableViewDelegate,UITableViewDataSource,TYCyclePagerViewDelegate,TYCyclePagerViewDataSource> {
    
}
@end

@implementation HomeView {
    
    UITableView *_tableView;
    TYCyclePagerView *_pagerView;
    TYPageControl *_pageControl;
    UICollectionView *_filterCollectView;
    EmptyView *_emptyView;
    
    NSMutableArray <BannerModel *> * _bannerDatas;
    NSMutableArray <VideoSectionModel *> *_viewItemModels;
    NSMutableArray <FilterModel *>*_filterDatas;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _bannerDatas = @[].mutableCopy;
        _viewItemModels = @[].mutableCopy;
        _type = 0;
        [self createUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bannerDatas = @[].mutableCopy;
        _viewItemModels = @[].mutableCopy;
        _type = 0;
        [self createUI];
    }
    return self;
}
#pragma mark -- 创建UI
- (void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
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
    [_tableView registerClass:[VideoSectionCell class] forCellReuseIdentifier:VideoSectionCellId];
    
    _tableView.separatorColor = KECColor;
    _tableView.mj_header = [UITool MJRefreshGifHeaderWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestHomeData:NO];
    }];
    [self createHeaderBanner];
    _emptyView = [[EmptyView alloc]initWithFrame:_tableView.bounds icon:nil tip:nil tapBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestHomeData:YES];
    }];
    [self addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf);
    }];
    
    _emptyView.hidden = YES;
}

- (void)createHeaderBanner{
    
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 1.8) ];
    pagerView.isInfiniteLoop = YES;
    pagerView.autoScrollInterval = 3.0;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    [pagerView registerNib:[UINib nibWithNibName:@"BannerCell" bundle:nil] forCellWithReuseIdentifier:BannerCellId];
    
    _pagerView = pagerView;

    
    
    TYPageControl *pageControl = [[TYPageControl alloc]initWithFrame:CGRectMake(kScreenWidth - 120, pagerView.height - 25, 120, 25)];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = SystemColor;
    pageControl.currentPageIndicatorSize = CGSizeMake(8, 8);
    [_pagerView addSubview:pageControl];
    _pageControl = pageControl;
    _tableView.tableHeaderView = _pagerView;
}

- (void)requestHomeData:(BOOL)showHUD{
    
    
    [HttpHelper GET:HotPlay headers:nil parameters:@{@"type":@(_type)} HUDView:showHUD ? self : nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, NSDictionary *response) {
        if ([response[@"code"]integerValue] != 0) {
            [[ToastView sharedToastView]show:response[@"message"] inView:nil];
            _emptyView.hidden = NO;
        }else{
            _emptyView.hidden = YES;
            NSDictionary *body = response[@"body"];
            NSArray *filterDatas = body[@"filterDatas"];
            if (filterDatas) {
                _filterDatas = @[].mutableCopy;
                for (NSDictionary *filter in filterDatas) {
                    FilterModel *model = [[FilterModel alloc]initWithDictionary:filter error:nil];
                    [_filterDatas addObject:model];
                }
            }
            
            
            NSArray *bannerDatas = body[@"bannerDatas"];
            [_bannerDatas removeAllObjects];
            for (NSDictionary *banner in bannerDatas) {
                BannerModel *model = [[BannerModel alloc]initWithDictionary:banner error:nil];
                [_bannerDatas addObject:model];
            }
            [_viewItemModels removeAllObjects];
            NSArray *viewItemModels = body[@"viewItemModels"];
            for (NSDictionary *item in viewItemModels) {
                VideoSectionModel *model = [[VideoSectionModel alloc]initWithDictionary:item error:nil];
                [_viewItemModels addObject:model];
            }
            
            [self reloadData];
        }
        
        
        [_tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        _emptyView.hidden = NO;
        [_tableView.mj_header endRefreshing];
    }];
    
    
}
- (void)reloadData{
    dispatch_main_async_safe(^{
        [_pagerView reloadData];
        _pageControl.numberOfPages = _bannerDatas.count;
        [_tableView reloadData];
    })

}
-(NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView{
    return _bannerDatas.count;
}
-(UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index{
    BannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:BannerCellId forIndex:index];
    cell.model = _bannerDatas[index];
    return cell;
}
-(TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView{
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenWidth / 1.8);
    return layout;
}
-(void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    [_pageControl setCurrentPage:toIndex animate:YES];
}
-(void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(nonnull __kindof UICollectionViewCell *)cell atIndex:(NSInteger)index{
    VideoDetailController *detailVC = [[VideoDetailController alloc]init];
    detailVC.videoId = _bannerDatas[index].vid;
    detailVC.videoName = _bannerDatas[index].desc;
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark -- tableView-----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _viewItemModels.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoSectionCellId forIndexPath:indexPath];
    cell.model = _viewItemModels[indexPath.section];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 && _filterDatas) {
        NSInteger row = _filterDatas.count / 4 + (_filterDatas.count % 4 == 0 ? 0 : 1);
        return 35 + row * 25 + 10 * (row + 1);
    }
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = _viewItemModels[indexPath.section].videos.count;
    NSInteger row = count / 3 + (count % 3 == 0 ? 0 : 1);
    CGFloat height = row * VideoItemHeight + 10 * (row + 1);
    return height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerSecView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headerSecView.backgroundColor = KECColor;
    UILabel *titleLabel = [LabelTool createLableWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 35) textColor:K33Color font:[UIFont boldSystemFontOfSize:15]];
    [headerSecView addSubview:titleLabel];
    VideoSectionModel *secModel = _viewItemModels[section];
    if (section == 0 && _filterDatas) {
        NSInteger row = _filterDatas.count / 4 + (_filterDatas.count % 4 == 0 ? 0 : 1);
        headerSecView.height = 35 + row * 25 + 10 * (row + 1);
        titleLabel.bottom = headerSecView.height;
        CGFloat left = 10;
        CGFloat top = 10;
        CGFloat height = 25;
        CGFloat width = (kScreenWidth - 10 * 5) / 4;
        for (int i = 0; i < _filterDatas.count; i ++) {
            UIButton *filterItemBtn = [ButtonTool createBlockButtonWithTitle:_filterDatas[i].name titleColor:i == _filterDatas.count - 1 ? SystemColor : K33Color titleFont:[UIFont systemFontOfSize:13] block:^(UIButton *button) {
                
            }];
            filterItemBtn.layer.borderWidth = 0.5;
            [filterItemBtn setCornerRadius:2];
            filterItemBtn.backgroundColor = [UIColor whiteColor];
            filterItemBtn.layer.borderColor = i == _filterDatas.count - 1 ? SystemColor.CGColor : KD9Color.CGColor;
            filterItemBtn.frame = CGRectMake(left, top, width, height);
            if (( i + 1 ) % 4 == 0) {
                left = 10;
                top = filterItemBtn.bottom + 10;
            }else{
                left = filterItemBtn.right + 10;
            }
            [headerSecView addSubview:filterItemBtn];
        }
        
    }
    titleLabel.text = secModel.title;
    return headerSecView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerSecView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    footerSecView.backgroundColor = [UIColor whiteColor];
    
    UIButton *moreButton = [ButtonTool createBlockButtonWithTitle:@"更多" titleColor:[UIColor whiteColor] titleFont:[UIFont boldSystemFontOfSize:16] block:^(UIButton *button) {
        
    }];
    moreButton.layer.borderWidth = 0.5;
    [moreButton setCornerRadius:3];
    moreButton.backgroundColor = SystemColor;
    moreButton.layer.borderColor = KD9Color.CGColor;
    moreButton.frame = CGRectMake(10, 7.5, kScreenWidth - 20, 30);
    [footerSecView addSubview:moreButton];
    
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, moreButton.bottom + 5, kScreenWidth, 5)];
//    lineView.backgroundColor = [UIColor whiteColor];
//    [footerSecView addSubview:lineView];
    return footerSecView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)didMoveToWindow{
    if (_viewItemModels.count < 1) {
        [self requestHomeData:YES];
    }
    
}
@end