//
//  VideoDetailController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/2.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "VideoDetailController.h"
#import "SourceModel.h"
#import "SourceTypeModel.h"
#import "Tools.h"
#import <ZFPlayer.h>
#import <Masonry.h>
#import <MediaPlayer/MediaPlayer.h>
#import "EmptyView.h"
#import "UITools.h"
#import "AlertView.h"
#import "BrowserView.h"
#import "VideoDetailView.h"
#import "VideoCommentView.h"
#import <WebKit/WebKit.h>
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import <MBProgressHUD.h>
#import "LoginController.h"
#import "UserInfo.h"
@interface VideoDetailController () <ZFPlayerDelegate,BrowserViewDelegate> {
    
    NSMutableArray *_sources;
    NSMutableArray *_sourceTypes;
    NSInteger _currentTypeIndex;
    NSString *_img;
    NSString *_desc;
    
    NSString *_videoStatus;
    NSString *_score;
    NSString *_videoType;
    NSString *_actors;
    NSNumber *_cid;
    
}
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic,strong)ZFPlayerView *playerView;
@property (nonatomic,strong)UIView *playerBgView;
@property (nonatomic,strong)ZFPlayerModel *playerModel;
@property (nonatomic, strong)UIButton *sourceBtn;
@property (nonatomic, strong)UIButton *collectBtn;
@property (nonatomic, strong)UIButton *downLoadBtn;
@property (nonatomic, strong)VideoDetailView *videoDetailView;
@property (nonatomic, strong)VideoCommentView *videoCommentView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong)UIButton *backArrow;
@end

@implementation VideoDetailController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.from = @"index";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sources = @[].mutableCopy;
     _sourceTypes = @[].mutableCopy;
    [self createUI];
    [self requestVideo];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent) animated:YES];
    [[UIApplication sharedApplication]setStatusBarHidden:NO animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO animated:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.playerView pause];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.playerView.state == ZFPlayerStatePause) {
        [self.playerView play];
    }
}
- (void)createUI{
    self.title = self.videoName;
//  statusBar
    UIView *statusBar = [[UIView alloc]init];
    statusBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusBar];
    
    [statusBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(KStatusBarHeight);
    }];
    
//    playerBgView
    self.playerBgView = [[UIView alloc]init];
    self.playerBgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.playerBgView];
    TO_WEAK(self, weakSelf)
    [self.playerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.left.equalTo(strongSelf.view);
        make.top.equalTo(statusBar.mas_bottom);
        make.right.equalTo(strongSelf.view);
        make.height.mas_equalTo(kScreenWidth / 16.f * 9);
    }];

    
//    toolBar
    
    UIView *toolBar = [[UIView alloc]init];
    [self.view addSubview:toolBar];
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playerBgView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
//    切换源
    self.sourceBtn = [ButtonTool createButtonWithImageName:nil addTarget:self action:@selector(chooseSource)];
    
    [toolBar addSubview:self.sourceBtn];
    [self.sourceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 28));
        make.centerY.equalTo(toolBar);
        make.right.equalTo(toolBar).mas_offset(0-(KContentEdge));
        
    }];
    ;
    UIView *hline = [UIView new];
    hline.backgroundColor = KECColor;
    [toolBar addSubview:hline];
    
    [hline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(toolBar);
        make.left.equalTo(toolBar);
        make.right.equalTo(toolBar);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *vline1 = [UIView new];
    vline1.backgroundColor = KECColor;
    [toolBar addSubview:vline1];
    [vline1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toolBar).mas_offset(5);
        make.bottom.equalTo(toolBar).mas_offset(-5);
        
        make.right.equalTo(self.sourceBtn.mas_left).mas_offset(-12);
        make.width.mas_equalTo(0.5);
    }];
//    分享
    UIButton *shareBtn = [ButtonTool createButtonWithImageName:@"share_icon" addTarget:self action:@selector(shareVideo)];
    
    [toolBar addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 28));
        make.centerY.equalTo(toolBar);
        make.right.equalTo(vline1).mas_offset(-12);
        
    }];
    
    UIView *vline2 = [UIView new];
    vline2.backgroundColor = KECColor;
    [toolBar addSubview:vline2];
    [vline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toolBar).mas_offset(5);
        make.bottom.equalTo(toolBar).mas_offset(-5);
        
        make.right.equalTo(shareBtn.mas_left).mas_offset(-12);
        make.width.mas_equalTo(0.5);
    }];
