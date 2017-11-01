//
//  ParamsDefine.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/10/31.
//  Copyright © 2017年 石文文. All rights reserved.
//

#ifndef ParamsDefine_h
#define ParamsDefine_h
// 颜色(RGB)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#define SystemColor UIColorFromRGB(0x1AA1E6)
#define KECColor UIColorFromRGB(0xECECEC)
#define KD9Color UIColorFromRGB(0xD9D9D9)
#define K9BColor UIColorFromRGB(0x9B9B9B)
#define K33Color UIColorFromRGB(0x333333)
//系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define UserDefaultsGet(a)  [[NSUserDefaults standardUserDefaults] objectForKey:a]
#define UserDefaultsSet(a,b) [[NSUserDefaults standardUserDefaults] setObject:a forKey:b]

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define FIT_SCREEN_WIDTH(x) x*kScreenWidth/375.0
#define FIT_SCREEN_HEIGHT(x) x*kScreenHeight/667.0
#define AUTO_FONT(x) [UIFont systemFontOfSize:FIT_SCREEN_WIDTH(x)]



#ifndef iPhoneX

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436),[[UIScreen mainScreen] currentMode].size) : NO)

#endif

#define KTabBarHeight ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2436),[[UIScreen mainScreen] currentMode].size) ? 83 : 49) : 49)
#define KStatusBarHeight ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2436),[[UIScreen mainScreen] currentMode].size) ? 44 : 20) : 20)

#define KNavigationBarHeight ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2436),[[UIScreen mainScreen] currentMode].size) ? 88 : 64) : 64)


#endif /* ParamsDefine_h */
