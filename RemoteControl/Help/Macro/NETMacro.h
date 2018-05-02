//
//  NETMacro.h
//  RemoteControl
//
//  Created by Lin on 2018/3/30.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//  定义网络接口相关宏

#ifndef NETMacro_h
#define NETMacro_h

//错误地址
#define HMDERRORLANADDRESS  @"errorAddress"
//当前IP
#define HMDCURLINKDEVICEIP [[NSUserDefaults standardUserDefaults] objectForKey:DLANLINKIP]
//当前IP
#define HMDCURWECHAHID [[NSUserDefaults standardUserDefaults] objectForKey:WXCurHID]
//设备发现
#define HMD_DLAN_SEARCHDEVICE    @"M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMan:\"ssdp:discover\"\r\nMX: 1\r\nST:\"searchTarget:ssdp:all\"\r\n\r\n"
//遥控器按钮
#define HMD_DLAN_KEYSTOKE_EVENT  @"http://%@:8899/send"
//设备信息
#define HMD_DLAN_DEVICE_INFO  @"http://%@:8899/get"
//截屏
#define HMD_DLAN_DEVICE_GETCAPTURE  @"http://%@:8899/getCapture"
//下载图片
#define HMD_DLAN_DEVICE_DOWNLOADICON  @"http://%@:8899/getNoPackageAppIcon"
//获取所有应用
#define HMD_DLAN_DEVICE_GETALLAPK @"http://%@:8899/getAllApkInfo"
//播放网络地址
#define HMD_DLAN_PLAY_MEDIA @"http://%@:8899/playURL"
//网络海报
#define HMD_DLAN_VIDEO_RECOMMEND_NETLIST @"http://hot.mv.hinavi.net/hmd-box/mv/hot"
//播放历史记录视频
#define HMD_DLAN_VIDEO_PLAY_HISTORY @"http://%@:8899/getPlayRecord"
//播放历史记录中的数据
#define HMD_DLAN_VIDEO_PLAY_HISTORYVIDEO @"http://%@:8899/playRecord"
//海报分类
#define HMD_DLAN_VIDEO_CATEGORY @"http://%@:8899/getPosterCategory"
//海报图片
#define HMD_DLAN_VIDEO_GET_POSTERIMAGE @"http://%@:8899/getPic"
//播放海报视频
#define HMD_DLAN_VIDEO_POSTER_PLAY @"http://%@:8899/playNetPoster"
//后台登录
#define HMD_HINAVI_LOGIN @"http://account.ms.hinavi.net/account-service/account/login"
//微信登录个人信息
#define HMD_WINXIN_USERINFO @"https://api.weixin.qq.com/sns/userinfo"
//微信刷新token
#define HMD_WINXIN_REFRESH_TOKEN @"https://api.weixin.qq.com/sns/oauth2/refresh_token"
//微信登录
#define HMD_WINXIN_OAUTH2 @"https://api.weixin.qq.com/sns/oauth2/access_token"

//本地安装的app
#define HMD_DLAN_ALLAPPLIST @"http://%@:8899/getAllApk"
//打开本地apk
#define HMD_DLAN_OPENAPK @"http://%@:8899/startApk"
//安装apk
#define HMD_DLAN_INSTALLAPK @"http://%@:8899/remoteApkStall"
//本地安装的app的图标
#define HMD_DLAN_APK_ICON @"http://%@:8899/getApkIcon"
//后台app推荐
#define HMD_HINAVI_ALLAPPLIST @"http://account.ms.hinavi.net/account-service/search/appList"
//后台app安装 ps 暂时没用
#define HMD_HINAVI_APPINSTALL @"http://account.ms.hinavi.net/account-service/search/pushRecord"
//后台搜索热词
#define HMD_HINAVI_SEARCH_HOTWORD @"http://account.ms.hinavi.net/account-service/search/hotWord"
//后台搜索关键字
#define HMD_HINAVI_SEARCH_KEYWORD @"http://account.ms.hinavi.net/account-service/search/linkage"
//后台搜索TV
#define HMD_HINAVI_SEARCH_TV @"http://account.ms.hinavi.net/account-service/search/search"

#endif /* NETMacro_h */
