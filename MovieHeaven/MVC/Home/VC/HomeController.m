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
@interface HomeController ()<BrowserViewDelegate>

@end

@implementation HomeController
-(void)awakeFromNib{
    [super awakeFromNib];
    self.arrowType = noArrow;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent) animated:YES];
}

- (void)configUI{
    UIView *naviBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KNavigationBarHeight)];
    naviBar.backgroundColor = SystemColor;
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, naviBar.height - 10 - 25, 25, 25)];
    icon.image = [UIImage imageNamed:@"nav_icon"];
    [naviBar addSubview:icon];
    [self.view addSubview:naviBar];
    UILabel *titleLabel = [LabelTool createLableWithFrame:CGRectMake(icon.right + 5, icon.top, 80, icon.height) textColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:15]];
    titleLabel.text = @"HEAVEN";
    [naviBar addSubview:titleLabel];
    
    UIButton *searchButon = [ButtonTool createButtonWithImageName:@"ic_search" addTarget:self action:@selector(toSearch)];
    searchButon.frame = CGRectMake(titleLabel.right , titleLabel.top, kScreenWidth - titleLabel.right - 15, 25);
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
//        view.type = i == 5 ? i + 1 : i;
        view.type = i;
        [views addObject:view];
    }
    BrowserView *browser = [[BrowserView alloc]initWithFrame:CGRectMake(0, naviBar.bottom, kScreenWidth, kScreenHeight - naviBar.height - KTabBarHeight) titles:titles subviews:views delegate:self];
    [self.view addSubview:browser];
   
}
-(void)browserView:(BrowserView *)browserView didSelectTitle:(NSInteger)index title:(NSString *)title{
    
    
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
