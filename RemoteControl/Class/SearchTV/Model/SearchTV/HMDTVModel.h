//
//  HMDTVModel.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/25.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseModel.h"

@interface HMDTVModel : HMDBaseModel
@property (nonatomic,strong) NSString *callback_action;
@property (nonatomic,strong) NSString *callback_key;
@property (nonatomic,strong) NSString *callback_method;
@property (nonatomic,strong) NSString *callback_value;
@property (nonatomic,strong) NSString *tvID;
@property (nonatomic,strong) NSString *img_url;
@property (nonatomic,strong) NSString *info;
@property (nonatomic,strong) NSString *source;
@property (nonatomic,strong) NSString *source_package;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *type;

@end
