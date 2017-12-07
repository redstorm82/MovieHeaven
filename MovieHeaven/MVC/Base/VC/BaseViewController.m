//
//  BaseViewController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/1.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseViewController.h"
#import "UITools.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

-(id)init
{
    self = [super init];
    if (self) {
        self.arrowType = backArrow;
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.arrowType = backArrow;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault) animated:YES];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self setNavBarColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 默认是现实返回箭头
    
    [self setBackItem:@"backArrow" AndTitleColor:SystemColor title:nil];
}
-(BOOL)shouldAutorotate{
//    return YES;
    return NO;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskAll;
    return UIInterfaceOrientationMaskPortrait;
}
- (void)setBackItemTitle:(NSString *)title{
    [self setBackItem:@"backArrow" AndTitleColor:SystemColor title:title];
}
-(void)setArrowType:(ArrowType)arrowType{
    _arrowType = arrowType;
    [self setBackItem:@"backArrow" AndTitleColor:SystemColor title:nil];
}
- (void)setBackItem:(NSString *)imageName AndTitleColor:(UIColor *)color title:(NSString *)title{

    
    if (self.arrowType == backArrow) {
        UIButton *pop = [UIButton buttonWithType:UIButtonTypeCustom];
        pop.frame = CGRectMake(0, 0, 60, 34); //10.5, 19
        [pop addTarget: self action: @selector(goBack) forControlEvents: UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 40, 34)];
        label.backgroundColor = [UIColor clearColor];
        label.text = title ? title : @"返回";
        label.textColor = color;
        label.font = [UIFont systemFontOfSize:17];
        [pop addSubview:label];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7.5, 10.5, 19)];
        UIImage *image = [UIImage imageNamed:imageName];
        icon.image = image?image:[UIImage imageNamed:@"backArrow"];
        [pop addSubview:icon];
        pop.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:pop];
        
        
        self.navigationItem.leftBarButtonItem = item;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = YES;
    }
    
}


/**设置导航栏图片按钮*/
- (void)setNavItemWithImage:(NSString *)imageName
            imageHightLight:(NSString *)hightLight
                     isLeft:(BOOL)isLeft
                     target:(id)target
                     action:(SEL)action
{
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:(UIBarButtonItemStylePlain) target:target action:action];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = barItem;
    }else
        self.navigationItem.rightBarButtonItem = barItem;
}

/**设置导航栏文字按钮*/
- (void)setNavItemWithTitle:(NSString *)title
                     isLeft:(BOOL)isLeft
                     target:(id)target
                     action:(SEL)action
{
    
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:title style:(UIBarButtonItemStylePlain) target:target action:action];
    barItem.tintColor = K33Color;
    if (isLeft) {
        
        
        self.navigationItem.leftBarButtonItem = barItem;
        
    }else{
        self.navigationItem.rightBarButtonItem = barItem;
        
    }
    
}
/**隐藏导航栏按钮*/
- (void)setNavItemWithTitle:(NSString *)title isLeft:(BOOL)isLeft
{
    UIBarButtonItem * titleBar = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(emptyMethd)];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = titleBar;
    }else
        self.navigationItem.rightBarButtonItem = titleBar;
}

- (void)emptyMethd
{
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.backViewController) {
        [self closeSlideBack];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.backViewController) {
        [self openSlideBack];
    }
}
- (void)hiddenKeyBoard{
    [self.view endEditing:YES];
}
- (void)goBack
{
    if (!self.backViewController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSArray *viewControllers = self.navigationController.viewControllers;
        
        for (UIViewController *vc in viewControllers) {
            if ([vc isKindOfClass:[self.backViewController class]]) {
                [self.navigationController popToViewController:self.backViewController animated:YES];
                return;
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
/**隐藏返回按钮*/
- (void)hiddenBackBtn
{
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = @[];
    self.navigationItem.hidesBackButton = YES;
}

/**显示返回按钮*/
- (void)showBackBtn
{
    [self setBackItem:@"backArrow" AndTitleColor:K33Color title:nil];
}

/**设置导航栏的颜色*/
- (void)setNavBarColor:(UIColor *)color
{
    [self.navigationController.navigationBar setBackgroundImage:[ImageTool createImageWithColor:color size:CGSizeMake(kScreenWidth, KNavigationBarHeight)] forBarMetrics:(UIBarMetricsDefault)];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
/**
 隐藏导航栏底部的线
 */
- (void)hiddenNavigationBarBottomLine{
    [self findHairlineImageViewUnder:self.navigationController.navigationBar].hidden = YES;
}

/**
 显示导航栏底部的线
 */
- (void)showNavigationBarBottomLine{
    [self findHairlineImageViewUnder:self.navigationController.navigationBar].hidden = NO;
}
//找到导航栏底部view
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view{
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
//开启滑动返回手势和效果
- (void)openSlideBack{
    
    //开启滑动返回手势和效果
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    
}
//关闭滑动返回手势和效果
- (void)closeSlideBack{
    
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    
    
    
}
- (void)showYoumiAdSpotPlayWithFinishCallBackBlock:(void(^)(BOOL isFinish))block{
#ifdef DEBUG
    
#else
//    去除广告
//    [UMVideoAd videoHasCanPlayVideo:^(int isHaveVideoStatue){
//        NSLog(@"是否有视频：%d",isHaveVideoStatue);
//        if (isHaveVideoStatue == 0) {
//            //设置是否显示退出播放时弹出的提示框，默认显示提示框。
//            //            [UMVideoAd videoCloseAlertViewWhenWantExit:NO];
//            [UMVideoAd videosetCloseAlertContent:@"是否关闭广告播放?"];
//            dispatch_main_async_safe(^{
//                [UMVideoAd videoSpotPlay:self videoSuperView:self.view videoPlayFinishCallBackBlock:^(BOOL isFinishPlay){
//                    if (isFinishPlay) {
//                        NSLog(@"视频播放结束");
//                    }else{
//                        NSLog(@"中途退出");
//                    }
//                    if (block) {
//                        block(isFinishPlay);
//                    }
//                } videoPlayConfigCallBackBlock:^(BOOL isLegal){
//                    //注意：  isLegal在（app有联网，并且注册的appkey后台审核通过）的情况下才返回yes, 否则都是返回no.
//                    NSString *message = @"";
//                    if (isLegal) {
//                        message = @"此次播放有效";
//                    }else{
//                        message = @"此次播放无效";
//                    }
//                    NSLog(@"是否有效：%@",message);
//
//                }];
//            })
//
//        }
//    }];
#endif
    
}

-(void)dealloc{
    debugMethod();
}
@end
