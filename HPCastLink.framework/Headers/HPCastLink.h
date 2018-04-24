//
//  HPCastLink.h
//  HPCastLink
//
//  Created by wzj on 16/5/24.
//  Copyright © 2016年 wzj. All rights reserved.
//
//  SDK 版本 Version 2.5.0.0

#import <UIKit/UIKit.h>
#import "HPProtocolConst.h"
#import "HPDevicesService.h"
@class HPCastBarrage;
//@class HPDevicesService;

/** 投屏媒体类型 */
typedef enum : NSUInteger {
    HPCastMediaTypeVideo = 0,   // 视频
    HPCastMediaTypeMusic = 1,   // 音乐
    HPCastMediaTypePhoto = 2,   // 图片
    HPCastMediaTypeH5Web = 3,   // H5网页
}HPCastMediaType;

/** 推送URL播放错误码 */
typedef enum : NSUInteger {
    HPCastPlayUrlErrorCodeUrlEmpty = 5000,  //url为空
    HPCastPlayUrlErrorCodeConnectTVFailed,  //连接电视失败
    HPCastPlayUrlErrorCodeTVApkTooOld,      //电视接收端太老，无法投屏,只支持镜像
    HPCastPlayUrlErrorCodeUrlInvalid,       //url在Tv端播放失败，无效地址
    HPCastPlayUrlErrorCodeTVApkUpdate,      //电视接收端正在更新
}HPCastPlayUrlErrorCode;

/** 镜像错误码 */
typedef enum : NSUInteger {
    HPMirrorDevicesErrorCodeBusy = 4000,//繁忙
    HPMirrorDevicesErrorCodeTimeOut,//超时
    HPMirrorDevicesErrorCodeUnknown,//未知状态
    HPMirrorDevicesErrorCodeOpenLeboCastFailBecauseIsLeboCasting,//打开投屏时的失败回调，因为投屏已经打开了
    HPMirrorDevicesErrorCodeCloseLeboCastFailBecauseIsClosed,//关闭投屏失败，因为投屏已经处于关闭状态
    HPMirrorDevicesErrorCodeCloseLeboCastFailBecauseIsLeboAing,//关闭投屏失败，因为当前是AirPlay状态，请使用关闭AirPlay的接口方法关闭（接口使用错误）
    HPMirrorDevicesErrorCodeDeviceNameIncrrect,//设备名称错误
    HPMirrorDevicesErrorCodeOldVersion,//版本较老，不支持投屏，需要升级电视接收端版本
    HPMirrorDevicesErrorCodeDeviceUpdate,//设备更新
} HPMirrorDevicesErrorCode;

/** 投屏结果状态 */
typedef enum : NSUInteger {
    HPCastMirrorResultUserHideList      = 0,    // 用户隐藏设备列表
    HPCastMirrorResultCastURLSucceed    = 1,    // 投屏URl到电视成功
    HPCastMirrorResultMirrorSucceed     = 2,    // 镜像成功
}HPCastMirrorResults;

/** 投屏界面功能类型 */
typedef enum : NSUInteger{
    HPCastInterfaceFunctionTypeCastURL  = 1 << 0,
    HPCastInterfaceFunctionTypeMirror   = 1 << 1,
    HPCastInterfaceFunctionTypeDefault  = (HPCastInterfaceFunctionTypeCastURL | HPCastInterfaceFunctionTypeMirror),
}HPCastInterfaceFunctionType;

/** 本地化语言类型 */
typedef NS_ENUM(NSUInteger, HPLocalizableType) {
    HPLocalizableTypeDeafult,               // 默认，使用系统设置
    HPLocalizableTypeEnglish,               // 英文
    HPLocalizableTypeSimplifiedChinese,     // 简体中文
    HPLocalizableTypeTraditionalChinese,    // 繁体中文
};

typedef enum : NSUInteger{
    HPCastWatermarkLocationUpperLeftCorner  = 0,  // 左上角
    HPCastWatermarkLocationUpperRightCorner       // 右上角
}HPCastWatermarkLocation;

/** 搜索tv设备返回 （有设备变化，就会全部返回设备模型) */
typedef void(^SearchTvBlock)(NSArray<HPDevicesService *> *response);

/** 投URl和镜像回调 */
typedef void(^CastMirrorBlock)(HPCastMirrorResults response);

/** 投url和镜像结果返回 */
typedef void (^CastURLOrMirrorBlock)(BOOL succeed,NSError * error);

/** 完成结果回调 */
typedef void (^CompleteResultsBlock)(BOOL succeed);


