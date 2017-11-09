//
//  ShortVideoListView.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/9.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseView.h"
#import "ShortVideoItemModel.h"
@interface ShortVideoListView : BaseView
@property (nonatomic) NSInteger tid;
- (void)requestShortVideoList:(BOOL)showHUD;
@property (nonatomic, strong) NSMutableArray <ShortVideoItemModel *> *shortVideoList;
- (void)resetPlayer;
@end