//    收藏
    self.collectBtn = [ButtonTool createButtonWithImageName:@"collect_normal" addTarget:self action:@selector(collectVideo)];
    [self.collectBtn setImage:[UIImage imageNamed:@"collect_selected"] forState:UIControlStateSelected];
    [toolBar addSubview:self.collectBtn];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(toolBar);
        make.right.equalTo(vline2).mas_offset(-12);
        
    }];
//    UIView *vline3 = [UIView new];
//    vline3.backgroundColor = KECColor;
//    [toolBar addSubview:vline3];
//    [vline3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(toolBar).mas_offset(5);
//        make.bottom.equalTo(toolBar).mas_offset(-5);
//
//        make.right.equalTo(self.collectBtn.mas_left).mas_offset(-12);
//        make.width.mas_equalTo(0.5);
//    }];
//    //    下载
//    self.downLoadBtn = [ButtonTool createButtonWithImageName:@"icon_download" addTarget:self action:@selector(downLoadVideo)];
//    [self.downLoadBtn setImage:[UIImage imageNamed:@"icon_download_press"] forState:UIControlStateSelected];
//    [toolBar addSubview:self.downLoadBtn];
//    [self.downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(28, 28));
//        make.centerY.equalTo(toolBar);
//        make.right.equalTo(vline3).mas_offset(-12);
//
//    }];
    [self createDetaillUI];
    
    
    
    
