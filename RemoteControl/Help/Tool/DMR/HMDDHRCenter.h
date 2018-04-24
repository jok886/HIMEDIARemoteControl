//
//  HMDDHRCenter.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/16.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMDDMRControl.h"

@interface HMDDHRCenter : NSObject
@property (nonatomic, strong)HMDDMRControl *DMRControl;
+(HMDDHRCenter *)sharedInstance;
@end
