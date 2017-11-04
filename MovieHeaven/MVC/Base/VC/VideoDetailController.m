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
@interface VideoDetailController () <ZFPlayerDelegate,BrowserViewDelegate> {
    
    NSMutableArray *_sources;
    NSMutableArray *_sourceTypes;
    NSInteger _currentTypeIndex;
    
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

@end

@implementation VideoDetailController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
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
    UIButton *shareBtn = [ButtonTool createButtonWithImageName:@"act_shareicn_icon_normal" addTarget:self action:@selector(shareVideo)];
    [shareBtn setImage:[UIImage imageNamed:@"act_shareicn_icon_pressed"] forState:UIControlStateHighlighted];
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
    self.collectBtn = [ButtonTool createButtonWithImageName:@"act_video_icon_normal" addTarget:self action:@selector(collectVideo)];
    [self.collectBtn setImage:[UIImage imageNamed:@"act_video_icon_pressed"] forState:UIControlStateSelected];
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
}
#pragma mark -- 创建底部详情和评价
- (void)createDetaillUI{
    CGFloat top = KStatusBarHeight + kScreenWidth / 16.f * 9 + 40;
    self.videoDetailView = [[VideoDetailView alloc]init];
    self.videoCommentView = [[VideoCommentView alloc]init];
    BrowserView *browserView = [[BrowserView alloc]initWithEqualizationTitlesWithFrame:CGRectMake(0,top, kScreenWidth, kScreenHeight - top) titles:@[@"详情",@"评论"] subviews:@[self.videoDetailView,self.videoCommentView] delegate:self];
    browserView.scrollView.bounces = NO;
    [self.view addSubview:browserView];
    
    
    [self.videoDetailView addObserver: self forKeyPath: @"currentIndex" options: NSKeyValueObservingOptionNew context: nil];
}
#pragma mark -- 下载
- (void)downLoadVideo {
    AlertView *alert = [[AlertView alloc]initWithText:@"功能开发中" buttonTitle:@"确定" clickBlock:^(NSInteger index) {
        
    }];
    [alert show];
}
#pragma mark -- 收藏
- (void)collectVideo{
    
}
#pragma mark -- 分享视频
- (void)shareVideo{
    NSString *url = ShareVideo(self.videoId);
    NSLog(@"shareURL : %@",url);
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = url;
    AlertView *alert = [[AlertView alloc]initWithText:[NSString stringWithFormat:@"分享\n\n视频链接\n%@\n已经复制到粘贴板",url] buttonTitle:@"确定" clickBlock:^(NSInteger index) {
        
    }];
    [alert show];
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
    
    SourceTypeModel *model = _sourceTypes[_currentTypeIndex];
    NSDictionary *params = @{
                             @"movieId": @(self.videoId),
                             @"name": model.name,
                             @"type": model.type
                             };
    [HttpHelper GET:VideoSource headers:nil parameters:params HUDView:self.view progress:NULL success:^(NSURLSessionDataTask *task, NSDictionary *response) {
        if ([response[@"code"] integerValue] != 0) {
            [[ToastView sharedToastView]show:response[@"message"] inView:nil];
            
        }else{
            
            NSArray *body = response[@"body"];
            [_sources removeAllObjects];
            for (NSDictionary *source in body) {
                SourceModel *model = [[SourceModel alloc]initWithDictionary:source error:nil];
                [_sources addObject:model];
            }
            self.videoDetailView.sources = _sources;
            [[ToastView sharedToastView]show:@"切换源成功" inView:nil];
            [self setSource:model];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
}
#pragma mark -- 请求视频
- (void)requestVideo{
    NSDictionary *params = @{
                             @"videoId": @(self.videoId),
                             @"from": @"index"
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
            
            NSDictionary *body = response[@"body"];
            NSString *desc = body[@"desc"];
            NSRange range = [desc rangeOfString:@"新电影天堂网站上线了,xiaokanba.com(小看吧),电脑也能在线看高清影视啦."];
            if (range.location != NSNotFound) {
                desc = [desc substringFromIndex:range.location + range.length];
            }
            NSString *detailStr = [NSString stringWithFormat:@"上映: %@\n状态: %@\n类型: %@\n主演: %@\n地区: %@\n影片评分: %@\n更新日期: %@\n %@",body[@"release"],body[@"status"],body[@"type"],body[@"actors"],body[@"area"],body[@"score"],body[@"updateDate"],desc];
            self.videoDetailView.detailText = [detailStr stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            
            NSArray *sources = body[@"sources"];
            if (!sources || sources.count < 1) {
                _emptyView.hidden = NO;
            }else{
                _emptyView.hidden = YES;
            }
            NSArray *sourceTypes = body[@"sourceTypes"];
            for (NSDictionary *source in sources) {
                SourceModel *model = [[SourceModel alloc]initWithDictionary:source error:nil];
                [_sources addObject:model];
            }
            self.videoDetailView.sources = _sources;
            SourceModel *firstModel = _sources.firstObject;
            [self playWithModel:firstModel];
            
            NSDictionary *urlParams = [Tools getURLParameters:firstModel.playUrl];
            NSString *typeName = urlParams[@"type"];
            for (int i =0 ; i< sourceTypes.count; i ++) {
                NSDictionary *sourceType = sourceTypes[i];
                SourceTypeModel *model = [[SourceTypeModel alloc]initWithDictionary:sourceType error:nil];
                if ([typeName isEqualToString:model.type]) {
                    _currentTypeIndex = i;
                    [self setSource:model];
                }
                [_sourceTypes addObject:model];
            }
            
            
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
        _playerView.hasDownload    = YES;
        
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
//        _playerModel.placeholderImageURLString =
//        _playerModel.title =
    }
    return _playerModel;
}
#pragma mark -- 播放视频
- (void)playWithModel:(SourceModel *)model{
    
    self.playerModel.videoURL = [NSURL URLWithString:model.playUrl];
    self.playerModel.title = [NSString stringWithFormat:@"%@ %@",self.videoName,model.name];
    self.playerModel.placeholderImageURLString = model.image;
    [self.playerView resetToPlayNewVideo:self.playerModel];
}
#pragma mark -- ZFPLayer
/** 返回按钮事件 */
- (void)zf_playerBackAction{
    [self.playerView removeFromSuperview];
    [self goBack];
}
/** 下载视频 */
- (void)zf_playerDownload:(NSString *)url{
 
}
/** 控制层即将显示 */
- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen{
    
}
/** 控制层即将隐藏 */
- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentIndex"]) {
        NSInteger index = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
        SourceModel *model = _sources[index];
        NSLog(@"正在播放%@",model.name);
        [self playWithModel:model];
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
