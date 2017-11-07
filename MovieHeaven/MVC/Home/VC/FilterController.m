//
//  FilterController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/6.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "FilterController.h"
#import "BrowserView.h"
#import "FilterView.h"

@interface FilterController () <BrowserViewDelegate>

@end

@implementation FilterController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        [self setDefaultValue];
    }
    return self;
}
- (void)setDefaultValue{
    self.genre = @"全部";
    self.year = @"全部";
    self.country = @"全部";
    self.sortby = @"time";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"影视筛选";
    
    NSLog(@"%@%@%@%@",self.genre,self.year,self.country,self.sortby);
    NSArray<NSString *> *titles = @[@"电影",@"电视",@"动漫",@"综艺",@"微电影",@"少儿"];
    NSMutableArray<UIView *> *views = @[].mutableCopy;
    for (int i = 0; i < titles.count; i ++) {
        FilterView *view = [[FilterView alloc]init];
        view.type = i + 1;
        if (view.type == self.type) {
            view.genre = self.genre;
            view.year = self.year;
            view.country = self.country;
            view.sortby = self.sortby;
        }else{
            view.genre = @"全部";
            view.year = @"全部";
            view.country = @"全部";
            view.sortby = self.sortby;
        }
        [views addObject:view];
    }
    BrowserView *browser = [[BrowserView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - KNavigationBarHeight) titles:titles subviews:views delegate:self];
    if (self.type < titles.count) {
        [browser selectIndex:self.type - 1 >= 0 ? self.type - 1 : self.type];
    }
    
    [self.view addSubview:browser];
}
-(void)browserView:(BrowserView *)browserView didSelectTitle:(NSInteger)index title:(NSString *)title{
    
    
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
