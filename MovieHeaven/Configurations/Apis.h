//
//  Apis.h
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/1.
//  Copyright © 2017年 石文文. All rights reserved.
//

#ifndef Apis_h
#define Apis_h
#define HostAddress UserDefaultsGet(IPKey)

#define NewIP @"http://ip.941pk.cn/newip.txt"


#define HotPlay [NSString stringWithFormat:@"%@%@",HostAddress,@"/api/hotPlay"]
#define Video [NSString stringWithFormat:@"%@%@",HostAddress,@"/api/video"]
#define VideoSource [NSString stringWithFormat:@"%@%@",HostAddress,@"/api/videosource"]
#define ShareVideo(a) [NSString stringWithFormat:@"http://xiaokanba.com/video_mid_%ld.html",a]

#endif /* Apis_h */