#pragma mark - 乐投搜索设备代理方法
/***********************************乐投搜索设备代理方法*********************************/
@protocol HPCastSearchDelegate <NSObject>

@optional
//  是否有投屏的电视设备(时刻监听变化)  YES：有投屏设备,即显示投屏按钮
- (void)isHaveCastTVChange:(BOOL)isHave;

@end

#pragma mark - 乐投代理方法
/***********************************乐投代理方法****************************************/
@protocol HPCastLinkDelegate <NSObject>

@optional
/**
 设备连接成功
 */
-(void)devicesConnectSucceed;

/**
 TV投屏URL播放失败
 */
- (void)tvVideoCastFailure;

/**
 TV视频结束播放
 */
- (void)tvVideoEndPlay;

/**
 视频播放进度返回 （回调频率为一秒一次）
 
 @param progress 进度
 */
- (void)videoDynamicPlayProgress:(HPProgress)progress;

/**
 视频播放状态改变时触发
 
 @param state 播放状态
 */
- (void)videoPlayStateChangeWithState:(HPPlayState)state;

/**
 媒体音量改变时触发
 
 @param volume 音量
 */
- (void)multimediaVolumeChangeWithVolume:(HPVolume)volume;

/**
 设备连接断开
 */
- (void)devicesDisconnect;

/**
 TV端透传过来的字符串
 
 @param message 透传数据
 */
- (void)receivedTVRemoteControlStr:(NSString *)message;

/**
 TV端透传过来的数据
 
 @param data 仅支持json 或 xml格式，开发时发送端与接收端约定好格式，使用正确的格式解析数据
 */
- (void)receivedTVRemoteControlData:(NSData *)data;

@end

#pragma mark - 乐投接口
/*************************************乐投接口****************************************/

@interface HPCastLink : NSObject
/**
 获取乐投单例实例
 
 @return 乐投实例
 */
+ (instancetype)sharedCastLink;

/**
 appKey验证
 
 @param appkey 到乐播官网注册账号，并在应用管理中添加应用、填写信息、生成key
 @return 通过返回YES，否则验证不通过
 */
- (BOOL)appkeyVerify:(NSString *)appkey;

/**
 搜索接收端设备（安装有乐播接收端软件的OTT盒子、智能电视、投影仪）
 
 @param block Block中可返回接收端设备数据模型
 */
- (void)castServiceDiscoveryBlock:(SearchTvBlock)block;

/**
 停止搜索
 */
- (void)castServiceStopDiscovery;

/**
 搜索是否有可投屏设备 搜索结果在代理方法返回
 
 @param delegate 代理
 */
- (void)castServiceDiscoveryDelegate:(id<HPCastSearchDelegate>)delegate;


/** 乐投代理 */
@property (nonatomic,weak)id<HPCastLinkDelegate>delegate;

/** SDK自带的投屏界面 支持功能 默认HPCastInterfaceFunctionTypeDefault */
@property (nonatomic,assign)HPCastInterfaceFunctionType castInterfaceFunctionType;

/** SDK UI界面本地化语言设置，目前支持英文、简体中文、繁体中文，默认根据系统语言变化设置，超出范围的默认英文 */
@property (nonatomic, assign) HPLocalizableType localiableType;

/**
 是否启用DLNA
 YES：启用DLNA，当搜索不到乐播的设备的时候，再搜索DLNA设备。NO：不启用
 */
@property (nonatomic, assign) BOOL enableDLNA;


/** 是否连接Tv设备 */
@property (nonatomic,assign,readonly)BOOL isConnectTv;

/** 是否连接LeboPlayService */
@property (nonatomic, assign, readonly) BOOL isConnectLeboPlay;

/** 现在播放的视频URl */
@property (nonatomic,copy,readonly)NSString *currentPlayUrl;

/** 当前视频播放状态 */
@property (nonatomic,assign,readonly)HPPlayState playState;

/** 当前多媒体音量 */
@property (nonatomic,assign,readonly)HPVolume multimediaVolume;

/**
 把视频或音乐投屏到电视有界面（先弹出设备选择窗口,供用户选择设备后投屏到电视，该接口不支持照片推送)
 
 @param castMediaType 投送的媒体类型,该接口不支持照片推送
 @param url 视频流地址(rtmp,hls,http-flv可兼容)
 @param startPos 起始播放位置 （点播流播放设置才有效 单位：秒）
 @param viewController 设备列表View的父视图控制器
 @param completeBlock 结果回调
 */
