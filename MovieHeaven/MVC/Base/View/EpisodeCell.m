//
//  EpisodeCell.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/3.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "EpisodeCell.h"
#import <Masonry.h>
#import "EpisodeCellCollectionCell.h"
#import "UITools.h"
static NSString *EpisodeCellCollectionCellId = @"EpisodeCellCollectionCell";
@interface EpisodeCell () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@end
@implementation EpisodeCell {
    
    UICollectionView *_collectionView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _currentIndex = 0;
        [self initUI];
    }
    return self;
}
-(void)setSources:(NSArray<SourceModel *> *)sources{
    if (!_sources) {
        _currentIndex = 0;
    }else{
        _currentIndex = -1;
    }
    _sources = sources;
    
    [_collectionView reloadData];
}
-(void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    dispatch_main_async_safe(^{
        [_collectionView reloadData];
        if (_currentIndex >= 0 && _currentIndex < _sources.count) {
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0] atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:YES];
        } else if (_currentIndex < 0 && _sources.count > 0) {
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:YES];
        }
        
        
    })
    
}
- (void)initUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(8, KContentEdge, 8, KContentEdge);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"EpisodeCellCollectionCell" bundle:nil] forCellWithReuseIdentifier:EpisodeCellCollectionCellId];
    
    [self.contentView addSubview:_collectionView];
    TO_WEAK(self, weakSelf)
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf.contentView);
    }];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
}
-(void)setIsFull:(BOOL)isFull{
    _isFull = isFull;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    layout.scrollDirection = _isFull ? UICollectionViewScrollDirectionVertical : UICollectionViewScrollDirectionHorizontal;
    [_collectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _sources.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EpisodeCellCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EpisodeCellCollectionCellId forIndexPath:indexPath];
    cell.textLabel.text = _sources[indexPath.item].name;
    
    if (_currentIndex == indexPath.item) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = SystemColor;
        cell.textLabel.layer.borderWidth = 0;
    }else{
        cell.textLabel.textColor = K33Color;
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        cell.textLabel.layer.borderWidth = 0.8;
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _currentIndex = indexPath.item;
    if (self.clickVideoItem) {
        self.clickVideoItem(indexPath.item);
    }
    [_collectionView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = [UITool sizeOfStr:_sources[indexPath.item].name andFont:[UIFont systemFontOfSize:15] andMaxSize:CGSizeMake(MAXFLOAT, 25) andLineBreakMode:(NSLineBreakByCharWrapping)];
    return CGSizeMake(size.width + 30, size.height + 10);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc{
    QLLogFunction
    
    
}
@end
