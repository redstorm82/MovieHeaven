//
//  VideoDetailView.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/3.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "VideoDetailView.h"
#import <Masonry.h>
#import "VideoDetailTextCell.h"
#import "UITools.h"
#import "RightImageButton.h"
#import "EpisodeCell.h"
#import "LoginController.h"
static NSString *VideoDetailTextCellId = @"VideoDetailTextCell";
static NSString *EpisodeCellId = @"EpisodeCell";
@interface VideoDetailView ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL _episodeIsFull;
//    BOOL _isRegist;

}
@property(nonatomic,strong) UITableView *tableView;

@end

@implementation VideoDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentIndex = -1;
        [self initUI];
    }
    return self;
}

-(void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [self.tableView reloadData];
}
-(void)setDetailText:(NSString *)detailText{
    _detailText = detailText;
    [self.tableView reloadData];
}
-(void)setSources:(NSArray<SourceModel *> *)sources{
    _sources = sources;
    [_tableView reloadData];
}
- (void)initUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self addSubview:_tableView];
    TO_WEAK(self, weakSelf)
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if (@available(iOS 11.0,*)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"VideoDetailTextCell" bundle:nil] forCellReuseIdentifier:VideoDetailTextCellId];
    [_tableView registerClass:[EpisodeCell class] forCellReuseIdentifier:EpisodeCellId];
    _tableView.separatorColor = KECColor;
}
#pragma mark -- tableView-----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 8;
    }
    return 35;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        UILabel *titleLabel = [LabelTool createLableWithFrame:CGRectMake(KContentEdge, 0, 50, 35) textColor:K9BColor textFontOfSize:17];
        titleLabel.text = @"剧集";
        [headerView addSubview:titleLabel];
        UIButton *showAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        showAllBtn.frame = CGRectMake(kScreenWidth - KContentEdge - 200, 0, 200, 35);
        showAllBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [showAllBtn setTitle:[NSString stringWithFormat:@"共%lu集 ›",(unsigned long)self.sources.count] forState:(UIControlStateNormal)];
        [showAllBtn setTitleColor:K9BColor forState:UIControlStateNormal];
        
        showAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [headerView addSubview:showAllBtn];
        if (!_episodeIsFull) {
            [showAllBtn setTitle:[NSString stringWithFormat:@"共%lu集 ›",(unsigned long)self.sources.count] forState:(UIControlStateNormal)];
        }else{
            [showAllBtn setTitle:@"收起" forState:(UIControlStateNormal)];
        }
        [showAllBtn addTarget:self action:@selector(showAllVideo:) forControlEvents:UIControlEventTouchUpInside];
        return headerView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        EpisodeCell *cell = [tableView dequeueReusableCellWithIdentifier:EpisodeCellId forIndexPath:indexPath];
        cell.isFull = _episodeIsFull;
        TO_WEAK(self, weakSelf);
        cell.clickVideoItem = ^(NSInteger index) {
            TO_STRONG(weakSelf, strongSelf);
            strongSelf.currentIndex = index;
            if (strongSelf.clickVideoItem) {
                strongSelf.clickVideoItem(index);
            }
        };
        cell.sources = self.sources;
        cell.currentIndex = self.currentIndex;
        return cell;
    }
    
    VideoDetailTextCell *txtCell = [tableView dequeueReusableCellWithIdentifier:VideoDetailTextCellId forIndexPath:indexPath];
    txtCell.contentTextView.text = self.detailText;
    
    return txtCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        return UITableViewAutomaticDimension;
    }
    if (_episodeIsFull) {
        return kScreenHeight - KStatusBarHeight - kScreenWidth / 16.f * 9 - 40 - 45 - 35;
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return kScreenHeight - KStatusBarHeight - kScreenWidth / 16.f * 9 - 40 - 45 - 35 - 45;
    }
    if (_episodeIsFull) {
        return kScreenHeight - KStatusBarHeight - kScreenWidth / 16.f * 9 - 40 - 45 - 35;
    }
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)dealloc {
    QLLogFunction;
    
}
#pragma mark -- 显示所有视频
- (void)showAllVideo:(UIButton *)button{
    _episodeIsFull = !_episodeIsFull;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}
@end
