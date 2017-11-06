//
//  SearchSuggestView.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/6.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSuggestView : UITableView
@property (nonatomic,copy) NSString *keywords;
@property (nonatomic,copy) void(^clickKeywords)(NSString *keywords);
@end
