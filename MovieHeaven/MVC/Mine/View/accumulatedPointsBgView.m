//
//  accumulatedPointsBgView.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/24.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "accumulatedPointsBgView.h"

@implementation accumulatedPointsBgView


- (void)drawRect:(CGRect)rect {
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* gradientColor = [UIColor colorWithRed: 0.955 green: 0.531 blue: 0.186 alpha: 1];
    UIColor* gradientColor2 = [UIColor colorWithRed: 1 green: 0.971 blue: 0 alpha: 1];
    
    //// Gradient Declarations
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(NULL, (__bridge CFArrayRef)@[(id)gradientColor.CGColor, (id)gradientColor2.CGColor], gradientLocations);
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: self.bounds];
    CGContextSaveGState(context);
    [rectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(self.width, self.height / 2), CGPointMake(0, self.height / 2), kNilOptions);
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(gradient);


}


@end
