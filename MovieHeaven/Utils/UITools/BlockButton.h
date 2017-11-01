//
//  BlockButton.h
//  BeStudent_Teacher
//
//  Created by 石文文 on 2016/12/16.
//  Copyright © 2016年 花花. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockButton : UIButton
@property(nonatomic,copy)void(^buttonBlock)(UIButton*);
@end
