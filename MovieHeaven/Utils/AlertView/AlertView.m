//
//  AlertView.m
//  BBPartTimeJob
//
//  Created by 石文文 on 2017/7/7.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "AlertView.h"
#import <Masonry.h>
#import "UITools.h"
#import "BaseWebView.h"
@interface AlertView()<UITableViewDelegate,UITableViewDataSource>{
    
    UIView *_alertView;
    NSInteger _selectedIndex;
    NSArray *_items;
    UITableView *_tableView;
}
@property(nonatomic,copy)ClickBlock cancelBlock;
@property(nonatomic,copy)ClickBlock sureBlock;
@end
@implementation AlertView
-(nonnull instancetype)initWithText:(nullable id)text buttonTitle:(nullable NSString *)buttonTitle clickBlock:(nullable ClickBlock)clickBlock{
    if ([super init]) {
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        _selectedIndex = -1;
        _sureBlock = clickBlock;
        
        _alertView = [[UIView alloc]initWithFrame:CGRectZero];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 4;
        _alertView.layer.masksToBounds = YES;
        [self addSubview:_alertView];
        [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(FIT_SCREEN_WIDTH(300));
        }];
        UILabel *textLabel = [LabelTool createLableWithFrame:CGRectZero textColor:K33Color textFontOfSize:14];
        textLabel.numberOfLines = 0;
        textLabel.textAlignment = NSTextAlignmentCenter;
        if ([text isKindOfClass:[NSAttributedString class]]) {
            textLabel.attributedText = text;
        }else if ([text isKindOfClass:[NSString class]]){
            textLabel.text = text;
        }
        
        [_alertView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_alertView).offset(FIT_SCREEN_HEIGHT(35));
            make.bottom.equalTo(_alertView).offset(FIT_SCREEN_HEIGHT(-25) - 45.5);
            make.left.equalTo(_alertView).offset(15);
            make.right.equalTo(_alertView).offset(-15);
        }];
        UIView *hLine = [[UIView alloc]init];
        hLine.backgroundColor = KECColor;
        [_alertView addSubview:hLine];
        [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_alertView);
            make.top.equalTo(textLabel.mas_bottom).mas_offset(FIT_SCREEN_HEIGHT(25));
            make.height.mas_equalTo(0.5);
        }];
        
        UIButton *bottomButton = [ButtonTool createButtonWithTitle:buttonTitle titleColor:SystemColor titleFont:[UIFont systemFontOfSize:14] addTarget:self action:@selector(rightButtonClick)];
        [_alertView addSubview:bottomButton];
        [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(_alertView);
            make.height.mas_equalTo(45);
            make.width.equalTo(_alertView);
        }];

    }
    return self;
}
-(nonnull instancetype)initWithUrl:(NSString *)url buttonTitle:(nullable NSString *)buttonTitle clickBlock:(nullable ClickBlock)clickBlock{
    if ([super init]) {
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        _selectedIndex = -1;
        _sureBlock = clickBlock;
        
        _alertView = [[UIView alloc]initWithFrame:CGRectZero];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 4;
        _alertView.layer.masksToBounds = YES;
        [self addSubview:_alertView];
        [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(FIT_SCREEN_WIDTH(300));
            make.height.mas_equalTo(kScreenHeight * 2 / 3);
        }];
        BaseWebView *webView = [[BaseWebView alloc]init];
        
        
        [_alertView addSubview:webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_alertView);
            make.bottom.equalTo(_alertView).offset(-45);
            make.left.equalTo(_alertView).offset(0);
            make.right.equalTo(_alertView).offset(0);
        }];
        [webView loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        UIButton *bottomButton = [ButtonTool createButtonWithTitle:buttonTitle titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:14] addTarget:self action:@selector(rightButtonClick)];
        bottomButton.backgroundColor = SystemColor;
        [_alertView addSubview:bottomButton];
        [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(_alertView);
            make.height.mas_equalTo(45);
            make.width.equalTo(_alertView);
        }];
        
    }
    return self;
}
-(instancetype)initWithText:(NSString *)text cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle cancelBlock:(ClickBlock)cancelBlock sureBlock:(ClickBlock)sureBlock{
    if ([super init]) {
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        _selectedIndex = -1;
        _cancelBlock = cancelBlock;
        _sureBlock = sureBlock;
        _alertView = [[UIView alloc]initWithFrame:CGRectZero];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 4;
        _alertView.layer.masksToBounds = YES;
        [self addSubview:_alertView];
        [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(FIT_SCREEN_WIDTH(300));
        }];
        UILabel *textLabel = [LabelTool createLableWithFrame:CGRectZero textColor:K33Color textFontOfSize:14];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = text;
        textLabel.numberOfLines = 0;
        [_alertView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_alertView).offset(FIT_SCREEN_HEIGHT(40));
            make.bottom.equalTo(_alertView).offset(FIT_SCREEN_HEIGHT(-40) - 45.5);
            make.left.equalTo(_alertView).offset(15);
            make.right.equalTo(_alertView).offset(-15);
        }];
        UIView *hLine = [[UIView alloc]init];
        hLine.backgroundColor = KECColor;
        [_alertView addSubview:hLine];
        [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_alertView);
            make.top.equalTo(textLabel.mas_bottom).mas_offset(FIT_SCREEN_HEIGHT(40));
            make.height.mas_equalTo(0.5);
        }];
        
        UIButton *leftButton = [ButtonTool createButtonWithTitle:cancelTitle ? cancelTitle : @"取消" titleColor:K33Color titleFont:[UIFont systemFontOfSize:14] addTarget:self action:@selector(leftButtonClick)];
        [_alertView addSubview:leftButton];
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(_alertView);
            make.height.mas_equalTo(45);
            make.width.equalTo(_alertView).multipliedBy(0.5);
        }];
        UIView *vLine = [[UIView alloc]init];
        vLine.backgroundColor = KECColor;
        [_alertView addSubview:vLine];
        [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(leftButton);
            make.width.mas_equalTo(0.5);
            make.left.equalTo(leftButton.mas_right);
        }];
        UIButton *rightButton = [ButtonTool createButtonWithTitle:sureTitle ? sureTitle : @"确认" titleColor:SystemColor titleFont:[UIFont systemFontOfSize:14] addTarget:self action:@selector(rightButtonClick)];
        [_alertView addSubview:rightButton];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(vLine.mas_right);
            make.top.equalTo(vLine);
            make.height.width.equalTo(leftButton);
        }];
    }
    return self;
}
-(nonnull instancetype)initWithTitle:(nullable NSString *)title items:(nonnull NSArray<NSDictionary *>*)items cancelTitle:(nullable NSString *)cancelTitle sureTitle:(nullable NSString *)sureTitle cancelBlock:(nullable ClickBlock)cancelBlock sureBlock:(nullable ClickBlock)sureBlock{
    if ([super init]) {
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        _items = items;
        _selectedIndex = -1;
        _cancelBlock = cancelBlock;
        _sureBlock = sureBlock;
        _alertView = [[UIView alloc]initWithFrame:CGRectZero];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 4;
        _alertView.layer.masksToBounds = YES;
        [self addSubview:_alertView];
        [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(FIT_SCREEN_WIDTH(300));
        }];
        UILabel *titleLabel = [LabelTool createLableWithFrame:CGRectZero textColor:K33Color textFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        [_alertView addSubview:titleLabel];
        titleLabel.layer.borderColor = KECColor.CGColor;
        titleLabel.layer.borderWidth = 0.5;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_alertView);
            make.height.mas_equalTo(59.5);
        }];
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_alertView addSubview:_tableView];
        _tableView.separatorColor = KECColor;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_alertView);
            make.top.equalTo(titleLabel.mas_bottom);
            make.height.mas_equalTo(45*_items.count);
        }];
        UIView *hLine = [[UIView alloc]init];
        hLine.backgroundColor = KECColor;
        [_alertView addSubview:hLine];
        [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_alertView);
            make.top.equalTo(_tableView.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
        
        UIButton *leftButton = [ButtonTool createButtonWithTitle:cancelTitle ? cancelTitle : @"取消" titleColor:K33Color titleFont:[UIFont systemFontOfSize:14] addTarget:self action:@selector(leftButtonClick)];
        [_alertView addSubview:leftButton];
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(_alertView);
            make.top.equalTo(hLine.mas_bottom);
            make.height.mas_equalTo(45);
            make.width.equalTo(_alertView).multipliedBy(0.5);
        }];
        UIView *vLine = [[UIView alloc]init];
        vLine.backgroundColor = KECColor;
        [_alertView addSubview:vLine];
        [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(leftButton);
            make.width.mas_equalTo(0.5);
            make.left.equalTo(leftButton.mas_right);
        }];
        UIButton *rightButton = [ButtonTool createButtonWithTitle:sureTitle ? sureTitle : @"确认" titleColor:SystemColor titleFont:[UIFont systemFontOfSize:14] addTarget:self action:@selector(rightButtonClick)];
        [_alertView addSubview:rightButton];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(vLine.mas_right);
            make.top.equalTo(vLine);
            make.height.width.equalTo(leftButton);
        }];
    }
    return self;
    
}
-(void)show{
    if (self.superview) {
        return;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superview);
    }];
    self.alpha = 0;
    _alertView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1;
        _alertView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)dismiss{
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)leftButtonClick{
    [self dismiss];
    if (_cancelBlock) {
        _cancelBlock(-1);
    }
}
- (void)rightButtonClick{
    [self dismiss];
    if (_sureBlock) {
        _sureBlock(_selectedIndex);
    }
}

#pragma mark -- tableView-----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _items.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SELECT_CELL"];
    SourceTypeModel *model = _items[indexPath.row];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SELECT_CELL"];
        UILabel *titleLabel = [LabelTool createLableWithFrame:CGRectZero textColor:K33Color textFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.tag = 100;
        [cell.contentView addSubview:titleLabel];
        UIImageView *iconImage = [[UIImageView alloc]init];
        iconImage.tag = 200;
        [cell.contentView addSubview:iconImage];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.centerX.equalTo(cell.contentView).mas_offset(12.5 + 5);
        }];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(titleLabel.mas_left).mas_offset(-10);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
    }
    UILabel *titleLabel = [cell.contentView viewWithTag:100];
    UIImageView *iconImage = [cell.contentView viewWithTag:200];
    titleLabel.text = model.desc;
    iconImage.image = [UIImage imageNamed:model.logo];
    if (_selectedIndex == indexPath.row) {
        
        titleLabel.textColor = SystemColor;
    }else{
        
        titleLabel.textColor = K33Color;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndex = indexPath.row;
    [tableView reloadData];
}
#pragma mark -- 线偏移
- (void)viewDidLayoutSubviews {
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
