//
//  BrowserView.m
//  PageList
//
//  Created by 石文文 on 2016/11/21.
//  Copyright © 2016年 石文文. All rights reserved.
//

#import "BrowserView.h"
#import "BrowserView.h"
#import <Masonry.h>

#define Edge  10
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface BrowserView ()<UIScrollViewDelegate>{
    UIScrollView *_titleBar;
    UIScrollView *_scrollView;
    NSArray *_titles;
    NSInteger _selectIndex;
    CGFloat _lastOffsetX;
    BOOL _isClick;
    
    
    BOOL _equalization;
}

@end
@implementation BrowserView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles subviews:(NSArray<UIView *> *)views delegate:(id<BrowserViewDelegate>)delegate{
    
    if (self = [super initWithFrame:frame]) {
        
        if (titles.count != views.count) {
            @throw [[NSException alloc]initWithName:@"layout error" reason:@"titles count is not equal with views" userInfo:nil];
        }
        self.delegate = delegate;
        _titles = titles;
        [self createUI];
        [self layoutWithSubviews:views];
     
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles subviewNames:(NSArray<NSString *> *)views delegate:(id<BrowserViewDelegate>)delegate{
    if (self = [super initWithFrame:frame]) {
        if (titles.count != views.count) {
            @throw [[NSException alloc]initWithName:@"layout error" reason:@"titles count is not equal with views" userInfo:nil];
        }
        self.delegate = delegate;
        _titles = titles;
        [self createUI];
        [self layoutWithViewClass:views];
    }
    return self;
}
- (void)createUI{
    _selectIndex = 0;
    self.backgroundColor = [UIColor whiteColor];
    _titleBar = [[UIScrollView alloc]initWithFrame:CGRectMake(Edge, 0,self.width- Edge * 2, TitleBarHeight)];
    
    if (_equalization) {
        _titleBar.frame = CGRectMake(Edge, 0, (self.width - Edge * 2), TitleBarHeight);
    }
    _titleBar.backgroundColor = [UIColor whiteColor];
    _titleBar.showsHorizontalScrollIndicator = NO;
    [self addSubview:_titleBar];

    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, TitleBarHeight, self.width, 0.6)];
    line.backgroundColor = UIColorFromRGB(0xececec);
    [self addSubview:line];

    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, (TitleBarHeight + 0.5), self.width, self.height - (TitleBarHeight + 0.5))];
    
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
}
- (void)layoutWithViewClass:(NSArray<NSString *> *)views{
    
    CGFloat left = 0;
    CGFloat contentLeft = 0;
    for (NSInteger index = 0;index < _titles.count; index++) {
        NSString *title = _titles[index];
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleButton setTitle:title forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:17];
        titleButton.tag = 100 + index;
        [titleButton setTitleColor:SystemColor forState:UIControlStateSelected];
        [titleButton setTitleColor:K33Color forState:UIControlStateNormal];
        [titleButton addTarget:self action:@selector(selectTitle:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.selected = _selectIndex == index;
        titleButton.titleLabel.font =  titleButton.selected ? [UIFont boldSystemFontOfSize:19] : [UIFont systemFontOfSize: 17];
        CGFloat width = [titleButton.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, TitleBarHeight)].width + 2 * title.length;
        
        if (_equalization){
            width = _titleBar.width / _titles.count;
            titleButton.frame = CGRectMake(left, 0, width, TitleBarHeight);
            
        }else{
            titleButton.frame = CGRectMake(left, 0, width + Edge * 3, TitleBarHeight);
        }
        
        
        if (_equalization){
            left += width;
        }else{
            left += width + Edge * 3;
        }
        
        [_titleBar addSubview:titleButton];
        id ViewClass = NSClassFromString(views[index]);
        UIView *view = [[ViewClass alloc]initWithFrame:CGRectMake(contentLeft, 0, _scrollView.width, _scrollView.height)];
        view.tag = 200 + index;
//        view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]; //test
        contentLeft += view.frame.size.width;
        [_scrollView addSubview:view];
    }
    _titleBar.contentSize = CGSizeMake(left, TitleBarHeight);
    _scrollView.contentSize = CGSizeMake(contentLeft, _scrollView.height);
    if ([self.delegate respondsToSelector:@selector(browserView:didShowPage:page:)]) {
        [self.delegate browserView:self didShowPage:_scrollView.subviews.firstObject page:0];
    }
    
}
- (void)layoutWithSubviews:(NSArray<UIView*>*)views{
    CGFloat left = 0;
    CGFloat contentLeft = 0;
    for (NSInteger index = 0;index < _titles.count; index++) {
        NSString *title = _titles[index];
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleButton setTitle:title forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:17];
        titleButton.tag = 100 + index;
        [titleButton setTitleColor:SystemColor forState:UIControlStateSelected];
        [titleButton setTitleColor:K33Color forState:UIControlStateNormal];
        [titleButton addTarget:self action:@selector(selectTitle:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.selected = _selectIndex == index;
        titleButton.titleLabel.font = titleButton.selected ? [UIFont boldSystemFontOfSize:19] : [UIFont systemFontOfSize: 17];
        CGFloat width = [titleButton.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, TitleBarHeight)].width + 2 * title.length;
        if (_equalization){
            width = _titleBar.width / _titles.count;
            titleButton.frame = CGRectMake(left, 0, width, TitleBarHeight);
            
        }else{
            titleButton.frame = CGRectMake(left, 0, width + Edge * 3, TitleBarHeight);
        }
        
        if (_equalization){
            left += width;
        }else{
            left += width + Edge * 3;
        }
        [_titleBar addSubview:titleButton];
        UIView *view = views[index];
        view.frame = CGRectMake(contentLeft, 0, _scrollView.width, _scrollView.height);
        view.tag = 200 + index;
//        view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]; //test
        contentLeft += view.frame.size.width;
        [_scrollView addSubview:view];
    }
    _titleBar.contentSize = CGSizeMake(left, TitleBarHeight);
    _scrollView.contentSize = CGSizeMake(contentLeft, _scrollView.height);
    if ([self.delegate respondsToSelector:@selector(browserView:didShowPage:page:)]) {
        [self.delegate browserView:self didShowPage:_scrollView.subviews.firstObject page:0];
    }
    
}
- (void)selectTitle:(UIButton *)button{
    NSInteger page = button.tag - 100;

    _isClick = YES;
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.width*(page), 0, _scrollView.width, _scrollView.height) animated:NO];
    
    [self resetSelect:page];
    CGRect framInView = [_titleBar convertRect:button.frame toView:self];
    if (framInView.origin.x + framInView.size.width / 2 != self.center.x) {
        CGFloat offsetWidth = framInView.origin.x + framInView.size.width / 2 - self.center.x;
        CGFloat newOffsetX = _titleBar.contentOffset.x + offsetWidth;
        CGFloat maxOffsetX = _titleBar.contentSize.width - _titleBar.width;
        if (newOffsetX > maxOffsetX) {
            newOffsetX = maxOffsetX;
        }
        if (newOffsetX < 0) {
            newOffsetX = 0;
        }
        [UIView animateWithDuration:0.25 animations:^{
            _titleBar.contentOffset = CGPointMake(newOffsetX, 0);
        } completion:^(BOOL finished) {
            
        }];
        
    }
    _lastOffsetX = _scrollView.contentOffset.x;
    if ([self.delegate respondsToSelector:@selector(browserView:didSelectTitle: title:)]) {
        [self.delegate browserView:self didSelectTitle:page title:_titles[page]];
    }
    if ([self.delegate respondsToSelector:@selector(browserView:didShowPage:page:)]) {
        [self.delegate browserView:self didShowPage:_scrollView.subviews[page] page:page];
    }
    
}
#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_isClick) {
        _isClick = NO;
        return;
    }
    
    CGFloat x = scrollView.contentOffset.x;
    CGFloat offsetWidth = x - _lastOffsetX;
    NSInteger page = ((NSInteger)x) / scrollView.width;
    
    if (scrollView.width * page == x && [self.delegate respondsToSelector:@selector(browserView:didShowPage:page:)]) {
        [self.delegate browserView:self didShowPage:scrollView.subviews[page] page:page];
    }
    
    UIView *currentTitleView = [_titleBar viewWithTag:page + 100];
    UIView *nextTitleView = [_titleBar viewWithTag:page + 1 + 100];
    UIView *lastTitleView = [_titleBar viewWithTag:page + 1 + 99];
    
    CGFloat contentWidth = _scrollView.width;
    CGFloat titleWidth = currentTitleView.width;
    if (offsetWidth > 0) {
        CGRect framInView = [_titleBar convertRect:nextTitleView.frame toView:self];
        if (framInView.origin.x + framInView.size.width / 2 > self.center.x) {
            CGFloat newOffsetX = _titleBar.contentOffset.x + offsetWidth*titleWidth/contentWidth;
            CGFloat maxOffsetX = _titleBar.contentSize.width - _titleBar.width;
            if (newOffsetX > maxOffsetX) {
                newOffsetX = maxOffsetX;
            }
            if (newOffsetX < 0) {
                newOffsetX = 0;
            }
            _titleBar.contentOffset = CGPointMake(newOffsetX, 0);
            
        }
    }else{
        
        CGRect framInView = [_titleBar convertRect:lastTitleView.frame toView:self];
        if (framInView.origin.x + framInView.size.width / 2 < self.center.x) {
            
            CGFloat newOffsetX = _titleBar.contentOffset.x + offsetWidth*titleWidth/contentWidth;
            if (newOffsetX < 0) {
                newOffsetX = 0;
            }
            
            _titleBar.contentOffset = CGPointMake(newOffsetX, 0);
            
        }
    }
    
    _lastOffsetX = x;
    [self resetSelect:page];
    
    if ([self.delegate respondsToSelector:@selector(browserView:contentDidScroll:)]) {
        [self.delegate browserView:self contentDidScroll:scrollView.contentOffset];
    }
}

