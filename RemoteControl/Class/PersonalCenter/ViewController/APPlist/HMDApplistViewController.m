//
//  HMDApplistViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/23.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDApplistViewController.h"
#import "HMDTVRemoteViewController.h"
#import "HMDAPPListTableViewCell.h"
#import "HMDAppListDao.h"
typedef enum {
    HMDInstallAppListType = 0,
    HMDRecommendAppListType = 1,
    HMDAllAppListType = 2,
} HMDAppListType;
@interface HMDApplistViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *installAppList;                        //已安装的app
@property (nonatomic,strong) NSMutableArray *recommendAppList;                      //推荐的app
@property (nonatomic,strong) NSMutableDictionary *installingAppListDict;            //正在安装的app
@property (nonatomic,weak) UITableView *appListTableView;                           //appList
@property (nonatomic,strong) HMDAppListDao *appListDao;                             //appListDao
@property (nonatomic,assign) HMDAppListType appListType;                            //列表数据类型
@end

@implementation HMDApplistViewController
static NSString * const reuseIdentifier = @"HMDAPPListTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HMDColor(204, 204, 204, 1);
    self.title = @"我的应用";
    [self setupFirstNavBar];
    [self getAPPlistData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [HMDLinkView sharedInstance].hidden = NO;
//    [[NSNotificationCenter defaultCenter] postNotificationName:HMDLinkViewWillShow object:nil];
}
#pragma mark - 初始化

-(void)getAPPlistData{
    HMDWeakSelf(self)
    self.appListDao = [[HMDAppListDao alloc] init];
    self.appListDao.installAppFinishBlock = ^(NSString *package) {
        if ([[weakSelf.installingAppListDict allKeys]containsObject:package]) {
            NSIndexPath *indexPath = [weakSelf.installingAppListDict objectForKey:package];
            HMDAPKModel *apkModel = weakSelf.recommendAppList[indexPath.row];
            apkModel.installed = @"2";
            [weakSelf.recommendAppList replaceObjectAtIndex:indexPath.row withObject:apkModel];
            [weakSelf.appListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        }
    };
    [self.appListDao getInstallAppListFinishBlock:^(BOOL success, NSArray *appList) {
        if (success) {
            weakSelf.installAppList = [NSMutableArray arrayWithArray:appList];
            [weakSelf.appListTableView reloadData];
        }
    }];
    [self.appListDao getRecommendAppListFinishBlock:^(BOOL success, NSArray *appList) {
        if (success) {
            weakSelf.recommendAppList = [NSMutableArray arrayWithArray:appList];
            
            [weakSelf.appListTableView reloadData];
        }
    }];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.appListType) {
        case HMDInstallAppListType:
            {
                return self.installAppList.count;
            }
            break;
        case HMDRecommendAppListType:
        {
            return self.recommendAppList.count;
        }
            break;
        case HMDAllAppListType:
        {
            if (section == 0) {
                return self.installAppList.count;
            }
            if (section == 1) {
                return self.recommendAppList.count;
            }
        }
            break;
        default:
                return 0;
            break;
    }

    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger num = 0;
    if (self.recommendAppList.count >0 && self.installAppList.count >0) {
        self.appListType = HMDAllAppListType;
        num = 2;
    }else{
        if (self.recommendAppList.count >0) {
            self.appListType = HMDRecommendAppListType;
        }
        if (self.installAppList.count >0) {
            self.appListType = HMDInstallAppListType;
        }
        num++;
    }

    return num;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, HMDScreenW-40, 30)];
    headerLabel.backgroundColor = HMDColor(240, 240, 240, 1);
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:12];
    NSMutableArray *titleArray = [NSMutableArray array];
    if (self.installAppList.count >0) {
        NSString *title = [NSString stringWithFormat:@"   已安装应用(%lu)",(unsigned long)self.installAppList.count];
        [titleArray addObject:title];
    }
    if (self.recommendAppList.count >0) {
        NSString *title = [NSString stringWithFormat:@"   推荐应用(%lu)",(unsigned long)self.recommendAppList.count];
        [titleArray addObject:title];
    }
    if (titleArray.count == 2) {
        if (section == 0) {
            NSString *title = [NSString stringWithFormat:@"   已安装应用(%lu)",(unsigned long)self.installAppList.count];
            headerLabel.text = title;
        }
        if (section == 1) {
            NSString *title = [NSString stringWithFormat:@"   推荐应用(%lu)",(unsigned long)self.recommendAppList.count];
            headerLabel.text = title;
        }
    }
    if (titleArray.count == 1) {
        headerLabel.text = [titleArray firstObject];
    }
    return headerLabel;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMDAPPListTableViewCell *appListCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    HMDAPKModel *apkModel ;

    switch (self.appListType) {
        case HMDInstallAppListType:
        {
            apkModel = self.installAppList[indexPath.row];
            apkModel.apkStyle = HMDAPKInstallStyle;
        }
            break;
        case HMDRecommendAppListType:
        {
            apkModel = self.recommendAppList[indexPath.row];
            apkModel.apkStyle = HMDAPKRecommendStyle;
        }
            break;
        case HMDAllAppListType:
        {
            if (indexPath.section == 0) {
                apkModel = self.installAppList[indexPath.row];
                apkModel.apkStyle = HMDAPKInstallStyle;
            }
            if (indexPath.section == 1) {
                apkModel = self.recommendAppList[indexPath.row];
                apkModel.apkStyle = HMDAPKRecommendStyle;
                
            }
        }
            break;
        default:
            break;
    }
    [appListCell setupCellWithAPKModel:apkModel];
    appListCell.indexPath = indexPath;
    HMDWeakSelf(self)
    appListCell.actionBlock = ^(NSIndexPath *indexPath) {
        HMDAPKModel *apkModel ;
        switch (weakSelf.appListType) {
            case HMDInstallAppListType:
            {
                apkModel = weakSelf.installAppList[indexPath.row];
                [weakSelf openApkWithModel:apkModel];
            }
                break;
            case HMDRecommendAppListType:
            {
                apkModel = weakSelf.recommendAppList[indexPath.row];
                [weakSelf installApkWithModel:apkModel indexPath:indexPath];
            }
                break;
            case HMDAllAppListType:
            {
                if (indexPath.section == 0) {
                    apkModel = weakSelf.installAppList[indexPath.row];
                    [weakSelf openApkWithModel:apkModel];
                }
                if (indexPath.section == 1) {
                    apkModel = weakSelf.recommendAppList[indexPath.row];
                    [weakSelf installApkWithModel:apkModel indexPath:indexPath];
                    
                }
            }
                break;
            default:
                break;
        }
    };
    appListCell.uninstallBlock = ^(NSIndexPath *indexPath) {
        HMDAPKModel *apkModel = weakSelf.installAppList[indexPath.row];
        [weakSelf uninstallApkWithModel:apkModel];
    };
    return appListCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - 其他
