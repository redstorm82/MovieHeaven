//
//  TopSubjectsModel.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/7.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "BaseModel.h"
#import "TopVideoItemModel.h"
@interface TopSubjectsModel : BaseModel
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSArray <TopVideoItemModel> * subjects;
@end
