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
@property (nonatomic,strong) NSString *img_url_vertical;
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
//本地影片
@property (nonatomic,strong) NSString *collect;
@property (nonatomic,strong) NSString *country;
@property (nonatomic,strong) NSString *dateModified;
@property (nonatomic,strong) NSString *extra1;
@property (nonatomic,strong) NSString *extra2;
@property (nonatomic,strong) NSString *fanartPicString;
@property (nonatomic,strong) NSString *genre;
@property (nonatomic,strong) NSString *language;
@property (nonatomic,strong) NSString *machineLinkString;
@property (nonatomic,strong) NSString *md5;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *path;
@property (nonatomic,strong) NSString *posterPicString;
@property (nonatomic,strong) NSString *rating;
@property (nonatomic,strong) NSString *s_name;
@property (nonatomic,strong) NSString *series_name;
@property (nonatomic,strong) NSString *t_actor;
@property (nonatomic,strong) NSString *t_credits;
@property (nonatomic,strong) NSString *t_plot;
@property (nonatomic,strong) NSString *t_year;
@property (nonatomic,strong) NSString *totalRating;
@property (nonatomic,strong) NSString *tv_id;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *videoId;
@property (nonatomic,strong) NSString *videoType;


@end
