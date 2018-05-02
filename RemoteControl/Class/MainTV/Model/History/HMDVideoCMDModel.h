//
//  HMDVideoCMDModel.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/26.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseModel.h"

@interface HMDVideoCMDModel : HMDBaseModel
@property (nonatomic,strong) NSString *video_id;
@property (nonatomic,strong) NSString *video_type;
@property (nonatomic,strong) NSString *video_begin_time;
@property (nonatomic,strong) NSString *video_duration;
@property (nonatomic,strong) NSString *video_index;
@property (nonatomic,strong) NSString *video_index_name;
@property (nonatomic,strong) NSString *video_index_count;
@property (nonatomic,strong) NSString *video_ui_style;
@property (nonatomic,strong) NSString *current_position;
@property (nonatomic,strong) NSString *package_name;
@property (nonatomic,strong) NSString *lastTime;
@end
