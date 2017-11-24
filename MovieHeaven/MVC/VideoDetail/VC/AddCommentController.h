//
//  AddCommentController.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/24.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseViewController.h"

@interface AddCommentController : BaseViewController
@property (nonatomic, copy) void(^commentCompletion)(void);
@property (nonatomic, copy) NSString *videoName;
@property (nonatomic) NSInteger videoId;
@end
