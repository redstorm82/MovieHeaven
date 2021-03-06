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
#import "SearchSuggestView.h"
//#import <IQKeyboardManager.h>

static const NSInteger PageSize = 30;
static NSString *VideoCollectionCellId = @"VideoCollectionCell";
@interface SearchController () <UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>{
    NSMutableArray <VideoItemModel *> *_resultArr;
    NSUInteger _page;
    EmptyView *_emptyView;
    NSString *_keywords;
    UITapGestureRecognizer *_tap1;
    
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SearchSuggestView *searchSuggestView;
@property (nonatomic, strong) UIView *naviBarView;
@property (nonatomic, strong) UITextField *searchTextField;
@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createUI];
//    手势
    _tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)];
    
    NSArray *history = UserDefaultsGet(SrearchHistory);
    if (history.count > 0) {
        [self.searchTextField becomeFirstResponder];
    }
    
}
#pragma mark -- 初始化数据
- (void)initData{
    _keywords = @"";
    _resultArr = @[].mutableCopy;
    _page = 1;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault) animated:YES];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)createUI{

    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(VideoItemWidth, VideoItemHeight);
    layout.minimumLineSpacing = 10.f;
    layout.minimumInteritemSpacing = 10.f;
    layout.sectionInset = UIEdgeInsetsMake(0, KContentEdge - 0.5, 0, KContentEdge - 0.5);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight + 10, kScreenWidth, kScreenHeight - KNavigationBarHeight - 10) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    TO_WEAK(self, weakSelf)
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf.view).insets(UIEdgeInsetsMake(KNavigationBarHeight + 10, 0, 0, 0));
    }];
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionCell" bundle:nil] forCellWithReuseIdentifier:VideoCollectionCellId];
    
    self.collectionView.mj_header = [UITool MJRefreshGifHeaderWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        strongSelf->_page = 1;
        [strongSelf requestSearchData:NO];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestSearchData:NO];
    }];
    _emptyView = [[EmptyView alloc]initWithFrame:self.collectionView.bounds icon:nil tip:@"暂无搜索内容" tapBlock:^(void){
        [self hiddenKeyBoard];
    }];
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf.view).insets(UIEdgeInsetsMake(KNavigationBarHeight + 5, 0, 0, 0));
    }];
    [self createSearchView];
    
}
#pragma mark -- 导航栏 搜索
- (void)createSearchView{
    
    self.naviBarView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:self.naviBarView];
    TO_WEAK(self, weakSelf)
    [self.naviBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.left.equalTo(strongSelf.view);
        make.top.equalTo(strongSelf.view);
        make.right.equalTo(strongSelf.view);
        make.height.mas_equalTo(KNavigationBarHeight + 5);
    }];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = KD9Color;
    [self.naviBarView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.naviBarView);
        make.right.equalTo(self.naviBarView);
        make.bottom.equalTo(self.naviBarView).mas_offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    UIButton *cancelBtn = [ButtonTool createButtonWithTitle:@"取消" titleColor:K33Color titleFont:[UIFont systemFontOfSize:17] addTarget:self action:@selector(goBack)];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.naviBarView addSubview:cancelBtn];
    
    UIView *searchBg = [[UIView alloc]initWithFrame:CGRectZero];
    searchBg.backgroundColor = KF7Color;
