//
//  HMDDeviceListTableViewCell.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDDeviceModel.h"
@interface HMDDeviceListTableViewCell : UITableViewCell
-(void)setupUIWithDeviceModel:(HMDDeviceModel *)deviceModel;
@end
