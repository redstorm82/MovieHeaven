//
//  BlockButton.m
//  BeStudent_Teacher
//
//  Created by 石文文 on 2016/12/16.
//  Copyright © 2016年 花花. All rights reserved.
//

#import "BlockButton.h"

@implementation BlockButton

-(void)setButtonBlock:(void (^)(UIButton *))buttonBlock{
    _buttonBlock = buttonBlock;
    [self addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)deleteAction{
    __weak typeof(self) weakSelf = self;
    if (_buttonBlock) {
        __strong typeof(self) strongSelf = weakSelf;
        _buttonBlock(strongSelf);
    }
}


@end
