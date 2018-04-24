//
//  HPProtocolConst.h
//  HPPlayTVAssistant
//
//  Created by lmx on 2017/6/13.
//  Copyright © 2017年 HPPlay. All rights reserved.
//

#ifndef HPProtocolConst_h
#define HPProtocolConst_h
#ifdef __OBJC__
#import <UIKit/UIKit.h>
typedef enum { //播放状态
    HPUnknownState = 0, // 未知
    HPLoadingState,     // 加载视频
    HPSuspendState,     // 暂停
    HPPlayingState,     // 正常播放
    HPStopedState,      // 结束播放
    HPPlayFailureState, // 播放失败(错误链接...)
    HPErrorState,       // 错误
    HPVideohide,        // 收起手机上的播放器
}HPPlayState;

typedef struct{//视频播放进度
    NSInteger duration;  //时长    （单位：秒）
    NSInteger position;  //播放时间 （单位：秒）
}HPProgress;

typedef struct{//媒体音量
    NSInteger maxVolume;        // 最大音量
    NSInteger currentVolume;    // 现在音量
}HPVolume;
#endif
#endif /* HPProtocolConst_h */
