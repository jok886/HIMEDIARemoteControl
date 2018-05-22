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

/********************************登录********************************/
//后台登录
#define HMD_HINAVI_LOGIN @"http://account.ms.hinavi.net/account-service/account/login"
//微信登录个人信息
#define HMD_WINXIN_USERINFO @"https://api.weixin.qq.com/sns/userinfo"
//微信刷新token
#define HMD_WINXIN_REFRESH_TOKEN @"https://api.weixin.qq.com/sns/oauth2/refresh_token"
//微信登录
#define HMD_WINXIN_OAUTH2 @"https://api.weixin.qq.com/sns/oauth2/access_token"
//获取动态码
//#define HMD_HINAVI_DYNAMICCODE @"http://account.ms.hinavi.net/account-service/phone/getDynamicCode"
#define HMD_HINAVI_DYNAMICCODE @"http://172.20.6.110/account-service/phone/getDynamicCode"
//手机注册
//#define HMD_HINAVI_PHONE_REGISTER @"http://account.ms.hinavi.net/account-service/phone/register"
#define HMD_HINAVI_PHONE_REGISTER @"http://172.20.6.110/account-service/phone/register"
//手机登录
//#define HMD_HINAVI_PHONE_REGISTER @"http://account.ms.hinavi.net/account-service/phone/login"
#define HMD_HINAVI_PHONE_LOGIN @"http://172.20.6.110/account-service/phone/login"
//忘记密码
//#define HMD_HINAVI_PHONE_RECOVERPWD @"http://account.ms.hinavi.net/account-service/phone/recoveredPassword"
#define HMD_HINAVI_PHONE_RECOVERPWD @"http://172.20.6.110/account-service/phone/recoveredPassword"
//上传头像
//#define HMD_HINAVI_PHONE_UPLOADAVATAR @"http://account.ms.hinavi.net/account-service/phone/uploadAvatar"
#define HMD_HINAVI_PHONE_UPLOADAVATAR @"http://172.20.6.110:11020/account-service/phone/uploadAvatar"
//更新头像
//#define HMD_HINAVI_PHONE_SAVEAVATAR @"http://account.ms.hinavi.net/account-service/phone/saveAvatar"
#define HMD_HINAVI_PHONE_SAVEAVATAR @"http://172.20.6.110/account-service/phone/saveAvatar"
//修改昵称
//#define HMD_HINAVI_PHONE_UPNICKNAME @"http://account.ms.hinavi.net/account-service/phone/updateNickname"
#define HMD_HINAVI_PHONE_UPNICKNAME @"http://172.20.6.110/account-service/phone/updateNickname"

//后台app推荐
#define HMD_HINAVI_ALLAPPLIST @"http://account.ms.hinavi.net/account-service/search/appList"
//后台app安装 ps 暂时没用
#define HMD_HINAVI_APPINSTALL @"http://account.ms.hinavi.net/account-service/search/pushRecord"
/********************************视频列表********************************/
//获取本地视频列表
#define HMD_DLAN_VIDEO_POSTER_LIST @"http://%@:8899/getPosterList"
//获取本地视频列表
#define HMD_DLAN_VIDEO_POSTER_LIST @"http://%@:8899/getPosterList"
//网络海报
#define HMD_DLAN_VIDEO_RECOMMEND_NETLIST @"http://hot.mv.hinavi.net/hmd-box/mv/hot"
//收藏列表
#define HMD_DLAN_VIDEO_COLLECT_LIST @"http://%@:8899/getCollectRecord"
/********************************播放********************************/
//播放收藏列表
#define HMD_DLAN_VIDEO_PLAY_COLLECT @"http://%@:8899/enterPosterDetail"
//播放历史记录中的数据
#define HMD_DLAN_VIDEO_PLAY_HISTORYVIDEO @"http://%@:8899/playRecord"
//播放海报视频
#define HMD_DLAN_VIDEO_POSTER_PLAY_NET @"http://%@:8899/playNetPoster"
//播放海报视频
#define HMD_DLAN_VIDEO_POSTER_PLAY @"http://%@:8899/playPoster"
//播放历史记录视频
#define HMD_DLAN_VIDEO_PLAY_HISTORY @"http://%@:8899/getPlayRecord"
//播放网络地址
#define HMD_DLAN_PLAY_MEDIA @"http://%@:8899/playURL"
/********************************搜索********************************/
//后台搜索热词
#define HMD_HINAVI_SEARCH_HOTWORD @"http://account.ms.hinavi.net/account-service/search/hotWord"
//后台搜索关键字
#define HMD_HINAVI_SEARCH_KEYWORD @"http://account.ms.hinavi.net/account-service/search/linkage"
//后台搜索TV
#define HMD_HINAVI_SEARCH_TV @"http://account.ms.hinavi.net/account-service/search/search"
/********************************图标********************************/
//本地安装的app的图标
#define HMD_DLAN_APK_ICON @"http://%@:8899/getApkIcon"
//下载图片
#define HMD_DLAN_DEVICE_DOWNLOADICON  @"http://%@:8899/getNoPackageAppIcon"
//海报图片
#define HMD_DLAN_VIDEO_GET_POSTERIMAGE @"http://%@:8899/getPic"
/********************************其他********************************/
//设备发现
#define HMD_DLAN_SEARCHDEVICE    @"M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMan:\"ssdp:discover\"\r\nMX: 1\r\nST:\"searchTarget:ssdp:all\"\r\n\r\n"
//遥控器按钮
#define HMD_DLAN_KEYSTOKE_EVENT  @"http://%@:8899/send"
//设备信息
#define HMD_DLAN_DEVICE_INFO  @"http://%@:8899/get"
//截屏
#define HMD_DLAN_DEVICE_GETCAPTURE  @"http://%@:8899/getCapture"
//获取所有应用
#define HMD_DLAN_DEVICE_GETALLAPK @"http://%@:8899/getAllApkInfo"
//海报分类
#define HMD_DLAN_VIDEO_CATEGORY @"http://%@:8899/getPosterCategory"
//本地音乐
#define HMD_DLAN_MUSIC_LIST @"http://%@:8899/getMusicList"
//播放本地音乐
#define HMD_DLAN_MUSIC_PLAY @"http://%@:8899/broadCastMusic"
//本地安装的app
#define HMD_DLAN_ALLAPPLIST @"http://%@:8899/getAllApk"
//打开本地apk
#define HMD_DLAN_OPENAPK @"http://%@:8899/startApk"
//安装apk
#define HMD_DLAN_INSTALLAPK @"http://%@:8899/remoteApkStall"
//卸载本地apk
#define HMD_DLAN_UNINSTALLAPK @"http://%@:8899/uninstall?package=%@"
#endif /* NETMacro_h */
