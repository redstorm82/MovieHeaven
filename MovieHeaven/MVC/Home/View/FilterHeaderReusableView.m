//
//  FilterHeaderReusableView.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/7.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "FilterHeaderReusableView.h"
#import "FilterItemCell.h"
#import <Masonry.h>

static NSString *FilterItemCellId = @"FilterItemCell";
@implementation FilterHeaderReusableView{
    UICollectionView *_sortbyView;
    UICollectionView *_genreView;
    UICollectionView *_countryView;
    UICollectionView *_yearView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sortbys = @[@"最新",@"最热",@"好评"];
        self.types = @[];
        self.areas = @[];
        self.years = @[];
        [self createUI];
    }
    return self;
}
-(void)setSortby:(NSString *)sortby{
    if ([sortby isEqualToString:@"time"]) {
        _sortby = @"最新";
    }else if ([sortby isEqualToString:@"review"]) {
        _sortby = @"最热";
    }else{
        _sortby = @"好评";
    }
    
}
- (void)reloadData{
    [_sortbyView reloadData];
    [_genreView reloadData];
    [_countryView reloadData];
    [_yearView reloadData];
}
- (void)createUI{
    self.backgroundColor = KECColor;
    for (int i = 0; i < 4; i ++) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(60, FilterItemHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, KContentEdge, 0, KContentEdge);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, (FilterItemHeight+0.5) * i, kScreenWidth, FilterItemHeight) collectionViewLayout:layout];
        collection.backgroundColor = [UIColor whiteColor];
        collection.showsHorizontalScrollIndicator = NO;
        [self addSubview:collection];
        collection.dataSource = self;
        collection.delegate = self;
        collection.tag = 100 + i;
        
        [collection registerNib:[UINib nibWithNibName:@"FilterItemCell" bundle:nil] forCellWithReuseIdentifier:FilterItemCellId];
        switch (i) {
            case 0:
                _sortbyView = collection;
                break;
            case 1:
                _genreView = collection;
                break;
            case 2:
                _countryView = collection;
                break;
            default:
                _yearView = collection;
                break;
        }
    }

}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (collectionView.tag) {
        case 100:
            return self.sortbys.count;
            
        case 101:
            return self.types.count;
            
        case 102:
            return self.areas.count;
            
        default:
            return self.years.count;
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FilterItemCellId forIndexPath:indexPath];
    switch (collectionView.tag) {
        case 100: {
            cell.textLabel.text = self.sortbys[indexPath.item];
            if ([cell.textLabel.text isEqualToString:self.sortby]) {
                cell.isSelected = YES;
            }else{
                cell.isSelected = NO;
            }
        }
            break;
            
        case 101: {
            cell.textLabel.text = self.types[indexPath.item];
            if ([cell.textLabel.text isEqualToString:self.type]) {
                cell.isSelected = YES;
            }else{
                cell.isSelected = NO;
            }
        }
            break;
        case 102: {
            cell.textLabel.text = self.areas[indexPath.item];
            if ([cell.textLabel.text isEqualToString:self.area]) {
                cell.isSelected = YES;
            }else{
                cell.isSelected = NO;
            }
        }
            break;
        default: {
            cell.textLabel.text = self.years[indexPath.item];
            if ([cell.textLabel.text isEqualToString:self.year]) {
                cell.isSelected = YES;
            }else{
                cell.isSelected = NO;
            }
        }
            break;
    }
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (collectionView.tag) {
        case 100: {
            _sortby = self.sortbys[indexPath.item];
        }
            break;
            
        case 101: {
            self.type = self.types[indexPath.item];
        }
            break;
        case 102: {
            self.area = self.areas[indexPath.item];
        }
            break;
        default: {
            self.year = self.years[indexPath.item];
        }
            break;
    }
    [collectionView reloadData];
    if (self.changeFilter) {
        NSString *sortby;
        if ([self.sortby isEqualToString:@"最新"]) {
            sortby = @"time";
        }else if ([self.sortby isEqualToString:@"最热"]) {
            sortby = @"review";
        }else{
            sortby = @"score";
        }
        self.changeFilter(sortby, self.type, self.area, self.year);
    }
}
@end
