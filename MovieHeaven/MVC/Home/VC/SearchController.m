//
//  SearchController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/5.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "SearchController.h"
#import <Masonry.h>
#import "VideoCollectionCell.h"
#import "VideoDetailController.h"
#import "EmptyView.h"
#import <MJRefresh/MJRefresh.h>
#import "UITools.h"

#define VideoItemWidth (kScreenWidth - 10.f * 2.f - KContentEdge * 2) / 3.f
#define VideoItemHeight (VideoItemWidth) / 3.f * 5.f
static const NSInteger PageSize = 30;
static NSString *VideoCollectionCellId = @"VideoCollectionCell";
@interface SearchController () <UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>{
    NSMutableArray <VideoItemModel *> *_resultArr;
    NSUInteger _page;
    EmptyView *_emptyView;
    NSString *_keywords;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createUI];
    
    
    
}
- (void)initData{
    _keywords = @"";
    _resultArr = @[].mutableCopy;
    _page = 1;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault) animated:YES];
    
}
- (void)createUI{

    [self createSearchView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(VideoItemWidth, VideoItemHeight);
    layout.minimumLineSpacing = 10.f;
    layout.minimumInteritemSpacing = 10.f;
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    TO_WEAK(self, weakSelf)
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, KContentEdge - 0.5, 0, KContentEdge - 0.5));
    }];
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionCell" bundle:nil] forCellWithReuseIdentifier:VideoCollectionCellId];
    
    self.collectionView.mj_header = [UITool MJRefreshGifHeaderWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        strongSelf->_page = 1;
        [strongSelf requestSearchData:NO];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestSearchData:NO];
    }];
    _emptyView = [[EmptyView alloc]initWithFrame:self.collectionView.bounds icon:nil tip:@"暂无搜索内容" tapBlock:NULL];
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
    }];

    
    
}
#pragma mark -- 导航栏 搜索
- (void)createSearchView{
    
    UIView *naviBarView = [[UIView alloc]initWithFrame:CGRectZero];
    naviBarView.backgroundColor = [UIColor whiteColor];
    naviBarView.layer.borderColor = KECColor.CGColor;
    naviBarView.layer.borderWidth = 0.5;
    [self.view addSubview:naviBarView];
    [naviBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(KNavigationBarHeight);
    }];
    
    UIButton *cancelBtn = [ButtonTool createButtonWithTitle:@"取消" titleColor:K33Color titleFont:[UIFont systemFontOfSize:17] addTarget:self action:@selector(goBack)];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [naviBarView addSubview:cancelBtn];
    
    UIView *searchBg = [[UIView alloc]initWithFrame:CGRectZero];
    searchBg.backgroundColor = [UIColor whiteColor];
    searchBg.layer.borderColor = KECColor.CGColor;
    searchBg.layer.cornerRadius = 3;
    searchBg.clipsToBounds = YES;
    searchBg.layer.borderWidth = 0.6;
    [naviBarView addSubview:searchBg];
    [searchBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(naviBarView).mas_offset(KContentEdge);
        make.bottom.equalTo(naviBarView).mas_offset(-10);
        make.right.equalTo(naviBarView).mas_offset(-KContentEdge - 38 - 10);
        make.height.mas_equalTo(35);
    }];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(naviBarView).mas_offset(-KContentEdge);
        make.centerY.equalTo(searchBg);
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(25);
    }];
    
    UIImageView *searchIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_search"]];
    [searchBg addSubview:searchIcon];
    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchBg).offset(10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.equalTo(searchBg);
    }];
    UITextField *searchTextField = [[UITextField alloc]init];
    searchTextField.textColor = K33Color;
    searchTextField.font = [UIFont systemFontOfSize:15];
    searchTextField.placeholder = @"搜索想看的视频";
    [searchBg addSubview:searchTextField];
    [searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchIcon.mas_right).mas_offset(10);
        make.top.equalTo(searchBg);
        make.bottom.equalTo(searchBg);
        make.right.equalTo(searchBg).mas_offset(-5);
    }];
    searchTextField.delegate = self;
    searchTextField.returnKeyType = UIReturnKeySearch;
    [searchTextField becomeFirstResponder];
}
- (void)requestSearchData:(BOOL )showHUD{
    NSDictionary *params = @{
        @"keywords":_keywords,
//            [_keywords stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
        @"page":@(_page),
        @"pageSize":@(PageSize)
        };
    _emptyView.tip = @"抱歉，没有找到内容\n请缩短关键词后重试";
    [HttpHelper GET:VideoSearch headers:nil parameters:params HUDView:showHUD ? self.view : nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {
        if (self.collectionView.mj_header) {
            [self.collectionView.mj_header endRefreshing];
        }
        if (self.collectionView.mj_footer) {
            [self.collectionView.mj_footer endRefreshing];
        }
        if ([response[@"code"] integerValue] != 0) {
            [[ToastView sharedToastView]show:response[@"message"] inView:nil];
        }else{
            
            NSArray *body = response[@"body"];
            if (_page == 1) {
                [_resultArr removeAllObjects];
            }
            
            for (NSDictionary *item in body) {
                VideoItemModel *model = [[VideoItemModel alloc]initWithDictionary:item error:nil];
                [_resultArr addObject:model];
            }
            if (body.count < PageSize) {
                [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
            }
            [self.collectionView reloadData];
            _emptyView.hidden = _resultArr.count > 0;
            
            
            _page ++;
        }
        
    } failure:^(NSError * _Nullable error) {
        _emptyView.hidden = _resultArr.count > 0;
        if (self.collectionView.mj_header) {
            [self.collectionView.mj_header endRefreshing];
        }
        if (self.collectionView.mj_footer) {
            [self.collectionView.mj_footer endRefreshing];
        }
    }];
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
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoDetailController *detailVC = [[VideoDetailController alloc]init];
    VideoItemModel *model = _resultArr[indexPath.item];
    detailVC.videoId = model.movieId;
    detailVC.videoName = model.name;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    _keywords = textField.text;
    _page = 1;
    [self requestSearchData:YES];
    [textField endEditing:YES];
    return YES;
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
