//
//  SearchSuggestView.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/6.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "SearchSuggestView.h"
#import <Masonry.h>
#import "UITools.h"
static NSString *SuggestCellId = @"SuggestCell";
@interface SearchSuggestView () <UITableViewDelegate,UITableViewDataSource> {
    
    NSMutableArray *_dataArray;
}
@property (nonatomic,strong)UITableView *tableView;
@end
@implementation SearchSuggestView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    self.tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    [self addSubview:self.tableView];
    TO_WEAK(self, weakSelf)
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf)
        make.edges.equalTo(strongSelf);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = KECColor;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SuggestCellId];
    self.keywords = @"";
    NSArray *history = UserDefaultsGet(SrearchHistory);
    _dataArray = history.mutableCopy;
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    
    
    self.backgroundColor = [UIColor whiteColor];
    
    
//        [self setCornerRadius:3 rectCorner:UIRectCornerBottomLeft|UIRectCornerBottomRight];
    self.layer.borderColor = KD9Color.CGColor;
    
    self.layer.borderWidth = 0.6;
    self.layer.shadowRadius = 5;
    self.layer.shadowOffset = CGSizeMake(3, 3);
    self.layer.shadowColor = K9BColor.CGColor;
    self.layer.shadowOpacity = 4;
    //    self.clipsToBounds = YES;
    
    UIButton *cleanBtn = [ButtonTool createBlockButtonWithTitle:@"清除搜索记录" titleColor:K9BColor titleFont:[UIFont systemFontOfSize:13] block:^(UIButton *button) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SrearchHistory];
        if (_keywords.length < 1) {
            _dataArray = @[].mutableCopy;
            dispatch_main_async_safe(^{
                [self.tableView reloadData];
            })
        }
        
    }];
    cleanBtn.frame = CGRectMake(0, 0, self.width, 30);
    self.tableView.tableFooterView = cleanBtn;
}
-(void)setKeywords:(NSString *)keywords{
    _keywords = keywords;
    NSArray *history = UserDefaultsGet(SrearchHistory);
    if (_keywords.length < 1) {
        
        _dataArray = history.mutableCopy;
        
        [self.tableView reloadData];
    }else{
        [self requestSuggest];
    }
}
- (void)requestSuggest{
    [HttpHelper GET:VideoSearchSuggest headers:nil parameters:@{@"q":_keywords} HUDView:nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {
        if ([response[@"code"] integerValue] == 0) {
            NSArray *body = response[@"body"];
            _dataArray = body.mutableCopy;
            [self.tableView reloadData];
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
    
    if (self.clickKeywords) {
        self.clickKeywords(_dataArray[indexPath.row]);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
