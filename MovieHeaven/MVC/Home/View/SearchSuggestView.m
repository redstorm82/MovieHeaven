//
//  SearchSuggestView.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/6.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "SearchSuggestView.h"
static NSString *SuggestCellId = @"SuggestCell";
@interface SearchSuggestView () <UITableViewDelegate,UITableViewDataSource> {
    
    NSMutableArray *_dataArray;
}

@end
@implementation SearchSuggestView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self initSelf];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSelf];
    }
    return self;
}
- (void)initSelf{
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = KECColor.CGColor;
    self.separatorColor = KECColor;
    self.layer.borderWidth = 0.6;

    [self setCornerRadius:8 rectCorner:UIRectCornerBottomLeft|UIRectCornerBottomRight];
    self.clipsToBounds = YES;
    self.tableFooterView = [UIView new];
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:SuggestCellId];
    self.keywords = @"";
    NSArray *history = UserDefaultsGet(SrearchHistory);
    _dataArray = history.mutableCopy;
    if (@available(iOS 11.0,*)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
    }
}
-(void)setKeywords:(NSString *)keywords{
    _keywords = keywords;
    NSArray *history = UserDefaultsGet(SrearchHistory);
    if (_keywords.length < 1) {
        
        _dataArray = history.mutableCopy;
        
        [self reloadData];
    }else{
        [self requestSuggest];
    }
}
- (void)requestSuggest{
    [HttpHelper GET:VideoSearchSuggest headers:nil parameters:@{@"q":_keywords} HUDView:nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {
        if ([response[@"code"] integerValue] == 0) {
            NSArray *body = response[@"body"];
            _dataArray = body.mutableCopy;
            [self reloadData];
        }
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark -- tableView-----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SuggestCellId forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:@"ic_history_black"];
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.clickKeywords) {
        self.clickKeywords(_dataArray[indexPath.row]);
    }
}

@end
