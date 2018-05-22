//
//  HMDFavoriteVideoModel.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/18.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseModel.h"

@interface HMDFavoriteVideoModel : HMDBaseModel
@property (nonatomic,strong) NSString *cmd;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *extra;
@property (nonatomic,strong) NSString *extra2;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *vid;
@property (nonatomic,strong) NSString *videoAction;
@property (nonatomic,strong) NSString *videoCallback;
@property (nonatomic,strong) NSString *videoImgUrl;
@property (nonatomic,strong) NSString *videoName;
@property (nonatomic,strong) NSString *videoSource;
@property (nonatomic,strong) NSString *week;
@end
