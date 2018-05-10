//
//  HMDSearchDeviceViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/4.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDSearchDeviceViewController.h"

#import "HMDDLANNetTool.h"
#import "HMDDHRCenter.h"

#import "HMDDeviceInfoModel.h"

#import "HMDDeviceListTableView.h"
#import "AppDelegate.h"
@interface HMDSearchDeviceViewController ()<HMDDeviceListTableViewDelegate,HMDDMRControlDelegate>

@property (weak, nonatomic) IBOutlet UILabel *linkStateLab;                         //链接状态文字

@property (nonatomic,strong) NSString *lanNetSSID;                                  //局域网ssid
@property (weak, nonatomic) IBOutlet UIView *linkStateView;                         //状态页
@property (weak, nonatomic) IBOutlet UIImageView *linkStateImageView;               //状态标识

@property (weak, nonatomic) IBOutlet UILabel *curDLANLab;                           //局域网
@property (weak, nonatomic) IBOutlet UILabel *curDevicesNumLab;                     //设备数
@property (nonatomic,weak) IBOutlet HMDDeviceListTableView *deviceListTableView;    //设备列表
@property (weak, nonatomic) IBOutlet UILabel *unFoundDeviceLab;
@property (weak, nonatomic) IBOutlet UIView *bottomView;                            //底部控制器

@property (nonatomic,strong) NSDate *stopAnimationTime;                             //动画停止的时间
@property (nonatomic,strong) NSString *curSelectUUID;                               //当前选中的UUID
@end

@implementation HMDSearchDeviceViewController
static NSString * const scanAnimationKey = @"scanAnimationKey";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupUI];
    [self getLanIP];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self searchAllDevice];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - UI
-(void)setupUI{
    [self resetupMainView];
    [self setupTableView];
    [self setUnFoundView];
}
-(void)resetupMainView{
    //渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, HMDScreenW, 254);
    gradientLayer.colors = @[(id)HMDColorFromValue(0x3BC797).CGColor,(id)HMDColorFromValue(0x3BC7C5).CGColor];  // 设置渐变颜色
    gradientLayer.startPoint = CGPointMake(0.5, 0);   //
    gradientLayer.endPoint = CGPointMake(0.5, 1);     //
    [self.linkStateView.layer insertSublayer:gradientLayer atIndex:0];
}

-(void)setupTableView{
    self.deviceListTableView.deviceListDeletage = self;

}
//未找到相关设备
-(void)setUnFoundView{
    self.unFoundDeviceLab.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.deviceListTableView.deviceArray.count == 0) {
            self.unFoundDeviceLab.hidden = NO;
        }
    });
}


#pragma mark -局域网获取
-(void)getLanIP{
    NSDictionary *wifiDict = [HMDDLANNetTool fetchSSIDInfo];
    if ([[wifiDict allKeys]containsObject:@"SSID"]) {
        self.lanNetSSID = [wifiDict objectForKey:@"SSID"];
        self.curDLANLab.text = [NSString stringWithFormat:@"当前网络:%@",self.lanNetSSID];
    }
}
-(void)searchAllDevice{
    //假装开启动画
    [self startScanAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.deviceListTableView.deviceArray.count == 0) {
            [self stopScanAnimaton];
            self.unFoundDeviceLab.hidden = NO;
        }
    });
}

