//
//  HomeController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/1.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "HomeController.h"
#import "BrowserView.h"
#import "UITools.h"
#import "HomeView.h"
#import "SearchController.h"
#import "DisclaimerController.h"
#import "BaseNavigationController.h"
#import "AlertView.h"
#import "Tools.h"
@interface HomeController ()<BrowserViewDelegate,HomeViewScrollDelegate> {
    BrowserView *_browser;
}

@end

@implementation HomeController
-(void)awakeFromNib{
    [super awakeFromNib];
    self.arrowType = noArrow;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self showDisclaimerController];
    [Tools checkAPPUpdate];
    NSNumber *launchCount = UserDefaultsGet(@"launchCount");
    if (!launchCount) {
        UserDefaultsSet(@(1), @"launchCount");
    } else {
        if (launchCount.intValue > 5) {
            [self showYoumiAdSpotPlayWithFinishCallBackBlock:^(BOOL isFinish) {
                
            }];
        } else {
            launchCount = @([launchCount intValue] + 1);
            UserDefaultsSet(launchCount, @"launchCount");
        }
        
    }
    
}

- (void)showDisclaimerController{
    if (AFNetworkReachabilityManager.sharedManager.isReachable || AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        if (!UserDefaultsGet(HAS_LAUNCHED)) {
            
            //        DisclaimerController *disclaimerController = [[DisclaimerController alloc]init];
            //        disclaimerController.arrowType = noArrow;
            //        BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:disclaimerController];
            //        [self presentViewController:navi animated:YES completion:NULL];
            [[[AlertView alloc]initWithUrl:WMH_DISCLAIMET buttonTitle:@"同意" clickBlock:^(NSInteger index) {
                UserDefaultsSet(@(YES), HAS_LAUNCHED);
            }]show] ;
        }
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent) animated:YES];

}

- (void)configUI{
    UIView *naviBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KNavigationBarHeight)];
    naviBar.backgroundColor = SystemColor;
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(KContentEdge, naviBar.height - 10 - 25, 25, 25)];
    icon.image = [UIImage imageNamed:@"nav_icon"];
    [naviBar addSubview:icon];
    [self.view addSubview:naviBar];
    UILabel *titleLabel = [LabelTool createLableWithFrame:CGRectMake(icon.right + 5, icon.top, 80, icon.height) textColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:15]];
    titleLabel.text = @"HEAVEN";
    [naviBar addSubview:titleLabel];
    
    UIButton *searchButon = [ButtonTool createButtonWithImageName:@"ic_search" addTarget:self action:@selector(toSearch)];
    searchButon.frame = CGRectMake(titleLabel.right , titleLabel.top, kScreenWidth - titleLabel.right - KContentEdge, 25);
    [searchButon setTitle:@"搜索" forState:(UIControlStateNormal)];
    [searchButon setTitleColor:K9BColor forState:UIControlStateNormal];
    searchButon.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchButon setTintColor:K9BColor];
    [searchButon setCornerRadius:12.5];
    searchButon.backgroundColor = [UIColor whiteColor];
    searchButon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchButon.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    searchButon.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [naviBar addSubview:searchButon];
    searchButon.imageView.tintColor = K9BColor;
    NSArray<NSString *> *titles = @[@"热播",@"电影",@"电视",@"动漫",@"综艺",@"微电影",@"少儿"];
    NSMutableArray<UIView *> *views = @[].mutableCopy;
    for (int i = 0; i < titles.count; i ++) {
        HomeView *view = [[HomeView alloc]init];
        view.delegate = self;
//        view.type = i == 5 ? i + 1 : i;
        view.type = i;
        [views addObject:view];
    }
    _browser = [[BrowserView alloc]initWithFrame:CGRectMake(0, naviBar.bottom, kScreenWidth, kScreenHeight - naviBar.height - KTabBarHeight) titles:titles subviews:views delegate:self];
    [self.view addSubview:_browser];
    _browser.scrollView.bounces = NO;
   
}
-(void)browserView:(BrowserView *)browserView didSelectTitle:(NSInteger)index title:(NSString *)title{
    
    
}
-(void)browserView:(BrowserView *)browserView didShowPage:(UIView *)PageView page:(NSInteger)page {
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height, top;
    
    if (scrollView.contentOffset.y > 0) {
        top = KStatusBarHeight + 5;

    } else {
        
        top = KNavigationBarHeight;
    }
    height = kScreenHeight - top - KTabBarHeight;
    if (_browser.height == height) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        _browser.frame = CGRectMake(0, top, kScreenWidth, height);
        _browser.scrollView.height = height - TitleBarHeight;
        for (UIView *view in _browser.scrollView.subviews) {
            view.height = height - TitleBarHeight;
        }
    }];
}
#pragma mark -- 去搜索
- (void)toSearch{
    SearchController *searchVC = [[SearchController alloc]init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
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
