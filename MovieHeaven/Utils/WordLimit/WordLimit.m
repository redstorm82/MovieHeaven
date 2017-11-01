//
//  WordLimit.m
//  UITextField&textView_WordLimit
//
//  Created by 石文文 on 16/7/14.
//  Copyright © 2016年 石文文. All rights reserved.
//

#import "WordLimit.h"
#import <objc/runtime.h>
NSString const*textFieldlengthKey = @"textFieldlengthKey";
NSString const*textFieldDelegateKey = @"textFieldDelegateKey";

@implementation UITextField (wordLimit)

#pragma mark --设置最大长度
-(void)setMaxCharLength:(NSInteger)maxCharLength{
    

    objc_setAssociatedObject(self, &textFieldlengthKey, @(maxCharLength), OBJC_ASSOCIATION_RETAIN);
    
    [self addTarget:self action:@selector(textFieldEditingChange) forControlEvents:UIControlEventEditingChanged];
}
-(NSInteger)maxCharLength{

    return [objc_getAssociatedObject(self, &textFieldlengthKey) integerValue];
}
#pragma mark --设置长度变化代理对象
-(void)setLengthDelegate:(id)delegate{
    [self addTarget:self action:@selector(textFieldEditingChange) forControlEvents:UIControlEventEditingChanged];
    objc_setAssociatedObject(self, &textFieldDelegateKey, delegate, OBJC_ASSOCIATION_ASSIGN);
}
-(id)lengthDelegate{

    return objc_getAssociatedObject(self, &textFieldDelegateKey);
}

/**
 *  编辑中
 */
- (void)textFieldEditingChange{
    
    if (self.markedTextRange) {
        
        if ([self positionFromPosition:self.markedTextRange.start offset:0]) {
        
            
        }else{
            
           [self checkLength];
        }
        
        
    }else{
        
        [self checkLength];
    }
    
    
    
}
/**
 *  检查长度
 */
- (void)checkLength{
    
    if (self.text.length <= self.maxCharLength) {
        /**
         *  发送通知
         */
        [[NSNotificationCenter defaultCenter]postNotificationName:UITextFieldTextLengthDidChangeNotification object:self];
        /**
         *  执行代理
         */
        if ([self.lengthDelegate respondsToSelector:@selector(textFieldTextLengthDidChange:)]) {
            [self.lengthDelegate textFieldTextLengthDidChange:self];
        }
        
    }else{
        
        for (NSInteger i = self.text.length-1; i >= 0; i--) {
            
            NSString *text = [self.text substringToIndex:i];
            
            if (text.length <= self.maxCharLength) {
                
                self.text = text;
                /**
                 *  发送通知
                 */
                [[NSNotificationCenter defaultCenter]postNotificationName:UITextFieldTextLengthDidChangeNotification object:self];
                /**
                 *  执行代理
                 */
                if ([self.lengthDelegate respondsToSelector:@selector(textFieldTextLengthDidChange:)]) {
                    [self.lengthDelegate textFieldTextLengthDidChange:self];
                }
                break;
            }
            
        }
        
        
    }
    
}

@end


NSString const *textViewlengthKey = @"textViewlengthKey";
NSString const *textViewDelegateKey = @"textViewDelegateKey";
@implementation UITextView (wordLimit)
#pragma mark --设置最大长度
-(void)setMaxCharLength:(NSInteger)maxCharLength{
    
    
    objc_setAssociatedObject(self, &textViewlengthKey, @(maxCharLength), OBJC_ASSOCIATION_RETAIN);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditingChange) name:UITextViewTextDidChangeNotification object:nil];
    
}
-(NSInteger)maxCharLength{
    
    return [objc_getAssociatedObject(self, &textViewlengthKey) integerValue];
}
#pragma mark --设置长度变化代理对象
-(void)setLengthDelegate:(id)delegate{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditingChange) name:UITextViewTextDidChangeNotification object:nil];
    objc_setAssociatedObject(self, &textViewDelegateKey, delegate, OBJC_ASSOCIATION_ASSIGN);
    
}
-(id)lengthDelegate{
    
    return objc_getAssociatedObject(self, &textViewDelegateKey);
}
/**
 *  编辑中
 */
- (void)textViewEditingChange{
    
    if (self.markedTextRange) {
        
        if ([self positionFromPosition:self.markedTextRange.start offset:0]) {
            
            
            
        }else{
            
            [self checkLength];
        }
        
        
    }else{
        
        [self checkLength];
    }
    
    
    
}
/**
 *  检查长度
 */
- (void)checkLength{
    
    if (self.text.length <= self.maxCharLength) {
        /**
         *  发送通知
         */
        [[NSNotificationCenter defaultCenter]postNotificationName:UITextViewTextLengthDidChangeNotification object:self];
        /**
         *  执行代理
         */
        if ([self.lengthDelegate respondsToSelector:@selector(textFieldTextLengthDidChange:)]) {
            [self.lengthDelegate textViewTextLengthDidChange:self];
        }
        
    }else{
        
        for (NSInteger i = self.text.length-1; i >= 0; i--) {
            
            NSString *text = [self.text substringToIndex:i];
            
            if (text.length <= self.maxCharLength) {
                
                self.text = text;
                /**
                 *  发送通知
                 */
                [[NSNotificationCenter defaultCenter]postNotificationName:UITextViewTextLengthDidChangeNotification object:self];
                /**
                 *  执行代理
                 */
                if ([self.lengthDelegate respondsToSelector:@selector(textFieldTextLengthDidChange:)]) {
                    [self.lengthDelegate textViewTextLengthDidChange:self];
                }
                break;
            }
            
        }
        
        
    }
    
}


@end
