//
//  UITools.m
//  QRTProject
//
//  Created by 石文文 on 2017/10/19.
//  Copyright © 2017年 aohuan. All rights reserved.
//

#import "UITools.h"
#pragma mark - <ImageTool>
@implementation ImageTool


+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;
{
    CGRect rect = CGRectZero;
    rect.size = size;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage*)resizeImageToSize:(CGSize)size image:(UIImage*)image
{
    UIGraphicsBeginImageContext(size);
    //获取上下文内容
    CGContextRef ctx= UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0.0, size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    //重绘image
    CGContextDrawImage(ctx,CGRectMake(0.0f, 0.0f, size.width, size.height), image.CGImage);
    //根据指定的size大小得到新的image
    UIImage* scaled= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaled;
}

+ (UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.frame.size); //currentView 当前的view
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //从全屏中截取指定的范围
    CGImageRef imageRef = viewImage.CGImage;
    UIImage * sendImage = [[UIImage alloc] initWithCGImage:imageRef];
    return sendImage;
}

/**返回指定视图中指定范围生成的image图片*/
+ (UIImage *)imageFromView:(UIView *)view inRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(view.frame.size); //currentView 当前的view
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //从全屏中截取指定的范围
    CGImageRef imageRef = viewImage.CGImage;
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage * image = [[UIImage alloc] initWithCGImage:imageRefRect];
    CGImageRelease(imageRefRect);
    return image;
}

+ (void)writeImageToSavedPhotosAlbum:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}



@end

#pragma mark - <ButtonTool>

@implementation ButtonTool

+ (UIButton *)createButtonWithImageName:(NSString *)imageName
                              addTarget:(id)target
                                 action:(SEL)action
{
    UIButton * btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}
+ (BlockButton *)createButtonWithImageName:(NSString *)imageName
                                     block:(void(^)(UIButton *button))block{
    BlockButton * btn = [BlockButton buttonWithType:UIButtonTypeCustom];
    btn.buttonBlock = block;
    [btn setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    return btn;
}

+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName
                                addTarget:(id)target
                                   action:(SEL)action
{
    UIButton * btn = [[UIButton alloc] init];
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    [btn setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    return btn;
}

+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName
                                addTarget:(id)target
                                   action:(SEL)action
                                    title:(NSString *)title
                               titleColor:(UIColor *)titleColor
{
    return [self createButtonWithBGImageName:bgImageName addTarget:target action:action title:title titleColor:titleColor isSizeToFit:YES];
}

+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName
                                addTarget:(id)target
                                   action:(SEL)action
                                    title:(NSString *)title
                               titleColor:(UIColor *)titleColor
                              isSizeToFit:(BOOL)isSizeToFit
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    [btn setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    if (titleColor) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }else {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if (isSizeToFit) {
        [btn sizeToFit];
    }
    return btn;
}

+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName
                                addTarget:(id)target
                                   action:(SEL)action
                                    title:(NSString *)title
                               titleColor:(UIColor *)titleColor
                                superView:(UIView *)superView
{
    UIButton * btn = [self createButtonWithBGImageName:bgImageName addTarget:target action:action title:title titleColor:titleColor];
    [superView addSubview:btn];
    return btn;
}

+ (UIButton *)createButtonWithTitle:(NSString *)title
                         titleColor:(UIColor *)titleColor
                          titleFont:(UIFont *)font
                          addTarget:(id)target
                             action:(SEL)action
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    if (titleColor) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }else {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [btn sizeToFit];
    return btn;
}
+ (BlockButton *)createBlockButtonWithTitle:(NSString *)title
                                 titleColor:(UIColor *)titleColor
                                  titleFont:(UIFont *)font
                                      block:(void(^)(UIButton *button))block{
    BlockButton * btn = [BlockButton buttonWithType:UIButtonTypeCustom];
    btn.buttonBlock = block;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    if (titleColor) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }else {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [btn sizeToFit];
    return btn;
    
}
+ (void)addTarget:(id)target
           action:(SEL)action
         onButton:(UIButton *)btn
{
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}

+ (UIButton *)createButtonWithBGNormalImageName:(NSString *)bgImageName
                                 hightImageName:(NSString *)hightImageName
                                      addTarget:(id)target
                                         action:(SEL)action
                                    isSizeToFit:(BOOL)isSizeToFit
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    [btn setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:hightImageName] forState:UIControlStateHighlighted];
    if (isSizeToFit) {
        [btn sizeToFit];
    }
    return btn;
}


