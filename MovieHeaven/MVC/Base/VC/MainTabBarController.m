//
//  MainTabBarController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/10/31.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseViewController.h"
@interface MainTabBarController () <UITabBarControllerDelegate>

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = SystemColor;
    self.tabBar.translucent = NO;
    self.delegate = self;
    
}

-(BOOL)shouldAutorotate{
    return [self selectedViewController].shouldAutorotate;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [[self selectedViewController] preferredInterfaceOrientationForPresentation];
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.selectedViewController.supportedInterfaceOrientations;
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    if (self.selectedIndex == 0 || self.selectedIndex == 3) {
        UINavigationController *navi = (UINavigationController *)viewController;
        BaseViewController *rootVC = navi.viewControllers.firstObject;
        NSInteger timeinterval = [[NSDate date] timeIntervalSince1970];
        if (timeinterval % 8 == 0) {
            [rootVC showYoumiAdSpotPlayWithFinishCallBackBlock:^(BOOL isFinish) {
                
            }];
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
