//
//  RightImageButton.m
//  GoToSchool
//
//  Created by 石文文 on 16/7/26.
//  Copyright © 2016年 UI. All rights reserved.
//

#import "RightImageButton.h"
#import "UITools.h"

@interface RightImageButton ()

@property (nonatomic,strong)UIImageView *rightImage;//图片视图
@property (nonatomic,strong)UIImage *normalImage;//普通图片
@property (nonatomic,strong)UIImage *selectedImage;//选中图片
@property (nonatomic,copy)NSString *normalTitle;//普通文字
@property (nonatomic,copy)NSString *selectedTitle;//选中文字
@property (nonatomic,strong)UIColor *normalColor;//普通文字颜色
@property (nonatomic,strong)UIColor *selecteColor;//选中文字颜色

@end



@implementation RightImageButton

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.interstice = 5;
        self.maxSize = CGSizeMake(0, 0);
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.interstice = 5;
        self.maxSize = CGSizeMake(0, 0);
    }
    return self;
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    
    if (state == UIControlStateNormal) {
        
        self.normalTitle = title;
        
    }else if (state == UIControlStateSelected){
        self.selectedTitle = title;
        
    }
    
    [self layout];
    
}
-(void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
    if (state == UIControlStateNormal) {
        
        self.normalColor = color;
        
    }else if (state == UIControlStateSelected){
        self.selecteColor = color;
        
    }
    [self layout];
}
-(void)setImage:(UIImage *)image forState:(UIControlState)state{
    
    if (state == UIControlStateNormal) {
        
        self.normalImage = image;
        
    }else if (state == UIControlStateSelected){
        self.selectedImage = image;
        
    }
    
    [self layout];
}

-(void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    [self layout];
}


-(UILabel *)textLabel{
    if (!_textLabel) {
        
        _textLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        if (self.state == UIControlStateNormal) {
            
            _textLabel.text = self.normalTitle;
            _textLabel.textColor = self.normalColor;
        }else if (self.state == UIControlStateSelected){
            
            _textLabel.text = self.selectedTitle;
            _textLabel.textColor = self.selecteColor;
        }
        
        [self addSubview:_textLabel];
    }
    
    return _textLabel;
}

-(UIImageView *)rightImage{
    if (!_rightImage) {

        
        if (self.state == UIControlStateNormal) {
            
            if (self.normalImage) {
                
                _rightImage = [[UIImageView alloc]initWithImage:self.normalImage];
            }else{
                _rightImage = [[UIImageView alloc]init];
            }
            
            
        }else if (self.state == UIControlStateSelected){
            
            if (self.selectedImage) {
                
                _rightImage = [[UIImageView alloc]initWithImage:self.selectedImage];
            }else{
                _rightImage = [[UIImageView alloc]init];
            }
        }else{
            _rightImage = [[UIImageView alloc]init];
            
        }
        [self addSubview:_rightImage];
        
    }
    
    return _rightImage;
}

-(void)layout{
    
    if (self.state == UIControlStateNormal) {
        
        
        
        self.rightImage.image = self.normalImage;
        
        self.textLabel.text = self.normalTitle;
        self.textLabel.textColor = self.normalColor;
        
    }else if (self.state == UIControlStateSelected){
        
        
        self.rightImage.image = self.selectedImage;
        
        self.textLabel.text = self.selectedTitle;
        
        if (self.selectedTitle) {
            
            self.textLabel.text = self.selectedTitle;
            
        }else{
            self.textLabel.text = self.normalTitle;
        }
        
        self.textLabel.textColor = self.selecteColor;
        
    }
    
    CGSize imageSize = self.rightImage.image.size;
    
    CGSize textSize = [self.textLabel sizeThatFits:CGSizeMake(kScreenWidth, self.height)];
    
    if (self.isAutoLayout) {
        
        if (CGSizeEqualToSize(self.maxSize, CGSizeZero)) {
            self.maxSize = self.bounds.size;
            
        }else{
            self.width = self.maxSize.width;
        }
        
        
        if (self.rightImage.image) {
            
            self.textLabel.frame = CGRectMake(0, 0, textSize.width, self.height);
            
            self.rightImage.frame = CGRectMake(self.textLabel.width + self.interstice, (self.height - imageSize.height)/2, imageSize.width, imageSize.height);
            
            
            if (self.width >= self.textLabel.width + self.rightImage.width+self.interstice) {
                self.width = self.textLabel.width + self.rightImage.width + self.interstice;
                
            }else{
                
                self.textLabel.width = self.width - self.rightImage.width - self.interstice;
                self.rightImage.left = self.textLabel.right + self.interstice;
            }
            if (self.width > self.maxSize.width) {
                self.width = self.maxSize.width;
                self.textLabel.width = self.width - self.rightImage.width - self.interstice;
                self.rightImage.left = self.textLabel.right + self.interstice;
                
            }
            
        }else{
            
            self.textLabel.frame = CGRectMake(0, 0, textSize.width, self.height);
            
            self.rightImage.frame = CGRectZero;
            
            if (self.width > self.maxSize.width) {
                self.width = self.maxSize.width;
            }
            if (self.width >= self.textLabel.width) {
                self.width = self.textLabel.width;
            }else{
                self.textLabel.width = self.width;
                
            }
            
        }
        
        
        
        
        
    }else{
        
        if (self.rightImage.image) {
            
            self.textLabel.frame = CGRectMake(0, 0, textSize.width, self.height);
            self.rightImage.frame = CGRectMake(self.textLabel.right + self.interstice, (self.height - imageSize.height)/2, imageSize.width, imageSize.height);
            if (self.width <= self.textLabel.width + self.rightImage.width+self.interstice) {
                self.textLabel.width = self.width - self.rightImage.width - self.interstice;
            }else{
                
                self.textLabel.width = (self.width - self.textLabel.width - self.imageView.width - self.interstice)/2;
                self.rightImage.left = self.textLabel.right + self.interstice;
            }
            
        }else{
            
            self.rightImage.frame = CGRectZero;
            self.textLabel.frame = self.bounds;
        }
        
    }
    
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    
    
    
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
