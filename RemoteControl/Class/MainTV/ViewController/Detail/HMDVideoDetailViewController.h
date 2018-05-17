//
//  HMDVideoDetailViewController.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/26.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseViewController.h"
#import "HMDVideoModel.h"
@interface HMDVideoDetailViewController : HMDBaseViewController
@property (nonatomic,strong) HMDVideoModel *videoModel;
@property (nonatomic,assign) BOOL netPoster;                    //网络视频
@property (nonatomic,assign) BOOL pushModel;                    //push出来的
@end
