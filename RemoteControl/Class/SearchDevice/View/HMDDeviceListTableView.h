//
//  HMDDeviceLisgTableView.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMDDeviceModel;
@protocol HMDDeviceListTableViewDelegate<NSObject>

@optional
- (void)didSelectRowAtIndexPath:(NSInteger )index deviceModel:(HMDDeviceModel *)deviceModel;
@end
@interface HMDDeviceListTableView : UITableView
@property (nonatomic,strong) NSMutableArray *deviceArray;
@property (nonatomic,weak) id<HMDDeviceListTableViewDelegate> deviceListDeletage;
-(void)reloadDeviceData:(NSArray *)deviceArray;
@end
