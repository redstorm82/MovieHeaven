//
//  LoginController.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/12.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInfo.h"
@interface LoginController : BaseViewController
@property (nonatomic, copy)void(^completion)(UserInfo *user);
@end