- (void)castStartPlay:(HPCastMediaType)castMediaType url:(NSString *)url startPosition:(NSInteger)startPos superViewController:(UIViewController *)viewController completeBlock:(CastMirrorBlock)completeBlock;

/**
 把视频或音乐，照片投屏到指定tv设备 无界面api
 
 @param castMediaType 投送的媒体类型
 @param url 视频或音乐流地址(rtmp,hls,http-flv可兼容)
 @param startPos 起始播放位置 （点播流播放设置才有效 单位：秒）
 @param devicesService tv设备模型 （tv设备服务可从searchTvDevicesServiceBlock:获得）
 @param completeBlock 结果回调
 */
- (void)castStartPlay:(HPCastMediaType)castMediaType url:(NSString *)url startPosition:(NSInteger)startPos toDevicesService:(HPDevicesService *)devicesService completeBlock:(CastURLOrMirrorBlock)completeBlock;

/**
 把照片投到指定的TV设备 无界面api
 
 @param imageData 照片字节流
 @param devicesService tv设备模型 （tv设备服务可从searchTvDevicesServiceBlock:获得）
 @param completeBlock 结果回调
 */
- (void)castPhotoPlayByImageData:(NSData *)imageData toDevicesService:(HPDevicesService *)devicesService completeBlock:(CastURLOrMirrorBlock)completeBlock;

/**
 切换照片

 @param imagedata 照片字节流
 */
- (void)castSwithPhotoData:(NSData *)imagedata completeBlock:(CompleteResultsBlock)completeBlock;

/**
 切换片源播放 不弹出设备列表 (必须在连接Tv设备服务情况下调用，推视频和音乐判断isConnectTv，推照片判断isConnectLeboPlay)
 
 @param castMediaType 投送的媒体类型
 @param url 视频流地址(rtmp,hls,http-flv,mp4可兼容)
 @param startPos 起始播放位置 （点播播放设置才有效 单位：秒）
 @param completeBlock 结果回调
 @return 请求是否成功
 */
- (BOOL)castSwitchSourcesPlay:(HPCastMediaType)castMediaType url:(NSString *)url startPosition:(NSInteger)startPos completeBlock:(CompleteResultsBlock)completeBlock;

/**
 设置是否允许后台播放
 
 @param isBackPlay Yes:手机程序被杀死，TV端继续播放,NO:手机程序被杀死，TV端停止播放（默认YES）
 */
- (void)setBackgroundPlay:(BOOL)isBackPlay;

/**
 暂停播放
 */
- (void)castPause;

/**
 继续播放
 */
- (void)castPlay;

/**
 指定播放器进度(播放视频流时无效,仅限点播流播放控制)
 
 @param pos 时间(单位：秒)
 */
- (void)castSeek:(NSInteger)pos;

/**
 停止播放视频/音乐/照片
 */
- (void)castStopPlay;

/**
 指定媒体音量
 
 @param volume 指定音量大小 （范围 0 － maxVolume）
 */
- (void)castDeviceVolume:(NSInteger)volume;

/**
 增加媒体音量:
 */
- (void)castDeviceVolumeUp;

/**
 降低媒体音量
 */
- (void)castDeviceVolumeDown;

/**
 隐藏投屏设备列表连接视图
 */
- (void)hideCastLinkView;

/**
 主动断开与电视连接
 */
- (void)disconnectDevice;

/**
 透传接口-发送：此接口较老，只有华数渠道的接收端可使用
 
 @param remoteStr 透传的数据
 */
- (void)sendTVRemoteControlStr:(NSString *)remoteStr;
- (void)sendTVRemoteControl:(NSData *)remoteControl error:(NSError **)error;

#pragma mark - “乐播投屏”水印位置接口
/**
 切换水印的位置
 
 @param location 水印位置
 */
- (void)changeWatermarkLocation:(HPCastWatermarkLocation)location;

#pragma mark - 弹幕接口
/************************弹幕接口*************************/

/** 电视端是否有弹幕功能 在URL播放成功以后获取，如果电视端不支持弹幕功能，调用弹幕接口不会向下执行 */
@property (nonatomic,assign,readonly)BOOL isTvSupportBarrage;

/** 是否隐藏弹幕 默认NO */
@property (nonatomic,assign)BOOL isHideBarrage;

/** 是否暂停弹幕 默认NO */
@property (nonatomic,assign)BOOL isPauseBarrage;

/** 弹幕最大行数 默认10行 */
@property (nonatomic,assign)NSInteger barrageMaxLine;