-(void)openApkWithModel:(HMDAPKModel *)apkModel{
    HMDWeakSelf(self)
    [self.appListDao openDLanAppWithPackage:apkModel.package FinishBlock:^(BOOL success) {
        if (success) {
            HMDTVRemoteViewController *remoteViewController = [[HMDTVRemoteViewController alloc] init];
            remoteViewController.pushVC = YES;
//            remoteViewController.powerOffBlock = ^{
//                [weakSelf dismissViewControllerAnimated:YES completion:nil];
//            };
            [weakSelf.navigationController pushViewController:remoteViewController animated:YES];
        }

    }];
}

-(void)installApkWithModel:(HMDAPKModel *)apkModel indexPath:(NSIndexPath *)indexPath{
    if ([apkModel.installed isEqualToString:@"1"]) {
        HMDWeakSelf(self)
        [self.installingAppListDict setObject:indexPath forKey:apkModel.pkg];
        [self.appListDao installHINAVIAppWithAPKModel:apkModel FinishBlock:^(BOOL success) {
            if (success) {
                HMDAPKModel *apkModel = weakSelf.recommendAppList[indexPath.row];
                apkModel.installed = @"0";
                [weakSelf.recommendAppList replaceObjectAtIndex:indexPath.row withObject:apkModel];
                [weakSelf.appListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            }else{
                [weakSelf.installingAppListDict removeObjectForKey:apkModel.pkg];
            }
        }];
    }else if ([apkModel.installed isEqualToString:@"2"]){
        //安装过的
        HMDWeakSelf(self)
        [self.appListDao openDLanAppWithPackage:apkModel.pkg FinishBlock:^(BOOL success) {
            if (success) {
                HMDTVRemoteViewController *remoteViewController = [[HMDTVRemoteViewController alloc] init];
                remoteViewController.pushVC = YES;
//                remoteViewController.powerOffBlock = ^{
//                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
//                };
                [weakSelf.navigationController pushViewController:remoteViewController animated:YES];
            }
            
        }];
    }

}
-(void)uninstallApkWithModel:(HMDAPKModel *)apkModel{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"请确定是否卸载此应用" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction * actionClear = [UIAlertAction actionWithTitle:@"卸载" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        HMDWeakSelf(self)
        [self.appListDao uninstallDLanAppWithPackage:apkModel.package FinishBlock:^(BOOL success) {
            if (success) {
                if ([weakSelf.installAppList containsObject:apkModel]) {
                    [weakSelf.installAppList removeObject:apkModel];
                    [weakSelf.appListTableView reloadData];
                }
            }
        }];
    }];
    [alertC addAction:actionCancel];
    [alertC addAction:actionClear];
    [self presentViewController:alertC animated:YES completion:nil];

}
#pragma mark - 懒加载

-(UITableView *)appListTableView{
    if (_appListTableView == nil) {
        UITableView *appListTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        appListTableView.delegate = self;
        appListTableView.dataSource = self;
        [appListTableView registerNib:[UINib nibWithNibName:@"HMDAPPListTableViewCell" bundle:[NSBundle mainBundle]]  forCellReuseIdentifier:reuseIdentifier];
        appListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        appListTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

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

-(NSMutableDictionary *)installingAppListDict{
    if (_installingAppListDict == nil) {
        _installingAppListDict = [NSMutableDictionary dictionary];
    }
    return _installingAppListDict;
}
@end
