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

// 首页
#define HotPlay [NSString stringWithFormat:@"%@%@",HostAddress,@"/api/hotPlay"]
// 视频详情
#define Video [NSString stringWithFormat:@"%@%@",HostAddress,@"/api/video"]
// 视频源
#define VideoSource [NSString stringWithFormat:@"%@%@",HostAddress,@"/api/videosource"]
//搜索
#define VideoSearch [NSString stringWithFormat:@"%@%@",HostAddress,@"/api/videos"]
//搜索建议
#define VideoSearchSuggest [NSString stringWithFormat:@"%@%@",HostAddress,@"/api/suggest"]
// 分类
#define VideosFilter [NSString stringWithFormat:@"%@%@",HostAddress,@"/api/videosfilter"]

// 分享视频
#define ShareVideo(a) [NSString stringWithFormat:@"http://xiaokanba.com/video_mid_%ld.html",a]
//视频解析
#define VideoParse @"http://v.xiaokanba.com/parse/api"
#define VParsev3 @"http://app.xiaokanba.com/newmovie/btmovie/vparsev3"
#define Parse_odlfl @"http://v.xiaokanba.com/parse/parse_odlfl"
// 榜单
#define TopIndex [NSString stringWithFormat:@"%@%@",HostAddress,@"/api/index"]
//榜单更多
#define TopMore [NSString stringWithFormat:@"%@%@",HostAddress,@"/api/more_douban_topic_items"]

#endif /* Apis_h */