/** 弹幕飞行速度 默认是1 可选(1，2，3，4，5)数值越大,速度越慢.ps（同一速度下，弹幕文本越长,速度会较快） */
@property (nonatomic,assign)NSInteger barrageFlySpeed;

/** 是否从底部开始显示 默认是No */
@property (nonatomic,assign)BOOL isBottomStartShow;

/** 是否允许弹幕重叠 默认是No */
@property (nonatomic,assign)BOOL isAllowOverlap;

/** 是否允许展示广告（默认为NO，后续每次都以上次退出保存的为准） */
@property (nonatomic, assign) BOOL isAllowShowAdvert;



/**
 推送弹幕数组
 
 @param barrageAry 弹幕数组
 备注：如果弹幕数组超过1000条，请分开发送
 */
- (void)pushBarrageAryToTv:(NSMutableArray<HPCastBarrage *> *)barrageAry;

/**
 优先弹幕(可用于用户自己的发送的弹幕)
 
 @param barrage 弹幕
 */
- (void)pushPriorityBarrageToTv:(HPCastBarrage *)barrage;


#pragma mark - 镜像接口
/************************镜像接口*************************/
/** 是否镜像到tv */
@property (nonatomic,assign,readonly)BOOL isMirrorTv;

/**
 把手机屏幕镜像到指定tv设备
 
 @param devicesService devicesService tv设备服务 （tv设备服务可从searchTvDevicesServiceBlock:获得）
 @param completeBlock 回调
 */
- (void)castStartMirror:(HPDevicesService *)devicesService completeBlock:(CastURLOrMirrorBlock)completeBlock;

/**
 关闭镜像
 
 @param completeBlock 完成回调
 */
- (void)castStopMirror:(CastURLOrMirrorBlock)completeBlock;



#pragma mark - 以下废弃接口，被新接口替代
/*******************************************以下废弃接口，被新接口替代*************************************************/
//  搜索tv设备，Block可返回tv设备数据模型
- (void)searchTvDevicesServiceBlock:(SearchTvBlock)block;
//  停止搜索
- (void)stopSearchTvDevicesService;
//  搜索是否有可投屏设备 搜索结果在代理方法返回
- (void)searchDevicesDelegate:(id<HPCastSearchDelegate>)delegate;
/**
 *  把视频投屏到电视 有界面（先弹出设备选择窗口,供用户选择设备后投屏到电视)
 *
 *  @param url 视频流地址(rtmp,hls,http-flv可兼容)
 *  @param startPos 起始播放位置 （点播流播放设置才有效 单位：秒）
 *  @param viewController 设备列表View的父视图控制器
 *  @param completeBlock 结果回调
 */
- (void)playUrl:(NSString *)url startPosition:(NSInteger)startPos superViewController:(UIViewController *)viewController completeBlock:(CastMirrorBlock)completeBlock;
/**
 *  切换片源播放 不弹出设备列表 (必须在连接Tv设备情况下调用，判断isConnectTv)
 *
 *  @param url      视频流地址(rtmp,hls,http-flv,mp4可兼容)
 *  @param startPos 起始播放位置 （MP4播放设置才有效 单位：秒）
 *  @param completeBlock 结果回调
 *  @return 请求是否成功
 */
- (BOOL)switchSourcesPlayUrl:(NSString *)url startPosition:(NSInteger)startPos completeBlock:(CompleteResultsBlock)completeBlock;
//  暂停播放
- (void)suspendPlay;
//  继续播放
- (void)continuePlay;
//  指定播放器进度(播放视频流时无效,仅限点播流播放控制)  @param pos 时间(单位：秒)
- (void)scrubPlayPosition:(NSInteger)pos;
//  停止播放
- (void)stopPlay;
//  指定媒体音量  @param volume 指定音量大小 （范围 0 － maxVolume）
- (void)setMultimediaVolumeWithVolume:(NSInteger)volume;
//  增加媒体音量
- (void)addMultimediaVolume;
//  降低媒体音量
- (void)reduceMultimediaVolume;
/*******************************************以上废弃接口，被新接口替代*************************************************/

@end

/**
 互动广告接口
 */
@interface HPCastLink (InteractiveAd)

/**
 开启互动广告： YES，开启；NO，不开启；默认NO
 */
@property (nonatomic, assign) BOOL enableInteractiveAd;

/**
 设置广告展示位
 
 @param superView 展示广告的视图
 @param frame 展示广告的位置
 */
- (void)setAdSuperView:(UIView *)superView frame:(CGRect)frame;

@end







