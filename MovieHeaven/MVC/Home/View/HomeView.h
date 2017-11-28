//
//  HomeView.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/1.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseView.h"
@protocol HomeViewScrollDelegate <NSObject>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
@end
@interface HomeView : BaseView
@property (nonatomic, assign) NSUInteger type;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id<HomeViewScrollDelegate> delegate;
@end