- (void)resetSelect:(NSInteger )index{
    for (NSInteger tag = 0;tag < _titleBar.subviews.count;tag ++) {
        UIButton *button = [_titleBar viewWithTag:tag + 100];
        button.selected = index == tag;
        button.titleLabel.font = button.selected ? [UIFont boldSystemFontOfSize:19] : [UIFont systemFontOfSize: 17];
    }
}

- (void)selectIndex:(NSInteger)index{
    
    UIButton *button = (UIButton*)[_titleBar viewWithTag:index+100];
    [self selectTitle:button];
}
- (UIView *)viewOfIndex:(NSInteger)index{
    if (index < _scrollView.subviews.count) {
        return _scrollView.subviews[index];
    }
    return nil;
}
- (NSInteger)currentIndex{
    return (NSInteger)_scrollView.contentOffset.x / _scrollView.width;
}
-(void)setCurrentIndex:(NSInteger)currentIndex{
 
    [self selectIndex:currentIndex];
}

-(UIView *)currentView{
    return _scrollView.subviews[self.currentIndex];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



//----新增样式 平均大小标题
-(instancetype)initWithEqualizationTitlesWithFrame:(CGRect)frame titles:(NSArray<NSString*>*)titles subviewNames:(NSArray<NSString*>*)views delegate:(id<BrowserViewDelegate>)delegate{
    
    if (self = [super initWithFrame:frame]) {
        _equalization = YES;
        if (titles.count != views.count) {
            @throw [[NSException alloc]initWithName:@"layout error" reason:@"titles count is not equal with views" userInfo:nil];
        }
        self.delegate = delegate;
        _titles = titles;
        [self createUI];
        [self layoutWithViewClass:views];
    }
    return self;
}
-(instancetype)initWithEqualizationTitlesWithFrame:(CGRect)frame titles:(NSArray<NSString*>*)titles subviews:(NSArray<UIView*>*)views delegate:(id<BrowserViewDelegate>)delegate {
    if (self = [super initWithFrame:frame]) {
        _equalization = YES;
        if (titles.count != views.count) {
            @throw [[NSException alloc]initWithName:@"layout error" reason:@"titles count is not equal with views" userInfo:nil];
        }
        self.delegate = delegate;
        _titles = titles;
        [self createUI];
        [self layoutWithSubviews:views];
        
    }
    return self;
    
}
@end
