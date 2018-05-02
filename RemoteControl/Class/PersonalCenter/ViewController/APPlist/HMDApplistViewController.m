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
    self.view.backgroundColor = [UIColor blackColor];
    [self getAPPlistData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
//    [HMDLinkView sharedInstance].hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:HMDLinkViewWillShow object:nil];
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

    return appListCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     HMDAPKModel *apkModel ;
    switch (self.appListType) {
        case HMDInstallAppListType:
        {
            apkModel = self.installAppList[indexPath.row];
            [self openApkWithModel:apkModel];
        }
            break;
        case HMDRecommendAppListType:
        {
            apkModel = self.recommendAppList[indexPath.row];
            [self installApkWithModel:apkModel indexPath:indexPath];
        }
            break;
        case HMDAllAppListType:
        {
            if (indexPath.section == 0) {
                apkModel = self.installAppList[indexPath.row];
                [self openApkWithModel:apkModel];
            }
            if (indexPath.section == 1) {
                apkModel = self.recommendAppList[indexPath.row];
                [self installApkWithModel:apkModel indexPath:indexPath];
                
            }
        }
            break;
        default:
            break;
    }

}

#pragma mark - 其他
-(void)openApkWithModel:(HMDAPKModel *)apkModel{
    HMDWeakSelf(self)
    [self.appListDao openDLanAppWithPackage:apkModel.package FinishBlock:^(BOOL success) {
        if (success) {
            HMDTVRemoteViewController *remoteViewController = [[HMDTVRemoteViewController alloc] init];
            remoteViewController.pushVC = YES;
            remoteViewController.powerOffBlock = ^{
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            };
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
                remoteViewController.powerOffBlock = ^{
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                };
                [weakSelf.navigationController pushViewController:remoteViewController animated:YES];
            }
            
        }];
    }

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

-(NSMutableDictionary *)installingAppListDict{
    if (_installingAppListDict == nil) {
        _installingAppListDict = [NSMutableDictionary dictionary];
    }
    return _installingAppListDict;
}
@end
