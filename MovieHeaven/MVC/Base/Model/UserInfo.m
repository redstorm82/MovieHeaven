//
//  UserInfo.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/12.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:@(self.uid) forKey:@"uid"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        self.uid = [[aDecoder decodeObjectForKey:@"uid"] integerValue];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        
    }
    return self;
}
-(void)save {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    UserDefaultsSet(data, USER_INFO);
    [[NSUserDefaults standardUserDefaults]synchronize];
}
+(instancetype)read {
    NSData *userData = UserDefaultsGet(USER_INFO);
    if (!userData) {
        return nil;
    }
    UserInfo *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    return user;
}
+(void)clean{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:USER_INFO];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
+(void)resetOptions{
    UserDefaultsSet(@[].mutableCopy, SrearchHistory);
    UserDefaultsSet(@(NO), WWANPlay);
    UserDefaultsSet(@(NO), WWANDownloading);
    UserDefaultsSet(@"3", MaxDownloadCount);
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
@end
