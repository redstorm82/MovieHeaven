//
//  ToastView.m
//  WolfVideo
//
//  Created by 石文文 on 16/8/7.
//  Copyright © 2016年 石文文. All rights reserved.
//

#import "ToastView.h"

static ToastView *_instance;

@implementation ToastView


+(instancetype)sharedToastView{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        
        _instance = [[ToastView alloc]init];
        
        
        
    });
 
    return _instance;
}
+(id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
-(id)copy{
    return self;
}
-(id)mutableCopy{
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _blackBgView = [[UIView alloc]init];
        _blackBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _blackBgView.layer.cornerRadius = 5;
        _blackBgView.layer.masksToBounds = YES;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:_blackBgView];
        [self addSubview:_contentLabel];
        
    }
    return self;
}
-(void)show:(NSString *)title inView:(UIView *)view{
    
    
    _contentLabel.text = title;
    CGSize size = [_contentLabel sizeThatFits:CGSizeMake(kScreenWidth - 30*2, kScreenHeight - 30*2)];
    _contentLabel.frame = CGRectMake(0, 0, size.width , size.height);
    _blackBgView.frame = CGRectMake(0, 0, size.width + 15*2, size.height + 13*2);
    if (view) {
        self.frame = view.bounds;
        [view addSubview:self];
    }else{
        self.frame = [UIScreen mainScreen].bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    _contentLabel.center = self.center;
    _blackBgView.center = self.center;
    [self show];
}
- (void)show{
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hiddenToast) withObject:nil afterDelay:1.5];
        
    }];
    
}
- (void)hiddenToast{
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
