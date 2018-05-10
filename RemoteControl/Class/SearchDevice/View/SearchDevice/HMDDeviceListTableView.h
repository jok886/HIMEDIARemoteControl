//
//  HMDDeviceLisgTableView.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDDeviceInfoModel.h"
@protocol HMDDeviceListTableViewDelegate<NSObject>

@optional
- (void)didSelectRowAtIndexPath:(NSInteger )index deviceModel:(HMDRenderDeviceModel *)deviceModel selected:(BOOL)selected;

@end
@interface HMDDeviceListTableView : UITableView
@property (nonatomic,strong) NSMutableArray *deviceArray;
@property (nonatomic,weak) id<HMDDeviceListTableViewDelegate> deviceListDeletage;

@end
