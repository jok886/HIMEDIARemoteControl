//
//  HMDSearchDeviceViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/4.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDSearchDeviceViewController.h"
#import "HMDSearchDeviceDao.h"
#import "HMDLANNetTool.h"

#import "HMDDeviceListTableView.h"

@interface HMDSearchDeviceViewController ()<HMDSearchDeviceDaoDelegate,HMDDeviceListTableViewDelegate>
@property (nonatomic,strong) NSString *lanNetSSID;
@property (nonatomic,strong) HMDSearchDeviceDao *searchDao;
@property (nonatomic,strong) NSMutableArray *deviceArray;
@property (nonatomic,strong) NSMutableDictionary *deviceDict;
@property (weak, nonatomic) IBOutlet UILabel *curDLANLab;
@property (nonatomic,weak) HMDDeviceListTableView *deviceListTableView;

@end

@implementation HMDSearchDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getLanIP];
    [self searchAllDevice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
#pragma mark - UI
-(void)setupUI{
    [self setupNavigation];
    [self setupTableView];
}
-(void)setupNavigation{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompact];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"btn_back_wbg"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"btn_back_wbg"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //扫描按钮
    UIButton *searchQRButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchQRButton setImage:[UIImage imageNamed:@"search-gray"] forState:UIControlStateNormal];
    [searchQRButton setImage:[UIImage imageNamed:@"search-gray"] forState:UIControlStateHighlighted];
    [searchQRButton addTarget:self action:@selector(searchMore) forControlEvents:UIControlEventTouchUpInside];
    [searchQRButton sizeToFit];
    
    // 设置返回按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchQRButton];
}

-(void)setupTableView{
    CGRect tableViewFrame = CGRectMake(0, 220, HMDScreenW, HMDScreenH - 220);
    HMDDeviceListTableView *deviceListTableView = [[HMDDeviceListTableView alloc]initWithFrame:tableViewFrame];
    deviceListTableView.deviceListDeletage = self;
    [self.view addSubview:deviceListTableView];
    self.deviceListTableView = deviceListTableView;
    
}
#pragma mark -局域网获取
-(void)getLanIP{
    NSDictionary *wifiDict = [HMDLANNetTool fetchSSIDInfo];
    if ([[wifiDict allKeys]containsObject:@"SSID"]) {
        self.lanNetSSID = [wifiDict objectForKey:@"SSID"];
        self.curDLANLab.text = [NSString stringWithFormat:@"当前网络:%@",self.lanNetSSID];
    }else{
        NSLog(@"没有连接局域网");
    }

}
-(void)searchAllDevice{
    if (self.lanNetSSID) {
        self.searchDao = [[HMDSearchDeviceDao alloc]init];
        self.searchDao.delegate = self;
        HMDWeakSelf(self)
        self.searchDao.searchFinishBlock = ^{
            weakSelf.deviceListTableView.sectionFooterHeight = 44;
            [weakSelf.deviceListTableView reloadData];
        };
        [self.searchDao searchDevices];
    }
}

#pragma mark - HMDSearchDeviceDaoDelegate
//发现新设备UUID
-(void)SearchNewDevice:(HMDDeviceModel *)newDeviceModel{
    //请求设备详情
//    NSLog(@"设备UUID:%@\n详情地址:%@",newDeviceModel.uuid,newDeviceModel.location);
    HMDWeakSelf(self)
//    [self.deviceArray addObject:newDeviceModel];
//    NSInteger curIndex = [self.deviceArray indexOfObject:newDeviceModel];
    [self.searchDao getMoreInfoFromDevice:newDeviceModel finishBlock:^(BOOL success, HMDDeviceModel *newDeviceModel) {
        if (success) {
            [weakSelf.deviceArray addObject:newDeviceModel];
            [weakSelf upTableViewData];
            
        }
    }];
}

-(void)didSelectRowAtIndexPath:(NSInteger)index deviceModel:(HMDDeviceModel *)deviceModel{
    //链接
    if (self.selectedFinishBlock) {
        self.selectedFinishBlock(deviceModel.ip);
    }
}

-(void)researchMoreDevices{
    [self.deviceArray removeAllObjects];
    self.deviceListTableView.sectionFooterHeight = 0;
    [self.deviceListTableView reloadData];
   [self.searchDao searchDevices];
    
}
#pragma mark - 其他
-(void)upTableViewData{
    [self.deviceListTableView reloadDeviceData:self.deviceArray];
}
#pragma mark -点击
//返回
- (void)backAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:HMDLinkViewWillShow object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//搜索
-(void)searchMore{
    
}
#pragma mark -懒加载
-(NSMutableArray *)deviceArray{
    if (_deviceArray == nil) {
        _deviceArray = [NSMutableArray array];
    }
    return _deviceArray;
}



@end
