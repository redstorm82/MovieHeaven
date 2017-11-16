//
//  Tools.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/2.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "Tools.h"
#import <CommonCrypto/CommonDigest.h>
@implementation Tools
/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr {
    
    // 查找参数
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSMutableString *value;
            if (pairComponents.count > 1) {
                value = [NSMutableString string];
                for (int i = 1; i < pairComponents.count; i ++) {
                    [value appendString:pairComponents[i]];
                    if (i < pairComponents.count - 1) {
                        [value appendString:@"="];
                        
                    }
                    
                }
            }
            
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}
+ (NSString *)base64EncodedString:(NSString *)orgString;
{
    NSData *data = [orgString dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

+ (NSString *)base64DecodedString:(NSString *)encodedString;
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:encodedString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *decodedString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (!decodedString) {
        decodedString = [[NSString alloc]initWithData:data encoding:0];
    }
    return decodedString;
}
+ (nullable NSString *)thunderUrlToOrgUrl:(nonnull NSString *)thunderUrl{
    NSRange ranger = [thunderUrl rangeOfString:@"thunder://"];
    if (ranger.location != NSNotFound) {
        NSString *baseOrgUrl = [thunderUrl substringFromIndex:ranger.location + ranger.length];
        
        NSMutableString *baseDecodedUrl = [self base64DecodedString:baseOrgUrl].mutableCopy;
        [baseDecodedUrl replaceCharactersInRange:NSMakeRange(0, 2) withString:@""];
        [baseDecodedUrl replaceCharactersInRange:NSMakeRange(baseDecodedUrl.length - 3, 2) withString:@""];
        NSLog(@"迅雷地址解析--源：%@\n解析%@",thunderUrl,baseDecodedUrl);
        return baseDecodedUrl;
    }else {
        return nil;
    }
    
}

//32位MD5加密方式
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    if (![srcString hasSuffix:MD5_KEY]) {
        srcString = [srcString stringByAppendingString:MD5_KEY];
    }
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    //    NSLog(@"%@",result);
    
    return result;
}



// 将字典装换成字符串 用于签名
+ (NSString *)dictToStr:(NSDictionary *)dict
{
    NSMutableString * signOriginalStrTemp = [[Tools dictionaryToJson:dict] mutableCopy];
    // 去掉空格和换行
    NSArray  * arr = [signOriginalStrTemp componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n ()\\"]];
    NSString * signOriginalStr = [arr componentsJoinedByString:@""];
    
    return signOriginalStr;
    
}

//字典转JSON字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
+ (void)saveCookie {
    NSArray *allCoolkies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    if (allCoolkies.count > 0) {
        [NSKeyedArchiver archiveRootObject:allCoolkies toFile:CookiePath];
    }
}
+ (void)readCookie {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithFile:CookiePath];
    for (NSHTTPCookie *cookie in cookies) {
        [cookieStorage setCookie:cookie];
    }
}

+ (void)savePerfectSession:(NSString *)session {
    NSRange range = [session rangeOfString:@"PerfectSession" options:(NSBackwardsSearch)];
    if (range.location != NSNotFound) {
        NSString *fixSession = [session substringFromIndex:range.location];
        UserDefaultsSet(fixSession, PerfectSession);
    } else{
        UserDefaultsSet(session, PerfectSession);
    }
    
    
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (nonnull NSString *)readPerfectSession {
    return UserDefaultsGet(PerfectSession) ? UserDefaultsGet(PerfectSession) : @"";
}
+(NSString *)timeintervalToHMS:(NSTimeInterval)time withFromatString:(NSString *)formatString {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    format.dateFormat = formatString;
    return [format stringFromDate:date];
}
@end
