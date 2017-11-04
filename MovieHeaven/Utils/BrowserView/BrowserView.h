//
//  BrowserView.h
//  PageList
//
//  Created by 石文文 on 2016/11/21.
//  Copyright © 2016年 石文文. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BrowserView;
@protocol BrowserViewDelegate <NSObject,UITableViewDelegate>
@optional

/**
 Called after the user click the title.

 @param browserView browserView
 @param index current index
 @param title current title
 */
-(void)browserView:(BrowserView*)browserView didSelectTitle:(NSInteger )index title:(NSString *)title;

/**
 Called after the user scroll the browserView.

 @param browserView browserView
 @param contentOffset current contentOffset
 */
-(void)browserView:(BrowserView*)browserView contentDidScroll:(CGPoint)contentOffset;

/**
 Called after the user changes the page.

 @param browserView browserView
 @param PageView  current PageView
 @param page current page
 */
-(void)browserView:(BrowserView*)browserView didShowPage:(UIView*)PageView page:(NSInteger)page;
@end

@interface BrowserView : UIView
@property (nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,weak)id<BrowserViewDelegate> delegate;
/**
 init

 @param frame frame
 @param views subviews
 @return BrowserView
 */
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString*>*)titles subviewNames:(NSArray<NSString*>*)views delegate:(id<BrowserViewDelegate>)delegate;


/**
 init
 
 @param frame frame
 @param views subviews
 @return BrowserView
 */
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString*>*)titles subviews:(NSArray<UIView*>*)views delegate:(id<BrowserViewDelegate>)delegate;

/**
 user manual select

 @param index select index
 */
- (void)selectIndex:(NSInteger)index;

/**
 view of index

 @param index index
 @return view
 */
- (UIView *)viewOfIndex:(NSInteger)index;
/**
 current index(page)
 */
@property (nonatomic,assign)NSInteger currentIndex;

/**
 current page view
 */
@property (nonatomic,strong,readonly)UIView *currentView;


//----新增样式 平均大小标题
-(instancetype)initWithEqualizationTitlesWithFrame:(CGRect)frame titles:(NSArray<NSString*>*)titles subviewNames:(NSArray<NSString*>*)views delegate:(id<BrowserViewDelegate>)delegate ;
-(instancetype)initWithEqualizationTitlesWithFrame:(CGRect)frame titles:(NSArray<NSString*>*)titles subviews:(NSArray<UIView*>*)views delegate:(id<BrowserViewDelegate>)delegate ;

@end
