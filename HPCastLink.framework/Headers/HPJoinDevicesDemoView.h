//
//  HPJoinDevicesDemoView.h
//  HappyCast
//
//  Created by 王志军 on 16/4/26.
//  Copyright © 2016年 王志军. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HPDevicesService;
@class HPJoinDevicesDemoView;

@protocol HPJoinDevicesDemoViewDelegate <NSObject>

/**
 *  cell点击
 *
 *  @param devicesService 设备服务
 */
- (void)joinDevicesViewDelegate:(HPJoinDevicesDemoView *)joinDevicesView devicesCellSelectClick:(HPDevicesService *)devicesService;

/**
 *  用户取消设备连接
 */
- (void)joinDevicesViewCancelDevicesConnectionDelegate:(HPJoinDevicesDemoView *)joinDevicesView;

@end

@interface HPJoinDevicesDemoView : UIButton<UITableViewDataSource,UITableViewDelegate>

///  搜索设备
- (void)searchServiceAnimation;

/**
 *  取消选中服务
 */
- (void)cancelSelectedService;

/**
 *  移除self动画
 */
- (void)removeSelfAnimate;


@property (nonatomic,weak)id<HPJoinDevicesDemoViewDelegate>delegate;

/// 设备模型数组
@property (nonatomic,strong)NSMutableArray<HPDevicesService *> *netServiceAry;

/// 标题label
@property (nonatomic,strong)UILabel *titleLabelView;

@end
