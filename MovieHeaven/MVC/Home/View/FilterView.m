//
//  FilterView.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/6.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "FilterView.h"
#import <Masonry.h>
#import "VideoCollectionCell.h"
#import "VideoDetailController.h"
#import "EmptyView.h"
#import <MJRefresh/MJRefresh.h>
#import "UITools.h"
#import "FilterHeaderReusableView.h"
static const NSInteger PageSize = 30;
static NSString *VideoCollectionCellId = @"VideoCollectionCell";
static NSString *FilterHeaderReusableViewId = @"FilterHeaderReusableView";
@interface FilterView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    NSMutableArray <VideoItemModel *> *_resultArr;
    NSUInteger _page;
    EmptyView *_emptyView;
    NSDictionary *_headerData;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@end;
@implementation FilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self createUI];
    }
    return self;
}
- (void)createUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(VideoItemWidth, VideoItemHeight);
    layout.minimumLineSpacing = 10.f;
    layout.minimumInteritemSpacing = 10.f;
    layout.headerReferenceSize = CGSizeMake(kScreenWidth, FilterItemHeight * 4 + 10);
    layout.sectionInset = UIEdgeInsetsMake(5, KContentEdge - 0.5, 5, KContentEdge - 0.5);
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    TO_WEAK(self, weakSelf)
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionCell" bundle:nil] forCellWithReuseIdentifier:VideoCollectionCellId];
    
    self.collectionView.mj_header = [UITool MJRefreshGifHeaderWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        strongSelf->_page = 1;
        [strongSelf requestFilterData:NO];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestFilterData:NO];
    }];
    [self.collectionView registerClass:[FilterHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FilterHeaderReusableViewId];
    _emptyView = [[EmptyView alloc]initWithFrame:CGRectZero icon:nil tip:@"暂无筛选内容" tapBlock:^(void){
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestFilterData:YES];
    }];
    [self addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf).insets(UIEdgeInsetsMake(30 * 4, 0, 0, 0));
    }];
    
}
- (void)createFilterView{
    
    
}

- (void)requestVideosfilter{
    [HttpHelper GET:VideosFilter headers:nil parameters:@{@"type":@(self.type)} HUDView:self progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {
        if ([response[@"code"] integerValue] == 0) {
            _headerData = response[@"body"];
            [self.collectionView reloadData];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
- (void)requestFilterData:(BOOL )showHUD{
    
    NSDictionary *params = @{
                             @"type": @(self.type),
                             @"genre": self.genre,
                             @"country": self.country,
                             @"year": self.year,
                             @"sortby":self.sortby,
                             @"page": @(_page),
                             @"pageSize":@(PageSize)
                             };
    
    [HttpHelper GET:VideoSearch headers:nil parameters:params HUDView:showHUD ? self : nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if ([response[@"code"] integerValue] != 0) {
            [[ToastView sharedToastView]show:response[@"message"] inView:nil];
            _emptyView.tip = @"请求失败,点击重试";
        }else{
            _emptyView.tip = @"抱歉，没有找到内容";
            NSArray *body = response[@"body"];
            if (_page == 1) {
                [_resultArr removeAllObjects];
            }
            
            for (NSDictionary *item in body) {
                VideoItemModel *model = [[VideoItemModel alloc]initWithDictionary:item error:nil];
                [_resultArr addObject:model];
            }
            if (body.count < PageSize) {
                dispatch_main_async_safe(^{
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                })
                
            }
            [self.collectionView reloadData];
            _emptyView.hidden = _resultArr.count > 0;
            
            
            _page ++;
        }
        
    } failure:^(NSError * _Nullable error) {
        _emptyView.tip = @"请求失败,点击重试";
        _emptyView.hidden = _resultArr.count > 0;
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark -- 初始化数据
- (void)initData{
    
    _resultArr = @[].mutableCopy;
    _page = 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _resultArr.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VideoCollectionCellId forIndexPath:indexPath];
    cell.model = _resultArr[indexPath.item];
    return cell;
    
}
//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {

    FilterHeaderReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:FilterHeaderReusableViewId
                                                                                   forIndexPath:indexPath];
    
    
    headView.types = _headerData[@"types"];
    headView.areas = _headerData[@"areas"];
    headView.years = _headerData[@"years"];
    
    headView.sortby = self.sortby;
    headView.area = self.country;
    headView.type = self.genre;
    headView.year = self.year;
    TO_WEAK(self, weakSelf)
    [headView setChangeFilter:^(NSString *sortby, NSString *type, NSString *area, NSString *year) {
        TO_STRONG(weakSelf, strongSelf)
        strongSelf.sortby = sortby;
        strongSelf.genre = type;
        strongSelf.country = area;
        strongSelf.year = year;
        strongSelf->_page = 1;
        [strongSelf requestFilterData:YES];
    }];
    [headView reloadData];
    return headView;
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 30 * 4 + 10);
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoDetailController *detailVC = [[VideoDetailController alloc]init];
    VideoItemModel *model = _resultArr[indexPath.item];
    detailVC.videoId = model.movieId;
    detailVC.videoName = model.name;
    detailVC.from = @"filter";
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
    
}
-(void)didMoveToWindow{
    if (_resultArr.count < 1) {
        [self requestFilterData:YES];
        
    }
    if (!_headerData) {
        [self requestVideosfilter];
    }
}

@end