//刷新数据
-(void)reloadTableViewWithdeviceArray:(NSArray *)deviceArray{
    dispatch_async(dispatch_get_main_queue(), ^{
        //数据刷新的时候做个2s的动画
        self.stopAnimationTime = [NSDate dateWithTimeIntervalSinceNow:2];
        [self startScanAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([[NSDate date] laterDate:self.stopAnimationTime]) {
                [self stopScanAnimaton];
            }
        });
        NSMutableArray *devices = [[NSMutableArray alloc] initWithArray:[[[HMDDHRCenter sharedInstance] DMRControl] getActiveRenders]];
        self.deviceListTableView.deviceArray = devices;
        self.curDevicesNumLab.text = [NSString stringWithFormat:@"找到%lu个设备",(unsigned long)self.deviceListTableView.deviceArray.count];
        [self.deviceListTableView reloadData];
        if (devices.count == 0) {
            self.unFoundDeviceLab.hidden = NO;
        }else{
            self.unFoundDeviceLab.hidden = YES;
        }
        //如果之前有选中UUID
        if (self.curSelectUUID) {
            BOOL haveCurDevice = NO;
            for (HMDRenderDeviceModel *deviceModel in devices) {
                if ([deviceModel.uuid isEqualToString:self.curSelectUUID]) {
                    haveCurDevice = YES;
                    break ;
                }
            }
            if (haveCurDevice) {
                [[[HMDDHRCenter sharedInstance] DMRControl] chooseRenderWithUUID:self.curSelectUUID];
                HMDRenderDeviceModel *deviceModel = [[[HMDDHRCenter sharedInstance] DMRControl] getRenderWithUUID:self.curSelectUUID];
                [self changeLinkState:YES ip:deviceModel.localIP uuid:self.curSelectUUID];
                NSLog(@"重新连接到设备%@",self.curSelectUUID);
            }else{
                [self changeLinkState:NO ip:nil uuid:nil];
                NSLog(@"丢失已经连接到的设备%@",self.curSelectUUID);
            }
        }
    });
}

//动画
-(void)startScanAnimation{
    if ([[self.linkStateImageView.layer animationKeys] containsObject:scanAnimationKey]) {
        return;
    }else{
        [self.linkStateImageView setImage:[UIImage imageNamed:@"device_scan"]];
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2];
        rotationAnimation.duration = 1.0f;
        rotationAnimation.repeatCount = MAXFLOAT;
        [self.linkStateImageView.layer addAnimation:rotationAnimation forKey:scanAnimationKey];
    }

}

-(void)stopScanAnimaton{
    if ([[self.linkStateImageView.layer animationKeys] containsObject:scanAnimationKey]) {
        [self.linkStateImageView.layer removeAnimationForKey:scanAnimationKey];
        switch ([HMDLinkView sharedInstance].linkViewState) {
            case HMDLinkViewStateLinked:
                [self.linkStateImageView setImage:[UIImage imageNamed:@"device_connected"]];
                break;
            default:
                [self.linkStateImageView setImage:[UIImage imageNamed:@"device_unconnected"]];
                break;
        }
    }
}


-(IBAction)researchMoreDevices:(id)sender {
    [self.deviceListTableView.deviceArray removeAllObjects];
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

#pragma mark - HMDDeviceListTableViewDelegate
-(void)didSelectRowAtIndexPath:(NSInteger)index deviceModel:(HMDRenderDeviceModel *)deviceModel selected:(BOOL)selected{

    if (selected) {
        self.curSelectUUID = deviceModel.uuid;
    }else{
        self.curSelectUUID = nil;
    }
    if (deviceModel.localIP == nil) {
        HMDRenderDeviceModel *deviceModelIP = [[[HMDDHRCenter sharedInstance] DMRControl] getRenderWithUUID:deviceModel.uuid];
        deviceModel.localIP = deviceModelIP.localIP;
    }
    [self changeLinkState:selected ip:deviceModel.localIP uuid:deviceModel.uuid];
}

#pragma mark -点击
//返回
- (IBAction)backAction:(id)sender {
    [HMDLinkView sharedInstance].hidden = NO;
//    [[NSNotificationCenter defaultCenter] postNotificationName:HMDLinkViewWillShow object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 其他
-(void)changeLinkState:(BOOL)link ip:(NSString *)ip uuid:(NSString *)uuid{
    HMDLinkViewState linkState = HMDLinkViewStateLinked;
    if (link) {
        if (![[self.linkStateImageView.layer animationKeys] containsObject:scanAnimationKey]) {
            [self.linkStateImageView setImage:[UIImage imageNamed:@"device_connected"]];
        }
        
        self.linkStateLab.text = @"已连接";
    }else{
        linkState = HMDLinkViewStateunLink;
        if (![[self.linkStateImageView.layer animationKeys] containsObject:scanAnimationKey]) {
            [self.linkStateImageView setImage:[UIImage imageNamed:@"device_unconnected"]];
        }
        
        self.linkStateLab.text = @"未连接";
    }
    [[[HMDDHRCenter sharedInstance] DMRControl] chooseRenderWithUUID:uuid];
    [[HMDLinkView sharedInstance] switchLinkState:linkState ip:ip];
}

@end
