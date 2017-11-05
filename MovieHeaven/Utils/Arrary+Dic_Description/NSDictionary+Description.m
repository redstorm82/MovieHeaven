//
//  NSDictionary+Description.m
//  BeStudent_Teacher
//
//  Created by 石文文 on 2017/3/28.
//  Copyright © 2017年 花花. All rights reserved.
//

#import "NSDictionary+Description.h"
#import "NSArray+Description.h"
@implementation NSDictionary (Description)
-(NSString *)my_description{
    NSString *desc = [self description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    
    return desc ? desc : self.description ;
}
@end
