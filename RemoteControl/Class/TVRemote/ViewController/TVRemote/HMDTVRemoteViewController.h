//
//  HMDTVRemoteViewController.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/3.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseViewController.h"
typedef void(^HMDTVRemotePowerOffBlock)(void);
@interface HMDTVRemoteViewController : HMDBaseViewController
@property (nonatomic,copy) HMDTVRemotePowerOffBlock powerOffBlock;
@property (nonatomic,assign,getter=isPushVC) BOOL  pushVC;                    //push进来的
@property (nonatomic,assign) BOOL showLinkViewWhenDismiss;                    //push进来的
@end
