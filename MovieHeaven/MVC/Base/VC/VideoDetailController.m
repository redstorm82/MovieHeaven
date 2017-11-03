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
@interface VideoDetailController () <ZFPlayerDelegate> {
    
    NSMutableArray *_sources;
    NSMutableArray *_sourceTypes;
    NSInteger _currentTypeIndex;
}
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic,strong)ZFPlayerView *playerView;
@property (nonatomic,strong)UIView *playerBgView;
@property (nonatomic,strong)ZFPlayerModel *playerModel;
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
    UIView *statusBar = [[UIView alloc]init];
    statusBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusBar];
    
    [statusBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(KStatusBarHeight);
    }];
    
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
- (void)requestVideo{
    NSDictionary *params = @{
                             @"videoId": @(self.videoId),
                             @"st": [NSNull null],
                             @"sn": [NSNull null],
                             @"from": @"index"
                             };
    [HttpHelper GET:Video headers:@{} parameters:params HUDView:self.view progress:NULL success:^(NSURLSessionDataTask *task, NSDictionary *response) {
        if ([response[@"code"] integerValue] != 0) {
            [[ToastView sharedToastView]show:response[@"message"] inView:nil];
            _emptyView.hidden = NO;
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault) animated:YES];
        }else{
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent) animated:YES];
            _emptyView.hidden = YES;
            NSDictionary *body = response[@"body"];
            NSArray *sources = body[@"sources"];
            NSArray *sourceTypes = body[@"sourceTypes"];
            for (NSDictionary *source in sources) {
                SourceModel *model = [[SourceModel alloc]initWithDictionary:source error:nil];
                [_sources addObject:model];
            }
            SourceModel *firstModel = _sources.firstObject;
            self.playerModel.videoURL = [NSURL URLWithString:firstModel.playUrl];
            self.playerModel.placeholderImageURLString = firstModel.image;
            [self.playerView resetToPlayNewVideo:self.playerModel];
            NSDictionary *urlParams = [Tools getURLParameters:firstModel.playUrl];
            NSString *typeName = urlParams[@"type"];
            for (int i =0 ; i< sourceTypes.count; i ++) {
                NSDictionary *sourceType = sourceTypes[i];
                SourceTypeModel *model = [[SourceTypeModel alloc]initWithDictionary:sourceType error:nil];
                if ([typeName isEqualToString:model.type]) {
                    _currentTypeIndex = i;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
