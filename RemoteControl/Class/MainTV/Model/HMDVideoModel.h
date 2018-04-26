//
//  HMDVideoModel.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/18.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseModel.h"

@interface HMDVideoModel : HMDBaseModel
@property (nonatomic,strong) NSString *callback_action;
@property (nonatomic,strong) NSString *callback_key;
@property (nonatomic,strong) NSString *callback_method;
@property (nonatomic,strong) NSString *callback_value;
@property (nonatomic,strong) NSString *videoID;
@property (nonatomic,strong) NSString *img_url;
@property (nonatomic,strong) NSString *info;
@property (nonatomic,strong) NSString *source;
@property (nonatomic,strong) NSString *source_package;
@property (nonatomic,strong) NSString *title;
//callback_value 中的值
@property (nonatomic,strong) NSString *video_id;
@property (nonatomic,strong) NSString *video_type;
@property (nonatomic,strong) NSString *video_duration;
@property (nonatomic,strong) NSString *video_index;
@property (nonatomic,strong) NSString *video_index_name;
@property (nonatomic,strong) NSString *video_ui_style;
@property (nonatomic,strong) NSString *played_time;
//播放记录

@end
