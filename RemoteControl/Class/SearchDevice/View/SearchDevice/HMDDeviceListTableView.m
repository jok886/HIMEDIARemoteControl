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
@property (nonatomic,strong) NSString *curSelectUUID;
@property (nonatomic,strong) NSIndexPath *curIndexPath;
@end
@implementation HMDDeviceListTableView
static NSString * const reuseIdentifier = @"HMDDeviceListTableViewCell";
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        self.sectionFooterHeight = 0;
        self.backgroundColor = HMDColor(28, 28, 32, 1);
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self registerNib:[UINib nibWithNibName:@"HMDDeviceListTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];

    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.delegate = self;
    self.dataSource = self;
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self registerNib:[UINib nibWithNibName:@"HMDDeviceListTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = self.deviceArray.count;
    return num;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    HMDDeviceListTableViewCell *deviceListCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    HMDRenderDeviceModel *deviceInfoModel = [self.deviceArray objectAtIndex:indexPath.row];
    if (deviceInfoModel.localIP == nil) {
        HMDRenderDeviceModel *deviceModel = [[[HMDDHRCenter sharedInstance] DMRControl] getRenderWithUUID:deviceInfoModel.uuid];
        deviceInfoModel.localIP = deviceModel.localIP;
    }
    BOOL choose = NO;
    if (self.curSelectUUID && [self.curSelectUUID isEqualToString:deviceInfoModel.uuid]) {
        self.curIndexPath = indexPath;
        choose = YES;
    }
    [deviceListCell setupUIWithDeviceModel:deviceInfoModel choose:choose];
    return deviceListCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *uuid = [self.deviceArray[indexPath.row] uuid];
    NSMutableArray *reloadIndexPaths = [NSMutableArray array];
    BOOL selected = YES;
    if (self.curIndexPath) {
        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:self.curIndexPath.row inSection:self.curIndexPath.section];
        [reloadIndexPaths addObject:reloadIndexPath];
    }
    if ([self.curSelectUUID isEqualToString:uuid]) {
        self.curSelectUUID = nil;
        self.curIndexPath = nil;
        selected = NO;
    }else{
        self.curSelectUUID = uuid;
    }
    
    [reloadIndexPaths addObject:indexPath];
    [tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationFade];

    if (self.deviceListDeletage && [self.deviceListDeletage respondsToSelector:@selector(didSelectRowAtIndexPath:deviceModel:selected:)]) {
        HMDRenderDeviceModel *deviceInfoModel = [self.deviceArray objectAtIndex:indexPath.row];
        [self.deviceListDeletage didSelectRowAtIndexPath:indexPath.row deviceModel:deviceInfoModel selected:selected];
    }

}
#pragma mark - 懒加载
-(NSMutableArray *)deviceArray{
    if (_deviceArray == nil) {
        _deviceArray = [NSMutableArray array];
    }
    return _deviceArray;
}
@end
