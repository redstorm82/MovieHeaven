//
//  ShortVideoController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/9.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "ShortVideoController.h"
#import "ShortVideoListView.h"
#import "BrowserView.h"
@interface ShortVideoController () <BrowserViewDelegate> {
    BrowserView *_browser;
}

@end

@implementation ShortVideoController
-(void)awakeFromNib {
    [super awakeFromNib];
    self.arrowType = noArrow;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"短视频";
    NSArray<NSString *> *titles = @[@"搞笑",@"娱乐",@"游戏",@"音乐",@"影视",@"军事",@"社会",@"汽车",@"生活",@"科技",@"体育"];
    NSMutableArray<UIView *> *views = @[].mutableCopy;
    for (int i = 0; i < titles.count; i ++) {
        ShortVideoListView *view = [[ShortVideoListView alloc]init];
        
        view.tid = i + 1;
        if (i < 2) {
            [view requestShortVideoList:YES];
        }
        [views addObject:view];
    }
    _browser = [[BrowserView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KNavigationBarHeight - KTabBarHeight) titles:titles subviews:views delegate:self];
    [self.view addSubview:_browser];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault) animated:NO];
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    for (UIView *view in _browser.scrollView.subviews) {
        if ([view isKindOfClass:[ShortVideoListView class]]) {
            [((ShortVideoListView *)view) resetPlayer];
        }
        
    }
}
-(void)browserView:(BrowserView *)browserView didShowPage:(UIView *)PageView page:(NSInteger)page{
    ShortVideoListView *view = (ShortVideoListView *)PageView;
    if (view.shortVideoList.count < 1 && page > 1) {
        [view requestShortVideoList:YES];
    }
    for (UIView *view in _browser.scrollView.subviews) {
        if ([view isEqual:PageView]) {
            return;
        }
        if ([view isKindOfClass:[ShortVideoListView class]]) {
            [((ShortVideoListView *)view) resetPlayer];
        }
        
    }

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
