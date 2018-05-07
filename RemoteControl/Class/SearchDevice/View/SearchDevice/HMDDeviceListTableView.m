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
        self.sectionFooterHeight = 0;
        self.backgroundColor = HMDColor(28, 28, 32, 1);
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self registerNib:[UINib nibWithNibName:@"HMDDeviceListTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];

    }
    return self;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = self.deviceArray.count;
    return num;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    HMDDeviceListTableViewCell *deviceListCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    HMDRenderDeviceModel *deviceModel = [self.deviceArray objectAtIndex:indexPath.row];
    [deviceListCell setupUIWithDeviceModel:deviceModel];
    return deviceListCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.deviceListDeletage && [self.deviceListDeletage respondsToSelector:@selector(didSelectRowAtIndexPath:deviceModel:)]) {
        NSString *uuid = [self.deviceArray[indexPath.row] uuid];
        [[[HMDDHRCenter sharedInstance] DMRControl] chooseRenderWithUUID:uuid];
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:DLANLastTimeLinkDeviceUUID];
        HMDRenderDeviceModel *deviceModel = [[[HMDDHRCenter sharedInstance] DMRControl] getCurrentRender];
        [self.deviceListDeletage didSelectRowAtIndexPath:indexPath.row deviceModel:deviceModel];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor grayColor];
    UIButton *addMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addMoreBtn setImage:[UIImage imageNamed:@"search-gray"] forState:UIControlStateNormal];
    [addMoreBtn setTitle:@"重新搜索" forState:UIControlStateNormal];
    [addMoreBtn addTarget:self action:@selector(searchMoreDevice:) forControlEvents:UIControlEventTouchUpInside];
    [addMoreBtn sizeToFit];
    [footView addSubview:addMoreBtn];
    addMoreBtn.center = CGPointMake(HMDScreenW*0.5, 22);
//    footView.backgroundColor = [UIColor redColor];
    return footView;
}

#pragma mark - 点击
-(void)searchMoreDevice:(UIButton *)btn{
    if (self.deviceListDeletage && [self.deviceListDeletage respondsToSelector:@selector(researchMoreDevices)]) {
        [self.deviceListDeletage researchMoreDevices];
    }
}
//#pragma mark - 其他
//-(void)reloadDeviceData:(NSArray *)deviceArray{
//    self.deviceArray = [NSMutableArray arrayWithArray:deviceArray];
//    [self reloadData];
//}
#pragma mark - 懒加载
-(NSMutableArray *)deviceArray{
    if (_deviceArray == nil) {
        _deviceArray = [NSMutableArray array];
    }
    return _deviceArray;
}
@end