//    返回箭头
    self.backArrow = [ButtonTool createButtonWithImageName:@"" addTarget:self action:@selector(goBack)];
    [self.view addSubview:self.backArrow];
    [self.backArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.left.equalTo(strongSelf.view).mas_offset(5); //
        make.top.equalTo(strongSelf.view).mas_offset(KStatusBarHeight + 5); //20
        make.size.mas_equalTo(CGSizeMake(50,41));//12 21
    }];
    UIImageView *backArrowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"backArrow_white"]];
    [self.backArrow addSubview:backArrowImg];
    [backArrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.left.equalTo(strongSelf.backArrow).mas_offset(KContentEdge - 5);
        make.top.equalTo(strongSelf.backArrow).mas_offset(10); //20
        make.size.mas_equalTo(CGSizeMake(12,21));//12 21
    }];
    
    //    emptyView
    _emptyView = [[EmptyView alloc]initWithFrame:CGRectZero icon:nil tip:nil tapBlock:^{
        TO_STRONG(weakSelf, strongSelf)
        [strongSelf requestVideo];
    }];
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf.view);
    }];
    
    _emptyView.hidden = YES;
}
#pragma mark -- 创建底部详情和评价
- (void)createDetaillUI{
    CGFloat top = KStatusBarHeight + kScreenWidth / 16.f * 9 + 40;
    self.videoDetailView = [[VideoDetailView alloc]init];
    self.videoCommentView = [[VideoCommentView alloc]init];
    BrowserView *browserView = [[BrowserView alloc]initWithEqualizationTitlesWithFrame:CGRectMake(0,top, kScreenWidth, kScreenHeight - top) titles:@[@"详情",@"评论"] subviews:@[self.videoDetailView,self.videoCommentView] delegate:self];
    browserView.scrollView.bounces = NO;
    [self.view addSubview:browserView];
    
    TO_WEAK(self, weakSelf)
    self.videoDetailView.clickVideoItem = ^(NSInteger index) {
        TO_STRONG(weakSelf, strongSelf)

        SourceModel *model = strongSelf->_sources[index];
        NSLog(@"正在播放%@",model.name);
        [strongSelf parseWithModel:model];
        
    };
}
#pragma mark -- 下载
- (void)downLoadVideo {
    AlertView *alert = [[AlertView alloc]initWithText:@"功能开发中" buttonTitle:@"确定" clickBlock:^(NSInteger index) {
        
    }];
    [alert show];
}
#pragma mark -- 收藏
- (void)collectVideo{

    if (![UserInfo read]) {
        //        登录
        LoginController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginController"];
        loginVC.completion = ^(UserInfo *user) {
            [self collectVideo];
        };
        [self.tabBarController presentViewController:loginVC animated:YES completion:NULL];
    }
    if (self.collectStateChange) {
        self.collectStateChange();
    }
    if (self.collectBtn.isSelected) {
//        取消收藏
        [self cancelCollectionRequest];
    } else {
//        收藏
        [self addCollectionRequest];
    }
    
}
#pragma mark -- 检查是否收藏
- (void)checkCollectStatus {
    
    NSDictionary *data = @{
                           @"videoId": @(self.videoId),
                           };
    
    [HttpHelper GETWithWMH:WMH_COLLECT_CHECK headers:nil parameters:data HUDView:self.view progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
        
        if ([data[@"status"] isEqualToString:@"B0000"]) {
            BOOL isCollected = [data[@"isCollected"] boolValue];
            self.collectBtn.selected = isCollected;
            if (isCollected) {
                _cid = data[@"cid"];
                
            }else {
                
            }
        }else {
            
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark -- 添加收藏请求
- (void)addCollectionRequest {
    NSDictionary *data = @{
                           @"videoId": @(self.videoId),
                           @"videoName": self.videoName,
                           @"videoStatus": _videoStatus ? _videoStatus : [NSNull null],
                           @"score": _score ? _score : [NSNull null],
                           @"videoType": _videoType ? _videoType : [NSNull null] ,
                           @"actors": _actors ? _actors : [NSNull null],
                           @"img": _img ? _img : [NSNull null]
                           };

    [HttpHelper POSTWithWMH:WMH_COLLECT_ADD headers:nil parameters:data HUDView:self.view progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
        [[ToastView sharedToastView] show:data[@"txt"] inView:nil];
        if ([data[@"status"] isEqualToString:@"B0000"]) {
            self.collectBtn.selected = YES;
            _cid = data[@"cid"];
        }else {
            self.collectBtn.selected = NO;
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark -- 取消收藏请求
- (void)cancelCollectionRequest {
    NSDictionary *data = @{
                           @"cid": _cid ? _cid : [NSNull null],
                           };
    
    [HttpHelper POSTWithWMH:WMH_COLLECT_CANCEL headers:nil parameters:data HUDView:self.view progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
        [[ToastView sharedToastView] show:data[@"txt"] inView:nil];
        if ([data[@"status"] isEqualToString:@"B0000"]) {
            self.collectBtn.selected = NO;
            _cid = nil;
        }else {
            
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark -- 分享视频
- (void)shareVideo{

    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        if (platformType == 1000) {
                NSString *url = ShareVideo(self.videoId);
                NSLog(@"shareURL : %@",url);
                UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
            
                pasteboard.string = url;
                AlertView *alert = [[AlertView alloc]initWithText:[NSString stringWithFormat:@"分享\n\n视频链接\n%@\n已经复制到粘贴板",url] buttonTitle:@"确定" clickBlock:^(NSInteger index) {
            
                }];
                [alert show];
        }else{
            [self shareWebPageToPlatformType:platformType];
        }
        
    }];
}

#pragma mark -- 选择源
- (void)chooseSource{
    
    AlertView *alert = [[AlertView alloc]initWithTitle:@"选择播放源" items:_sourceTypes cancelTitle:@"取消" sureTitle:@"确定" cancelBlock:^(NSInteger index) {
        
    } sureBlock:^(NSInteger index) {
        if (_currentTypeIndex == index) {
            return ;
        }
        _currentTypeIndex = index;
        [self requestSource];
    }];
    alert.selectedIndex = _currentTypeIndex;
    [alert show];
}
- (void)setSource:(SourceTypeModel *)model{
    
    [self.sourceBtn setImage:[UIImage imageNamed:model.logo] forState:UIControlStateNormal];
    
}
#pragma mark -- 请求源
- (void)requestSource{
    
    SourceTypeModel *typeModel = _sourceTypes[_currentTypeIndex];
    NSDictionary *params = @{
                             @"movieId": @(self.videoId),
                             @"name": typeModel.name,
                             @"type": typeModel.type
                             };
    [HttpHelper GET:VideoSource headers:nil parameters:params HUDView:self.view progress:NULL success:^(NSURLSessionDataTask *task, NSDictionary *response) {
        if ([response[@"code"] integerValue] != 0) {
            [[ToastView sharedToastView]show:response[@"message"] inView:nil];
            
        }else{
            
            NSArray *body = response[@"body"];
            [_sources removeAllObjects];
            for (NSDictionary *source in body) {
                SourceModel *model = [[SourceModel alloc]initWithDictionary:source error:nil];
                model.typeModel = typeModel;
                [_sources addObject:model];
            }
            self.videoDetailView.sources = _sources;
            [[ToastView sharedToastView]show:@"切换源成功" inView:nil];
            [self setSource:typeModel];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
}
#pragma mark -- 请求视频详情
- (void)requestVideo{
    NSDictionary *params = @{
                             @"videoId": @(self.videoId),
                             @"from": self.from
                             };
    [HttpHelper GET:Video headers:nil parameters:params HUDView:self.view progress:NULL success:^(NSURLSessionDataTask *task, NSDictionary *response) {
        if ([response[@"code"] integerValue] != 0) {
            [[ToastView sharedToastView]show:response[@"message"] inView:nil];
            _emptyView.hidden = NO;
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault) animated:YES];
        }else{
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent) animated:YES];
            [self checkCollectStatus];
            NSDictionary *body = response[@"body"];
            NSString *desc = body[@"desc"];
            NSRange range = [desc rangeOfString:@"新电影天堂网站上线了,xiaokanba.com(小看吧),电脑也能在线看高清影视啦."];
            if (range.location != NSNotFound) {
                desc = [desc substringFromIndex:range.location + range.length];
            }
            _desc = desc;
            _img = body[@"img"];
            _videoStatus = body[@"status"];
            _score = body[@"score"];
            _actors = body[@"actors"];
            _videoType = body[@"type"];
            NSString *detailStr = [NSString stringWithFormat:@"%@\n上映: %@\n状态: %@\n类型: %@\n主演: %@\n地区: %@\n影片评分: %@\n更新日期: %@\n %@",body[@"name"],body[@"release"],_videoStatus,_videoType,_actors,body[@"area"],_score,body[@"updateDate"],desc];
            self.videoDetailView.detailText = [detailStr stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            NSArray *sourceTypes = body[@"sourceTypes"];
            NSArray *sources = body[@"sources"];
            if (!sources || sources.count < 1) {
                _emptyView.hidden = NO;
                
            }else{
                _emptyView.hidden = YES;
            }
            if (sources.count > 0) {
                NSDictionary *urlParams = [Tools getURLParameters:sources.firstObject[@"playUrl"]];
                NSString *name = urlParams[@"name"];
                NSString *type = urlParams[@"type"];
                for (int i =0 ; i< sourceTypes.count; i ++) {
                    NSDictionary *sourceType = sourceTypes[i];
                    SourceTypeModel *model = [[SourceTypeModel alloc]initWithDictionary:sourceType error:nil];
                    if ([type isEqualToString:Kan360]) {
                        if ([name isEqualToString:model.name]) {
                            _currentTypeIndex = i;
                            [self setSource:model];
                        }
                    }else{
                        if ([type isEqualToString:model.type]) {
                            _currentTypeIndex = i;
                            [self setSource:model];
                        }
                    }
                    
                    [_sourceTypes addObject:model];
                }
            }
            
            for (NSDictionary *source in sources) {
                SourceModel *model = [[SourceModel alloc]initWithDictionary:source error:nil];
                model.typeModel = _sourceTypes[_currentTypeIndex];
                [_sources addObject:model];
            }
            self.videoDetailView.sources = _sources;
            SourceModel *firstModel = _sources.firstObject;
            [self parseWithModel:firstModel];
            
            
            
            
        }
        
    } failure:^(NSError *error) {
        _emptyView.hidden = NO;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault) animated:YES];
    }];
}

-(ZFPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc]init];
        
        //        [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(self.videoDetailImageView);
        //            make.left.right.equalTo(self.videoDetailImageView);
        //            // 这里宽高比16：9，可以自定义视频宽高比
        //            make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f);
        //        }];
        
        // 初始化控制层view(可自定义)
        //        ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
        //
        [_playerView playerControlView:nil playerModel:self.playerModel];
//        _playerView.hasDownload    = YES;
        
        // 打开预览图
        _playerView.hasPreviewView = YES;
        // 设置代理
        _playerView.delegate = self;
    }
    return _playerView;
}
-(ZFPlayerModel *)playerModel{
    if (!_playerModel) {
        // 初始化播放模型
        _playerModel = [[ZFPlayerModel alloc]init];
        _playerModel.fatherView = self.playerBgView;
        
//        _playerModel.videoURL = ;
//        _playerModel.placeholderImageURLString =
//        _playerModel.title =
    }
    return _playerModel;
}
#pragma mark -- 解析视频
- (void)parseWithModel:(SourceModel *)sourceModel{
    SourceModel *model = sourceModel.copy;
    self.webView.hidden = YES;
    NSString *orgUrl = model.playUrl;
    NSString *sourceType = model.typeModel.type;
    if ([sourceType isEqualToString:Btpan]) {
        
        [self playVideo:model];
    }else {
        [HttpHelper GET:orgUrl headers:@{@"Content-Type":@"application/vnd.apple.mpegurl"} parameters:@{} HUDView:self.view progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)task.response;
            NSDictionary *allHeaders = res.allHeaderFields;
            
            
//            NSString *jsUrl = allHeaders[@"jsUrl"];
            NSString *infoUrl = allHeaders[@"infoUrl"];
            if ([sourceType isEqualToString:Kan360]) {
                NSDictionary *infoUrlParams = [Tools getURLParameters:infoUrl];
                NSString *innerUrl = infoUrl;
                if (infoUrlParams && infoUrlParams[@"url"]) {
                    innerUrl = infoUrlParams[@"url"];
                }
                NSRange range = [innerUrl rangeOfString:@"#"];
                NSString *vurl = innerUrl;
                if (range.location != NSNotFound) {
                    vurl = [innerUrl substringToIndex:range.location];
                    
                }
                if ([model.typeModel.name isEqualToString:FengXing] || [model.typeModel.name isEqualToString:HuaShu]) {
//                    使用v3解析
                    [self v3PraseVideoWithUrl:vurl sourceModel:model];
                }else if ([model.typeModel.name isEqualToString:PPTV]) {
//                    odl解析
                    [self parse_odlflVideoWithUrl:vurl sourceModel:model];
                }else{
                    [self praseVideoWithUrl:vurl sourceModel:model];
                }
                
                
            }else if ([sourceType isEqualToString:Thunder]) {
                //        base64 解码转换
                NSString *baseOrgUrl = [Tools base64DecodedString:infoUrl];
                [Tools thunderUrlToOrgUrl:baseOrgUrl];
            }else if ([sourceType isEqualToString:Xigua]) {
                //        base64 解码转换
                NSString *baseOrgUrl = [Tools base64DecodedString:infoUrl];
                model.playUrl = baseOrgUrl;
                [self playVideo:model];
            }
            
            
        } failure:^(NSError * _Nullable error) {
            if (error.code == -1016) {
                [self playVideo:model];
            }
        }];
        
    }
    
    
    
    
}
#pragma mark -- 解析请求V3
- (void)v3PraseVideoWithUrl:(NSString *)videoUrl sourceModel:(SourceModel *)model{
    [HttpHelper GET:VParsev3 headers:nil parameters:@{@"url":videoUrl} HUDView:self.view progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {
        if ([response[@"code"] integerValue] != 0) {
            if ([response[@"code"] integerValue] == -1) {
//                收费解析
                
                [self parse_odlflVideoWithUrl:videoUrl sourceModel:model];
            }else{
                [[ToastView sharedToastView]show:@"视频解析失败" inView:nil];
            }
            
        }else{
            NSDictionary *body = response[@"body"];
            NSArray *files = body[@"files"];
            
            if (files && files.count > 0) {
                model.playUrl = files.firstObject[@"url"];
                [self playVideo:model];
            }else{
                model.playUrl = body[@"url"];
                [self playVideo:model];
            }
            
        }
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark -- 解析请求
- (void)praseVideoWithUrl:(NSString *)videoUrl sourceModel:(SourceModel *)model{
    [HttpHelper GET:VideoParse headers:nil parameters:@{@"vurl":videoUrl} HUDView:self.view progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {
        //        {
        //            "result": {
        //                "v_id": 773764715,
        //                "v_type": "youku",
        //                "type": "m3u8",
        //                "url": "http://pl-ali.youku.com/playlist/m3u8?vid=773764715&type=hd2&ups_client_netip=118.31.7.34&ups_ts=1509783536&utid=WeRj4yB22MMDAKBXgWu87D%2Fj&ccode=01010101&psid=3adbb332d4dc058f2a5be28408009a28&ups_userid=1003415795&duration=6031&expire=18000&ups_key=81ab73365e4504893e99a1692aab6c3c",
        //                "defn": "mp4hd2_default",
        //                "defn_info": "超清",
        //                "defns": ["3gphd_default", "mp4hd2_default", "flvhd_default", "mp4hd_default"],
        //                "defn_infos": ["标清", "超清", "流畅", "高清"]
        //            },
        //            "code": 0
        //        }
        
        if ([response[@"code"] integerValue] != 0) {
            if ([response[@"code"] integerValue] == -1) {
                //                收费解析
                
                [self parse_odlflVideoWithUrl:videoUrl sourceModel:model];
            }else{
                [[ToastView sharedToastView]show:@"视频解析失败" inView:nil];
            }
            
        }else{
            NSDictionary *result = response[@"result"];
            NSArray *files = result[@"files"];
            if (files && files.count > 0) {
//                model.playUrl = files.firstObject[@"url"];
//                [self playVideo:model];
                [self parse_odlflVideoWithUrl:videoUrl sourceModel:model];
            }else{
                model.playUrl = result[@"url"];
                [self playVideo:model];
            }
            
        }
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark -- 收费解析请求
- (void)parse_odlflVideoWithUrl:(NSString *)videoUrl sourceModel:(SourceModel *)model{
    [HttpHelper GET:Parse_odlfl headers:nil parameters:@{@"vurl":videoUrl} HUDView:self.view progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {

        if ([response[@"code"] integerValue] != 0) {
            [[ToastView sharedToastView]show:@"视频解析失败" inView:nil];
            
        }else{
            NSDictionary *result = response[@"result"];
            NSString *type = result[@"type"];
            if ([type isEqualToString:@"list"]) {
                NSArray *files = result[@"files"];
                model.playUrl = files.firstObject[@"url"];
                NSString *referer = files.firstObject[@"referer"];
                [self aikanApiParseUrl:model.playUrl referer:referer sourceModel:model];
            }else{
                model.playUrl = result[@"url"];
                NSString *referer = result[@"referer"];
                [self aikanApiParseUrl:model.playUrl referer:referer sourceModel:model];
            }
            
        }
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark -- 爱看解析
- (void)aikanApiParseUrl:(NSString *)url referer:(NSString *)referer sourceModel:(SourceModel *)model{
    self.webView.hidden = NO;
    self.playerModel.videoURL = nil;
    [self.playerView resetToPlayNewVideo:self.playerModel];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request addValue:referer forHTTPHeaderField:@"Referer"];
    [self.webView loadRequest:request];

}
#pragma mark -- webView;
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.backgroundColor = [UIColor whiteColor];
        [self.playerView addSubview:_webView];
        TO_WEAK(self, weakSelf)
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            TO_STRONG(weakSelf, strongSelf)
            make.edges.equalTo(strongSelf.playerView);
        }];
    }
    return _webView;
}
#pragma mark -- 播放视频
- (void)playVideo:(SourceModel *)model{
    self.playerModel.videoURL = [NSURL URLWithString:model.playUrl];
    self.playerModel.title = [NSString stringWithFormat:@"%@ %@",self.videoName,model.name];
    self.playerModel.placeholderImageURLString = model.image;
    [self.playerView resetToPlayNewVideo:self.playerModel];
}
    
#pragma mark -- 分享
    
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
    {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        dispatch_main_async_safe(^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        })
        
//        下载图片 
        [[YYWebImageManager sharedManager]requestImageWithURL:[NSURL URLWithString:_img] options:0 progress:NULL transform:NULL completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            dispatch_main_async_safe((^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //创建网页内容对象
                UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.videoName descr:_desc thumImage:image];
                //设置网页地址
                
                shareObject.webpageUrl = ShareVideo(self.videoId);
                
                //分享消息对象设置分享内容对象
                messageObject.shareObject = shareObject;
                
                //调用分享接口
                [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                    if (error) {
                        UMSocialLogInfo(@"************Share fail with error %@*********",error);
                        [[ToastView sharedToastView]show:[NSString stringWithFormat:@"%@",error] inView:nil];
                    }else{
                        if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                            UMSocialShareResponse *resp = data;
                            //分享结果消息
                            UMSocialLogInfo(@"response message is %@",resp.message);
                            //第三方原始返回的数据
                            UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                            [[ToastView sharedToastView]show:resp.message inView:nil];
                        }else{
                            UMSocialLogInfo(@"response data is %@",data);
                        }
                    }
                    
                    
                }];
            }))
            
            
        }];
        
}
    
    
#pragma mark -- ZFPLayer
/** 返回按钮事件 */
- (void)zf_playerBackAction{
    [_playerView removeFromSuperview];
    _playerView =  nil;
    [self goBack];
}
/** 下载视频 */
- (void)zf_playerDownload:(NSString *)url{
 
}
/** 控制层即将显示 */
- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen{
    [UIView animateWithDuration:0.3 animations:^{
        self.backArrow.alpha = 0;
    } completion:^(BOOL finished) {
        self.backArrow.hidden = YES;
    }];
}
/** 控制层即将隐藏 */
- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen{
    [UIView animateWithDuration:0.3 animations:^{
        self.backArrow.alpha = 1;
    } completion:^(BOOL finished) {
        self.backArrow.hidden = NO;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    QLLogFunction;
    if (_playerView) {
        [_playerView removeFromSuperview];
        _playerView  = nil;
    }
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