//    searchBg.backgroundColor = [UIColor whiteColor];
    searchBg.layer.borderColor = KD9Color.CGColor;
    searchBg.layer.cornerRadius = 4;
    searchBg.clipsToBounds = YES;
    searchBg.layer.borderWidth = 0.7;
    [self.naviBarView addSubview:searchBg];
    [searchBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.naviBarView).mas_offset(KContentEdge);
        make.bottom.equalTo(self.naviBarView).mas_offset(-5);
        make.right.equalTo(self.naviBarView).mas_offset(-KContentEdge - 38 - 10);
        make.height.mas_equalTo(35);
    }];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.naviBarView).mas_offset(-KContentEdge);
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
    self.searchTextField = [[UITextField alloc]init];
    self.searchTextField.textColor = K33Color;
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.font = [UIFont systemFontOfSize:15];
    self.searchTextField.placeholder = @"搜索想看的视频";
    [searchBg addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchIcon.mas_right).mas_offset(10);
        make.top.equalTo(searchBg);
        make.bottom.equalTo(searchBg);
        make.right.equalTo(searchBg).mas_offset(-5);
    }];
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    
}
-(SearchSuggestView *)searchSuggestView{
    if (!_searchSuggestView) {
        _searchSuggestView = [[SearchSuggestView alloc]initWithFrame:CGRectMake(KContentEdge, KNavigationBarHeight - 2, kScreenWidth - KContentEdge * 2 - 38 - 10, 0)];
        [self.view addSubview:_searchSuggestView];
        TO_WEAK(self, weakSelf)
 
        _searchSuggestView.clickKeywords = ^(NSString *keywords) {
            TO_STRONG(weakSelf, strongSelf)
            strongSelf->_page = 1;
            strongSelf->_keywords = keywords;
            strongSelf.searchTextField.text = keywords;
            [strongSelf hiddenKeyBoard];
            
            [strongSelf requestSearchData:YES];
        };
        _searchSuggestView.hidden = YES;
    }
    return _searchSuggestView;
}
- (void)requestSearchData:(BOOL )showHUD{
    [self saveHistory];
    self.searchSuggestView.hidden = YES;
    
    NSDictionary *params = @{
        @"keywords":_keywords,
//            [_keywords stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
        @"page":@(_page),
        @"pageSize":@(PageSize)
        };
    _emptyView.tip = @"抱歉，没有找到内容\n请缩短关键词后重试";
    [HttpHelper GET:VideoSearch headers:nil parameters:params HUDView:showHUD ? self.view : nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
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
                dispatch_main_async_safe(^{
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                })
                
            }
            [self.collectionView reloadData];
            _emptyView.hidden = _resultArr.count > 0;
            
            
            _page ++;
        }
        
    } failure:^(NSError * _Nullable error) {
        _emptyView.hidden = _resultArr.count > 0;
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}
#pragma mark -- 保存历史
- (void)saveHistory{
    
    NSArray *history = UserDefaultsGet(SrearchHistory);
    NSMutableArray *historyMutable = history.mutableCopy;
    
    if (historyMutable.count > 9) {
        [historyMutable removeLastObject];
    }
    if (_keywords.length < 1) {
        return;
    }
    if (![historyMutable containsObject:_keywords]) {
        if (historyMutable.count == 0) {
            [historyMutable addObject:_keywords];
        }else{
            [historyMutable insertObject:_keywords atIndex:0];
        }
    } else {
        NSInteger index =  [historyMutable indexOfObject:_keywords];
        if (index != NSNotFound && historyMutable.count > 1) {
            [historyMutable exchangeObjectAtIndex:index withObjectAtIndex:0];
        }
    }
    
    UserDefaultsSet(historyMutable, SrearchHistory);
    [[NSUserDefaults standardUserDefaults]synchronize];
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
    detailVC.from = @"filter";
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
-(void)hiddenKeyBoard{
    [super hiddenKeyBoard];
    self.searchSuggestView.hidden = YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self hiddenKeyBoard];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    _keywords = textField.text;
    _page = 1;
    [self requestSearchData:YES];
    [self hiddenKeyBoard];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.searchSuggestView.keywords = aString;
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.searchSuggestView.hidden = NO;
    [self.searchSuggestView updateSize];
    [self.collectionView addGestureRecognizer:_tap1];
    
}
-(BOOL)textFieldShouldClear:(UITextField *)textField {
    self.searchSuggestView.keywords = @"";
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self.collectionView removeGestureRecognizer:_tap1];
//    if (_resultArr.count < 1) {
        self.searchSuggestView.hidden = YES;
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
