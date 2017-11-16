//
//  MainTabBarController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/10/31.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "MainTabBarController.h"
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
