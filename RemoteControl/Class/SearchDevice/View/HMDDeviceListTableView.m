//
//  HMDDeviceLisgTableView.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDDeviceListTableView.h"
#import "HMDDeviceListTableViewCell.h"
@interface HMDDeviceListTableView()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation HMDDeviceListTableView
static NSString * const reuseIdentifier = @"HMDDeviceListTableViewCell";
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = HMDColor(28, 28, 32, 1);
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self registerNib:[UINib nibWithNibName:@"HMDDeviceListTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    }
    return self;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    HMDDeviceListTableViewCell *deviceListCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    HMDDeviceModel *deviceModel = [self.deviceArray objectAtIndex:indexPath.row];
    [deviceListCell setupUIWithDeviceModel:deviceModel];
    return deviceListCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.deviceListDeletage && [self.deviceListDeletage respondsToSelector:@selector(didSelectRowAtIndexPath:deviceModel:)]) {
        HMDDeviceModel *deviceModel = [self.deviceArray objectAtIndex:indexPath.row];
        [self.deviceListDeletage didSelectRowAtIndexPath:indexPath.row deviceModel:deviceModel];
    }
}
#pragma mark - 其他
-(void)reloadDeviceData:(NSArray *)deviceArray{
    self.deviceArray = [NSMutableArray arrayWithArray:deviceArray];
    [self reloadData];
}
#pragma mark - 懒加载
-(NSMutableArray *)deviceArray{
    if (_deviceArray == nil) {
        _deviceArray = [NSMutableArray array];
    }
    return _deviceArray;
}
@end
