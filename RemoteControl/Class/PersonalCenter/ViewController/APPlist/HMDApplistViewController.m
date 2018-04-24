//
//  HMDApplistViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/23.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDApplistViewController.h"
#import "HMDAPPListTableViewCell.h"
#import "HMDAppListDao.h"
@interface HMDApplistViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *installAppList;                        //已安装的app
@property (nonatomic,strong) NSMutableArray *recommendAppList;                      //推荐的app
@property (nonatomic,weak) UITableView *appListTableView;                           //appList
@property (nonatomic,strong) HMDAppListDao *appListDao;                             //appListDao
@end

@implementation HMDApplistViewController
static NSString * const reuseIdentifier = @"HMDAPPListTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self getAPPlistData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化

-(void)getAPPlistData{
    HMDWeakSelf(self)
    self.appListDao = [[HMDAppListDao alloc] init];
    [self.appListDao getInstallAppListFinishBlock:^(BOOL success, NSArray *appList) {
        if (success) {
            weakSelf.installAppList = [NSMutableArray arrayWithArray:appList];
            [weakSelf.appListTableView reloadData];
        }
    }];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.installAppList.count;
    }
    if (section == 1) {
        return self.recommendAppList.count;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger num = 0;
    if (self.recommendAppList.count >0) {
        num++;
    }
    if (self.installAppList.count >0) {
        num++;
    }
    return num;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSMutableArray *titleArray = [NSMutableArray array];
    if (self.installAppList.count >0) {
        [titleArray addObject:@"已安装应用"];
    }
    if (self.recommendAppList.count >0) {
        [titleArray addObject:@"推荐应用"];
    }
    if (titleArray.count == 2) {
        if (section == 0) {
            return @"已安装应用";
        }
        if (section == 1) {
            return @"推荐应用";
        }
    }
    if (titleArray.count == 1) {
        return [titleArray firstObject];
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMDAPPListTableViewCell *appListCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    HMDAPKModel *apkModel ;
    if (indexPath.section == 0) {
        apkModel = self.installAppList[indexPath.row];
        apkModel.apkStyle = HMDAPKInstallStyle;
    }
    [appListCell setupCellWithAPKModel:apkModel];
    return appListCell;
}

#pragma mark - 懒加载

-(UITableView *)appListTableView{
    if (_appListTableView == nil) {
        UITableView *appListTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        appListTableView.delegate = self;
        appListTableView.dataSource = self;
        [appListTableView registerNib:[UINib nibWithNibName:@"HMDAPPListTableViewCell" bundle:[NSBundle mainBundle]]  forCellReuseIdentifier:reuseIdentifier];
        _appListTableView = appListTableView;
        [self.view addSubview:appListTableView];
    }
    return _appListTableView;
}

-(NSMutableArray *)installAppList{
    if (_installAppList == nil) {
        _installAppList = [NSMutableArray array];
    }
    return _installAppList;
}

-(NSMutableArray *)recommendAppList{
    if (_recommendAppList == nil) {
        _recommendAppList = [NSMutableArray array];
    }
    return _recommendAppList;
}
@end
