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
#define DefaultAPI @"http://101.37.135.113/newmovie"
#define GetNewIP @"http://ip.941pk.cn/newip.txt"

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
//榜单 更多榜单
#define MoreDoubanTopicList [NSString stringWithFormat:@"%@%@",HostAddress,@"/api/more_doubantopic_list"]
//  榜单 影集
#define MoreDoulist [NSString stringWithFormat:@"%@%@",HostAddress,@"/api/more_doulist"]
// 榜单 影集 详情信息
#define DouListInfo [NSString stringWithFormat:@"%@%@",HostAddress,@"/api/doulist_info"]
//榜单 影集 详情列表
#define DouListItem [NSString stringWithFormat:@"%@%@",HostAddress,@"/api/doulist_items"]

//短视频列表
#define HotShortVideoList [NSString stringWithFormat:@"%@%@",HostAddress,@"/api/hotshortvideo"]


// ----------------------- 观影天堂服务
//开发
//#define WMH_BASE_URL @"http://192.168.31.208:8080/movie_heaven/api/v1/"
//#define WMH_BASE_WEB_URL @"http://192.168.31.208:8080/movie_heaven/"
// 生产
#define WMH_BASE_URL @"http://www.gallifrey.cn/movie_heaven/api/v1/"
#define WMH_BASE_WEB_URL @"http://www.gallifrey.cn/movie_heaven/"



//登录
#define WMH_LOGIN [NSString stringWithFormat:@"%@%@",WMH_BASE_URL,@"/auth/login"]
//用户信息
#define WMH_USER_INFO [NSString stringWithFormat:@"%@%@",WMH_BASE_URL,@"/user/info"]
//退出登录
#define WMH_SIGN_OUT [NSString stringWithFormat:@"%@%@",WMH_BASE_URL,@"/auth/sign_out"]
// 检查收藏
#define WMH_COLLECT_CHECK [NSString stringWithFormat:@"%@%@",WMH_BASE_URL,@"/collect/check"]
// 添加收藏
#define WMH_COLLECT_ADD [NSString stringWithFormat:@"%@%@",WMH_BASE_URL,@"/collect/add"]
//取消收藏
#define WMH_COLLECT_CANCEL [NSString stringWithFormat:@"%@%@",WMH_BASE_URL,@"/collect/cancel"]
// 收藏列表
#define WMH_COLLECTION_LIST [NSString stringWithFormat:@"%@%@",WMH_BASE_URL,@"/collect/get_collection_list"]

// 添加历史
#define WMH_HISTORY_ADD [NSString stringWithFormat:@"%@%@",WMH_BASE_URL,@"/history/add"]
//删除历史
#define WMH_HISTORY_DELETE [NSString stringWithFormat:@"%@%@",WMH_BASE_URL,@"/history/delete_history"]
// 获取历史
#define WMH_HISTORY_GET [NSString stringWithFormat:@"%@%@",WMH_BASE_URL,@"/history/get_history"]
// 历史列表
#define WMH_HISTORY_LIST [NSString stringWithFormat:@"%@%@",WMH_BASE_URL,@"/history/get_history_list"]
//视频状态 包括收藏和历史
#define WMH_VIDEO_DETAIL_STATE [NSString stringWithFormat:@"%@%@",WMH_BASE_URL,@"/video_detail/state"]

// 免责声明
#define WMH_DISCLAIMET [NSString stringWithFormat:@"%@%@",WMH_BASE_WEB_URL,@"/statement/disclaimer/index.html"]
#endif /* Apis_h */
