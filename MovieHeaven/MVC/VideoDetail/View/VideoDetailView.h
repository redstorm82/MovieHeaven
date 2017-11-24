//
//  VideoDetailView.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/3.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseView.h"
#import "SourceModel.h"
@interface VideoDetailView : BaseView
@property (nonatomic,copy) NSString *detailText;
@property (nonatomic,strong)NSArray <SourceModel *> *sources;
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,copy)void(^clickVideoItem)(NSInteger index);


@end
