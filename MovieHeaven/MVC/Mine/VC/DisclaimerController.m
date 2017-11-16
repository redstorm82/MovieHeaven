//
//  DisclaimerController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/12.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "DisclaimerController.h"
#import <Masonry.h>
#import "UITools.h"
#import "BaseWebView.h"
@interface DisclaimerController (){
    BaseWebView *_webView;
}

@end

@implementation DisclaimerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"免责声明";
    _webView = [[BaseWebView alloc]init];
    [self.view addSubview:_webView];
    TO_WEAK(self, weakSelf)
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf.view);
    }];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:WMH_DISCLAIMET]]];
    if (self.arrowType == noArrow) {
        [_webView mas_updateConstraints:^(MASConstraintMaker *make) {
            TO_STRONG(weakSelf, strongSelf)
            make.bottom.equalTo(strongSelf.view.mas_bottom).mas_offset(-40);
        }];
        
        UIButton *agreeBtn = [ButtonTool createBlockButtonWithTitle:@"同意" titleColor:[UIColor whiteColor] titleFont:nil block:^(UIButton *button) {
            UserDefaultsSet(@(YES), HAS_LAUNCHED);
            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
        agreeBtn.backgroundColor = SystemColor;
        [self.view addSubview:agreeBtn];
        [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(_webView.mas_bottom);
        }];
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
