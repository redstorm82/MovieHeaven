//
//  TopDouBanMoreController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/7.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "TopDouBanMoreController.h"
#import <Masonry.h>
#import "VideoCollectionCell.h"
#import "VideoDetailController.h"
#import "EmptyView.h"
#import <MJRefresh/MJRefresh.h>
#import "UITools.h"
static NSString *VideoCollectionCellId = @"VideoCollectionCell";
static const NSInteger PageSize = 30;

@interface TopDouBanMoreController () <UICollectionViewDelegate,UICollectionViewDataSource> {
    NSMutableArray <TopVideoItemModel *> *_doubanMoreData;
    NSUInteger _page;
    EmptyView *_emptyView;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation TopDouBanMoreController
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
    [self initData];
    [self createUI];
    [self requestMoreData:YES];
}
#pragma mark -- 初始化数据
- (void)initData{
    _doubanMoreData = @[].mutableCopy;
    _page = 1;
}

- (void)createUI{
    
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(VideoItemWidth, VideoItemHeight);
    layout.minimumLineSpacing = 10.f;
    layout.minimumInteritemSpacing = 10.f;
    layout.sectionInset = UIEdgeInsetsMake(5, KContentEdge - 0.5, 5, KContentEdge - 0.5);
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    TO_WEAK(self, weakSelf)
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf.view);
    }];
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionCell" bundle:nil] forCellWithReuseIdentifier:VideoCollectionCellId];
    
    self.collectionView.mj_header = [UITool MJRefreshGifHeaderWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        strongSelf->_page = 1;
        [strongSelf requestMoreData:NO];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestMoreData:NO];
    }];
    _emptyView = [[EmptyView alloc]initWithFrame:self.collectionView.bounds icon:nil tip:nil tapBlock:^(void){
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestMoreData:YES];
    }];
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf.view);
    }];
    
    
}
- (void)requestMoreData:(BOOL )showHUD{
    _emptyView.tip = EmptyLoadingTip;
    NSDictionary *params = @{
                             @"id":self.moreId,
                             @"page":@(_page),
                             @"pageSize":@(PageSize)
                             };
    
    [HttpHelper GET:TopMore headers:nil parameters:params HUDView:showHUD ? self.view : nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {
        _emptyView.tip = EmptyDefaultTip;
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if ([response[@"code"] integerValue] != 0) {
            [[ToastView sharedToastView]show:response[@"message"] inView:nil];
        }else{
            
            NSArray *body = response[@"body"];
            if (_page == 1) {
                [_doubanMoreData removeAllObjects];
            }
            
            for (NSDictionary *item in body) {
                TopVideoItemModel *model = [[TopVideoItemModel alloc]initWithDictionary:item error:nil];
                [_doubanMoreData addObject:model];
            }
            if (body.count < PageSize) {
                dispatch_main_async_safe(^{
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                })
                
            }
            [self.collectionView reloadData];
            _emptyView.hidden = _doubanMoreData.count > 0;
            
            
            _page ++;
        }
        
    } failure:^(NSError * _Nullable error) {
        _emptyView.tip = EmptyDefaultTip;
        _emptyView.hidden = _doubanMoreData.count > 0;
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _doubanMoreData.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VideoCollectionCellId forIndexPath:indexPath];
    cell.topModel = _doubanMoreData[indexPath.item];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoDetailController *detailVC = [[VideoDetailController alloc]init];
    TopVideoItemModel *model = _doubanMoreData[indexPath.item];
    detailVC.videoId = model.movieId;
    detailVC.videoName = model.name;
    detailVC.from = @"doulist";
    [self.navigationController pushViewController:detailVC animated:YES];
    
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
