//
//  WordLimit.h
//  UITextField&textView_WordLimit
//
//  Created by 石文文 on 16/7/14.
//  Copyright © 2016年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  字符长度变化代理
 */
@protocol UITextFieldLengthDelegate <NSObject>

-(void)textFieldTextLengthDidChange:(UITextField *)textField;

@end


static NSString *UITextFieldTextLengthDidChangeNotification = @"UITextFieldTextLengthDidChangeNotification";

@interface UITextField (wordLimit)
    
@property (nonatomic,assign)NSInteger maxCharLength;
@property (nonatomic,assign)id<UITextFieldLengthDelegate> lengthDelegate;
@end

/**
 *  字符长度变化代理
 */
@protocol UITextViewLengthDelegate <NSObject>

-(void)textViewTextLengthDidChange:(UITextView *)textView;

@end

static NSString *UITextViewTextLengthDidChangeNotification = @"UITextViewTextLengthDidChangeNotification";
@interface UITextView (wordLimit)

@property (nonatomic,assign)NSInteger maxCharLength;
@property (nonatomic,assign)id<UITextViewLengthDelegate> lengthDelegate;

@end