//
//  BaseWebView.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/16.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseWebView.h"
#import <Masonry.h>
@implementation BaseWebView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:@"BaseWebViewEstimatedProgress"];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:@"BaseWebViewEstimatedProgress"];
    }
    return self;
}
-(UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectZero];
        [self addSubview:_progressView];
        TO_WEAK(self, weakSelf);
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            TO_STRONG(weakSelf, strongSelf);
            make.left.top.right.equalTo(strongSelf);
            make.height.mas_equalTo(4);
        }];
        _progressView.backgroundColor = [UIColor whiteColor];
        _progressView.progressTintColor = SystemColor;
        _progressView.trackTintColor = [UIColor whiteColor];
        _progressView.alpha = 0.8;
    }
    return _progressView;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.estimatedProgress;
        if (self.progressView.progress == 1 || self.progressView.progress == 0) {
            self.progressView.hidden = YES;
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)dealloc {
//    [self removeObserver:self forKeyPath:@"estimatedProgress" context:@"BaseWebViewEstimatedProgress"];
    debugMethod();
}
@end
