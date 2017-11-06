//
//  FilterView.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/6.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseView.h"

@interface FilterView : BaseView
@property (nonatomic) NSInteger type;
@property (nonatomic,copy)NSString *genre;
@property (nonatomic,copy)NSString *country;
@property (nonatomic,copy)NSString *year;
@property (nonatomic,copy)NSString *sortby;
@end
