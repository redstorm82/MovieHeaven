//
//  VideoSectionCell.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/2.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "VideoSectionCell.h"
#import <Masonry.h>

#import "VideoDetailController.h"

#import "UIView+UIViewController.h"
static NSString *VideoCollectionCellId = @"VideoCollectionCell";

@interface VideoSectionCell() <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end


@implementation VideoSectionCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
- (void)createUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(VideoItemWidth, VideoItemHeight);
    layout.minimumLineSpacing = 10.f;
    layout.minimumInteritemSpacing = 10.f;
    layout.sectionInset = UIEdgeInsetsMake(0, KContentEdge - 0.5, 0,KContentEdge - 0.5);
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.collectionView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    TO_WEAK(self, weakSelf)
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf.contentView).insets(UIEdgeInsetsMake(10, 0, 10, 0));
    }];
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionCell" bundle:nil] forCellWithReuseIdentifier:VideoCollectionCellId];
    
    self.collectionView.scrollEnabled = NO;
}
-(void)setModel:(VideoSectionModel *)model{
    _model = model;
    [self.collectionView reloadData];
}
-(void)setTopSubjectsModel:(TopSubjectsModel *)topSubjectsModel{
    _topSubjectsModel = topSubjectsModel;
    [self.collectionView reloadData];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_topSubjectsModel) {
        return _topSubjectsModel.subjects.count;
    }
    return _model.videos.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VideoCollectionCellId forIndexPath:indexPath];
    if (_topSubjectsModel) {
        cell.topModel = _topSubjectsModel.subjects[indexPath.item];
    }else{
        cell.model = _model.videos[indexPath.item];
    }
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoDetailController *detailVC = [[VideoDetailController alloc]init];
    if (_topSubjectsModel) {
        TopVideoItemModel *model = _topSubjectsModel.subjects[indexPath.item];
        detailVC.videoId = model.movieId;
        detailVC.videoName = model.name;
    }
    if (_model) {
        
        VideoItemModel *model = _model.videos[indexPath.item];
        detailVC.videoId = model.movieId;
        detailVC.videoName = model.name;
        
    }
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
