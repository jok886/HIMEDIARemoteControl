//
//  HMDSearchDeviceViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/4.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDSearchDeviceViewController.h"
//#import "HMDSearchDeviceDao.h"
#import "HMDDLANNetTool.h"
#import "HMDDHRCenter.h"
#import "HMDDeviceInfoModel.h"
#import "HMDDeviceListTableView.h"
#import "AppDelegate.h"
@interface HMDSearchDeviceViewController ()<HMDDeviceListTableViewDelegate,HMDDMRControlDelegate>
@property (nonatomic,strong) NSString *lanNetSSID;
//@property (nonatomic,strong) HMDSearchDeviceDao *searchDao;
//@property (nonatomic,strong) NSMutableArray *deviceArray;
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
//    UIButton *searchQRButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [searchQRButton setImage:[UIImage imageNamed:@"search-gray"] forState:UIControlStateNormal];
//    [searchQRButton setImage:[UIImage imageNamed:@"search-gray"] forState:UIControlStateHighlighted];
//    [searchQRButton addTarget:self action:@selector(searchMore) forControlEvents:UIControlEventTouchUpInside];
//    [searchQRButton sizeToFit];
//    
//    // 设置返回按钮
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchQRButton];
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
    NSDictionary *wifiDict = [HMDDLANNetTool fetchSSIDInfo];
    if ([[wifiDict allKeys]containsObject:@"SSID"]) {
        self.lanNetSSID = [wifiDict objectForKey:@"SSID"];
        self.curDLANLab.text = [NSString stringWithFormat:@"当前网络:%@",self.lanNetSSID];
    }else{
        NSLog(@"没有连接局域网");
    }

}
-(void)searchAllDevice{
    if (self.lanNetSSID) {

        [[[HMDDHRCenter sharedInstance] DMRControl] setDelegate:self];
        //启动DMC去搜索设备
        if (![[[HMDDHRCenter sharedInstance] DMRControl] isRunning]) {
            [[[HMDDHRCenter sharedInstance] DMRControl] start];
        }else{
            [[[HMDDHRCenter sharedInstance] DMRControl] restart];
        }
    }
}

#pragma mark - ZM_DMRProtocolDelegate
-(void)onDMRAdded
{
    self.deviceListTableView.deviceArray = [[NSMutableArray alloc] initWithArray:[[[HMDDHRCenter sharedInstance] DMRControl] getActiveRenders]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.deviceListTableView reloadData];
    });
    NSLog(@"%s",__FUNCTION__);
}

/**
 移除DMR
 */
-(void)onDMRRemoved
{
    NSLog(@"%s",__FUNCTION__);
    self.deviceListTableView.deviceArray = [[NSMutableArray alloc] initWithArray:[[[HMDDHRCenter sharedInstance] DMRControl] getActiveRenders]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.deviceListTableView reloadData];
    });
    
}

#pragma mark - ZM_DMRProtocolDelegate

-(void)getCurrentAVTransportActionResponse:(HMDCurrentAVTransportActionResponse *)response
{
    NSLog(@"%@",response.actions);
}
-(void)getTransportInfoResponse:(HMDTransportInfoResponse *)response
{
    NSLog(@"cur_transport_state:%@--cur_transport_status:%@--:%@",response.cur_transport_state,response.cur_transport_status,response.cur_speed);
    [[[HMDDHRCenter sharedInstance] DMRControl] getCurrentTransportAction];
}

-(void)previousResponse:(HMDEventResultResponse *)response
{
    [[[HMDDHRCenter sharedInstance] DMRControl] getCurrentTransportAction];
    NSLog(@"%s",__FUNCTION__);
}

-(void)nextResponse:(HMDEventResultResponse *)response
{
    [[[HMDDHRCenter sharedInstance] DMRControl] getCurrentTransportAction];
    NSLog(@"%s",__FUNCTION__);
}

-(void)DMRStateViriablesChanged:(NSArray <HMDEventParamsResponse *> *)response
{
    [response enumerateObjectsUsingBlock:^(HMDEventParamsResponse * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //NSLog(@"deviceUUID:%@,ServiceID:%@,eventName:%@,eventValue:%@",obj.deviceUUID,obj.serviceID,obj.eventName,obj.eventValue);
    }];
}


-(void)setAVTransponrtResponse:(HMDEventResultResponse *)response
{
    NSLog(@"%s",__FUNCTION__);
    [[[HMDDHRCenter sharedInstance] DMRControl] getTransportInfo];
}

-(void)setVolumeResponse:(HMDEventResultResponse *)response
{
    [[[HMDDHRCenter sharedInstance] DMRControl] getCurrentTransportAction];
    NSLog(@"%s",__FUNCTION__);
    
    
    [[[HMDDHRCenter sharedInstance] DMRControl] renderGetVolome];
}


-(void)didSelectRowAtIndexPath:(NSInteger)index deviceModel:(HMDRenderDeviceModel *)deviceModel{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.devicesService = deviceModel;
    //链接
    if (self.selectedFinishBlock) {
        self.selectedFinishBlock(deviceModel.localIP);
    }
}

-(void)researchMoreDevices{
    [self.deviceListTableView.deviceArray removeAllObjects];

    self.deviceListTableView.sectionFooterHeight = 0;
    [self.deviceListTableView reloadData];
   [self searchAllDevice];
    
    NSLog(@"%s",__FUNCTION__);
    //删掉所有设备
    [self.deviceListTableView.deviceArray removeAllObjects];
    //重启DMC
    [[[HMDDHRCenter sharedInstance] DMRControl] restart];
    //获取新设备
    self.deviceListTableView.deviceArray = [[NSMutableArray alloc] initWithArray:[[[HMDDHRCenter sharedInstance] DMRControl] getActiveRenders]];
    
}

#pragma mark -点击
//返回
- (void)backAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:HMDLinkViewWillShow object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
