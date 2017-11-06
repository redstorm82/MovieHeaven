//
//  VideoDetailController.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/2.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseViewController.h"

@interface VideoDetailController : BaseViewController
@property (nonatomic, assign) NSInteger videoId;
@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, copy) NSString *from;
@end
