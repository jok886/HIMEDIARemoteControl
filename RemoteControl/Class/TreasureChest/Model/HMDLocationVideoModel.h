//
//  HMDLocationVideoModel.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/29.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseModel.h"
@class PHAsset;
@interface HMDLocationVideoModel : HMDBaseModel
@property (nonatomic,copy) NSString *assetTitle;                //素材状态
@property (nonatomic,strong) PHAsset *asset;                //本地视频使用
@property (nonatomic,strong) UIImage *assetImage;           //本地视频使用 缩略图
@end
