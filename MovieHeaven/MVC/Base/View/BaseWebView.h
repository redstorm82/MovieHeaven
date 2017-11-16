//
//  BaseWebView.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/16.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface BaseWebView : WKWebView
@property (nonatomic, strong) UIProgressView *progressView;
@end
