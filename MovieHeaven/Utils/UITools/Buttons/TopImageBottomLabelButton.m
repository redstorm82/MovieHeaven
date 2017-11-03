//
//  TopImageBottomLabelButton.m
//  BeStudent_Teacher
//
//  Created by 石文文 on 2017/4/26.
//  Copyright © 2017年 花花. All rights reserved.
//

#import "TopImageBottomLabelButton.h"

@implementation TopImageBottomLabelButton

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2 + (self.frame.size.height - self.imageView.bounds.size.height - _spacing - self.titleLabel.bounds.size.height)/2;
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + self.spacing;
    newFrame.size.width = self.frame.size.width;
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
