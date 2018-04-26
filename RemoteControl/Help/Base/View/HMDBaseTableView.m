//
//  HMDBaseTableView.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/26.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseTableView.h"

@interface HMDBaseTableView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSString *reuseIdentifier;
@end


@implementation HMDBaseTableView

-(instancetype)initTableViewWithCellClass:(NSString *)className frame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        self.sectionFooterHeight = 0;
        self.backgroundColor = HMDColor(28, 28, 32, 1);
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.reuseIdentifier =className;
        [self registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:self.reuseIdentifier];
        
    }
    return self;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = self.dataArray.count;
    return num;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *deviceListCell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier];

    return deviceListCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}


#pragma mark - 懒加载
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
