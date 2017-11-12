//
//  DisclaimerController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/12.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "DisclaimerController.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>
@interface DisclaimerController (){
    WKWebView *_webView;
}

@end

@implementation DisclaimerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"免责声明";
    _webView = [[WKWebView alloc]init];
    [self.view addSubview:_webView];
    TO_WEAK(self, weakSelf)
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf.view);
    }];

    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://sims.bestudent.cn/bbInstalmentAgre.html"]]];
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
