//
//  FilterHeaderReusableView.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/7.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>
#define FilterItemHeight 30
@interface FilterHeaderReusableView : UICollectionReusableView <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray *sortbys;
@property (nonatomic,strong) NSArray *types;
@property (nonatomic,strong) NSArray *areas;
@property (nonatomic,strong) NSArray *years;

@property (nonatomic,copy) NSString *sortby;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *year;


@property (nonatomic,copy) void(^changeFilter)(NSString *sortby, NSString *type, NSString *area, NSString *year);

- (void)reloadData;

@end
