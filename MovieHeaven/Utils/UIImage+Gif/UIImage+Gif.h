//
//  UIImage+Gif.h
//  WolfVideo
//
//  Created by 石文文 on 2017/10/13.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Gif)
+ (UIImage *)animatedGIFNamed:(NSString *)name;

+ (UIImage *)animatedGIFWithData:(NSData *)data;

- (UIImage *)sd_animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end