+ (void)setTitle:(NSString *)title
           color:(UIColor *)color
            font:(NSInteger)fontSize
        onButton:(UIButton *)btn
{
    [btn setTitle:title forState:(UIControlStateNormal)];
    [btn setTitleColor:color forState:(UIControlStateNormal)];
    // 设置字体为冬青黑简
    btn.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:fontSize];
}

/*
 改变按钮
 */
//设置按钮圆角
+ (void)setBtnCorner:(UIButton *)btn
{
    
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5.0;
    //    btn.layer.borderWidth = 0.5;
    //btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

@end
#pragma mark - <LabelTool>
@implementation LabelTool

+ (UILabel *)createLableWithFrame:(CGRect)frame textColor:(UIColor *)textColor textFontOfSize:(CGFloat)size;
{
    UILabel * lab = [[UILabel alloc]initWithFrame:frame];
    if (textColor) {
        lab.textColor = textColor;
    }else {
        lab.textColor = [UIColor blackColor];
    }
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:size];
    return lab;
}

+ (UILabel *)createLableWithFrame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font
{
    UILabel * lab = [[UILabel alloc]initWithFrame:frame];
    if (textColor) {
        lab.textColor = textColor;
    }else {
        lab.textColor = [UIColor blackColor];
    }
    lab.backgroundColor = [UIColor clearColor];
    lab.font = font;
    
    return lab;
}

+ (UILabel *)createLableWithTextColor:(UIColor *)textColor textFontOfSize:(CGFloat)size
{
    UILabel * lab = [[UILabel alloc]init];
    if (textColor) {
        lab.textColor = textColor;
    }else {
        lab.textColor = [UIColor blackColor];
    }
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:size];
    return lab;
}

+ (UILabel *)createLableWithTextColor:(UIColor *)textColor font:(UIFont *)font
{
    UILabel * lab = [[UILabel alloc]init];
    if (textColor) {
        lab.textColor = textColor;
    }else {
        lab.textColor = [UIColor blackColor];
    }
    lab.backgroundColor = [UIColor clearColor];
    lab.font = font;
    
    return lab;
}

@end

@implementation UITool
+ (MJRefreshGifHeader *)MJRefreshGifHeaderWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    NSMutableArray *images = [NSMutableArray array];
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
    }
    
    CFRelease(source);
    
    MJRefreshGifHeader *gifHeaer = [MJRefreshGifHeader headerWithRefreshingBlock:refreshingBlock];

    [gifHeaer setImages:images forState:MJRefreshStateIdle];
    
    [gifHeaer setImages:images forState:MJRefreshStatePulling];
    
    [gifHeaer setImages:images forState:MJRefreshStateRefreshing];
    return gifHeaer;
}
/*****
 计算字符串高度
 *
 * str   字符串
 * font  字体
 * size  区域
 * mode  折行方式
 */
+(CGSize)sizeOfStr:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size andLineBreakMode:(NSLineBreakMode)mode
{
    CGSize s;
    NSDictionary * dic = @{NSFontAttributeName:font};
    dic = dic;
    NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
    [mdic setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    [mdic setObject:font forKey:NSFontAttributeName];
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc]init];
    [para setLineSpacing:5];//调整行间距
    [mdic setObject:para forKey:NSParagraphStyleAttributeName];
    
    s = [str boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                       attributes:mdic context:nil].size;
    
    return s;
}
+(CGSize)sizeOfStr:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size andLineBreakMode:(NSLineBreakMode)mode lineSpace:(CGFloat)lineSpace
{
    CGSize s;
    
    NSDictionary * dic = @{NSFontAttributeName:font};
    dic = dic;
    NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
    [mdic setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    [mdic setObject:font forKey:NSFontAttributeName];
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc]init];
    [para setLineSpacing:lineSpace];//调整行间距
    [mdic setObject:para forKey:NSParagraphStyleAttributeName];
    
    s = [str boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                       attributes:mdic context:nil].size;
    
    
    return s;
}
@end


