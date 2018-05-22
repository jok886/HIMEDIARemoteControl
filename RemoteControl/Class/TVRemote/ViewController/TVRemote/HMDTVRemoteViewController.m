//
//  HMDTVRemoteViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/3.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDTVRemoteViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "KeyCodeMacro.h"
#import "HMDTVRemoteDao.h"
#import "HMDRemoteSettingViewController.h"

@interface HMDTVRemoteViewController ()
@property (nonatomic,strong) HMDTVRemoteDao *remoteDao;                 //发送按键
@property (weak, nonatomic) IBOutlet UIView *centerKeyBoardView;        //中间键盘
@property (weak, nonatomic) IBOutlet UIImageView *keyBoardBGImageView;
@property (weak, nonatomic) IBOutlet UIView *gestureView;               //手势键盘
@property (nonatomic,assign,getter=isOpenSideKey) BOOL openSideKey;     //开启侧键
@property (nonatomic,assign,getter=isOpenShock) BOOL openShock;         //开启震动
@property (nonatomic,assign,getter=isRegisterNotification) BOOL registerNotification;  //注册过通知了
@property (nonatomic,assign) CGFloat systemVolum;                       //系统音量大小
@property (nonatomic,assign) CGFloat curVolum;                          //当前音量大小
@property (nonatomic,weak) MPVolumeView *systemVolumeView;

@property (nonatomic,weak) UIImageView *touchImageView;                 //触电位置
@end

@implementation HMDTVRemoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.openSideKey = [[NSUserDefaults standardUserDefaults] boolForKey:OPENSIDEKEY];
    self.openShock = [[NSUserDefaults standardUserDefaults] boolForKey:OPENSHOCK];
    if (self.isOpenSideKey) {
        [self addNotification];
    }else{
        [self removeNotification];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [self removeNotification];
    [self.systemVolumeView removeFromSuperview];
    self.systemVolumeView = nil;

}
#pragma mark - 初始化
-(void)setupUI{
    self.title = @"海美迪盒子";
    [self setupNavigation];
    [self addGestureRecognizer];
}

-(void)addNotification{
    if (!self.isRegisterNotification) {

        self.systemVolumeView.hidden = NO;
//        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        self.systemVolum = [AVAudioSession sharedInstance].outputVolume;
        self.curVolum = self.systemVolum;
        self.registerNotification = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(suspendObserveVolumeChangeEvents:)
                                                     name:UIApplicationWillResignActiveNotification     // -> Inactive
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resumeObserveVolumeButtonEvents:)
                                                     name:UIApplicationDidBecomeActiveNotification      // <- Active
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChangeNotification:)
                                                     name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    }

}

-(void)removeNotification{
    self.registerNotification = NO;
    self.systemVolumeView.hidden = YES;

    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setupNavigation{
    [self setupFirstNavBar];
    //返回按钮

    //设置按钮
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [setButton setImage:[UIImage imageNamed:@"remote_setting"] forState:UIControlStateNormal];

    [setButton addTarget:self action:@selector(setButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [setButton sizeToFit];
    UIBarButtonItem *setBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:setButton];
    //隐藏键盘
    UIButton *hideKeyBoardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hideKeyBoardButton setImage:[UIImage imageNamed:@"remote_model"] forState:UIControlStateNormal];

    [hideKeyBoardButton addTarget:self action:@selector(hideKeyBoardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [hideKeyBoardButton sizeToFit];
    UIBarButtonItem *hideKeyBoardBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:hideKeyBoardButton];
    // 设置返回按钮
    self.navigationItem.rightBarButtonItems = @[setBarButtonItem,hideKeyBoardBarButtonItem];
}
//添加手势
-(void)addGestureRecognizer{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [self.gestureView addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.gestureView addGestureRecognizer:tapGesture];
}

#pragma mark - 手势

-(void)panGesture:(UIPanGestureRecognizer *)panGesture{
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.touchImageView.hidden = NO;
            break;
        case UIGestureRecognizerStateEnded:
            self.touchImageView.hidden = YES;
            break;
        default:
            
            break;
    }
    
    CGPoint center = [panGesture locationInView:self.gestureView];
    self.touchImageView.center = center;
    
    CGPoint translation = [panGesture translationInView:self.gestureView];
    CGFloat x = translation.x;
    CGFloat y = translation.y;
    CGFloat sensitivity = 30.0;//灵敏度
    if (fabs(x)>sensitivity || fabs(y)>sensitivity) {
        NSInteger keyCode = 0;
        if (x>sensitivity) {
            keyCode = KEYCODE_DPAD_RIGHT;
        }
        if (x<-sensitivity) {
            keyCode = KEYCODE_DPAD_LEFT;
        }
        if (y<-sensitivity) {
            keyCode = KEYCODE_DPAD_UP;
        }
        if (y>sensitivity) {
            keyCode = KEYCODE_DPAD_DOWN;
        }
        [self remoteTVWithKey:keyCode finishBlock:nil];
        [panGesture setTranslation:CGPointZero inView:self.gestureView];
    }
}
-(void)tapGesture:(UITapGestureRecognizer *)tapGesture{
    [self remoteTVWithKey:KEYCODE_DPAD_CENTER finishBlock:nil];
}
#pragma mark -点击
//返回
-(void)dismissAction:(UIButton *)sender{
    if (self.pushVC) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [super dismissAction:sender];
    }
    
    if (self.showLinkViewWhenDismiss) {
        [HMDLinkView sharedInstance].hidden = NO;
    }else{
        [HMDLinkView sharedInstance].hidden = YES;
    }
    
}
//电源
- (IBAction)TVPowerBtnClick:(UIButton *)sender {
    HMDWeakObj(self)
    [self remoteTVWithKey:KEYCODE_POWER finishBlock:^(BOOL success) {
        if (weakself.powerOffBlock) {
            weakself.powerOffBlock();
        }
        [weakself dismissAction:nil];
    }];
    
}
//首页
- (IBAction)TVHomeBtnClick:(UIButton *)sender {
    [self remoteTVWithKey:KEYCODE_HOME finishBlock:nil];
}

//OK
- (IBAction)TVOKBtnClick:(UIButton *)sender {
    
}

//按键效果
- (IBAction)keyBoardTouchDown:(UIButton *)sender {
    NSString *imageName = @"remote_direction_";
    switch (sender.tag) {
        case 101://上
            imageName = @"remote_direction_up";
            break;
        case 102://下
            imageName = @"remote_direction_down";
            break;
        case 103://左
            imageName = @"remote_direction_left";
            break;
        case 104://右
            imageName = @"remote_direction_right";
            break;
        case 105://右
            imageName = @"remote_ok_click";
            break;
            
        default:
            break;
    }
    [self.keyBoardBGImageView setImage:[UIImage imageNamed:imageName]];
}

- (IBAction)keyBoardTouchUP:(UIButton *)sender {
    switch (sender.tag) {
        case 101:
            [self remoteTVWithKey:KEYCODE_DPAD_UP finishBlock:nil];
            break;
        case 102:
            [self remoteTVWithKey:KEYCODE_DPAD_DOWN finishBlock:nil];
            break;
        case 103:
            [self remoteTVWithKey:KEYCODE_DPAD_LEFT finishBlock:nil];
            break;
        case 104:
            [self remoteTVWithKey:KEYCODE_DPAD_RIGHT finishBlock:nil];
            break;
        case 105:
            [self remoteTVWithKey:KEYCODE_DPAD_CENTER finishBlock:nil];
            break;
        default:
            break;
    }
    [self.keyBoardBGImageView setImage:nil];
}


//菜单
- (IBAction)TVMenuBtnClick:(UIButton *)sender {
    
    [self remoteTVWithKey:KEYCODE_MENU finishBlock:nil];
}
//返回
- (IBAction)TVBackBtnClick:(UIButton *)sender {
    [self remoteTVWithKey:KEYCODE_ESCAPE finishBlock:nil];
}
//音量+
- (IBAction)TVVolumeAddBtnClick:(UIButton *)sender {
    [self remoteTVWithKey:KEYCODE_VOLUME_UP finishBlock:nil];
}
//截屏
- (IBAction)TVScreenShotBtnClick:(UIButton *)sender {
    if (self.isOpenShock) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    [self.remoteDao getCaptureFinishBlock:^(BOOL success, NSData *imageData) {
        if (success) {
            UIImage *image = [UIImage imageWithData:imageData];
            UIImageView *showImageView = [[UIImageView alloc] initWithImage:image];
            showImageView.layer.anchorPoint = CGPointMake(0.1, 0.9);
            showImageView.contentMode = UIViewContentModeScaleAspectFit;
            showImageView.frame = CGRectMake(0, 0, HMDScreenW, HMDScreenH);
            [[UIApplication sharedApplication].keyWindow addSubview:showImageView];
            [UIView animateWithDuration:1.5 animations:^{
                CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.4, 0.4);
                showImageView.transform = scaleTransform;
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [showImageView removeFromSuperview];
                });
                
            }];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
    }];
}
//音量-
- (IBAction)TVVolumeMinusBtnClick:(UIButton *)sender {
    [self remoteTVWithKey:KEYCODE_VOLUME_DOWN finishBlock:nil];
}

//设置
-(void)setButtonClick:(id)sender{
    HMDRemoteSettingViewController *settingVC= [[HMDRemoteSettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}
//手势键盘
-(void)hideKeyBoardButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.centerKeyBoardView.hidden = sender.selected;
    self.gestureView.hidden = !sender.selected;

}
-(void)remoteTVWithKey:(NSInteger)keyCode finishBlock:(HMDTVRemoteFinishBlock)block{
    if (self.isOpenShock) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    [self.remoteDao remoteTVWithKey:keyCode finishBlock:block];
}
#pragma mark - 通知
- (void)suspendObserveVolumeChangeEvents:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

- (void)resumeObserveVolumeButtonEvents:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChangeNotification:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

-(void)volumeChangeNotification:(NSNotification *)notification{

    NSDictionary *infoDict = notification.userInfo;
    if ([[infoDict allKeys] containsObject:@"AVSystemController_AudioVolumeNotificationParameter"]) {
        CGFloat curVolume = [[infoDict objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
        
        if (curVolume>self.curVolum || curVolume == 1) {
            [self remoteTVWithKey:KEYCODE_VOLUME_UP finishBlock:nil];
        }else{
            [self remoteTVWithKey:KEYCODE_VOLUME_DOWN finishBlock:nil];
        }
        self.curVolum = curVolume;
    }
    NSLog(@"%@",notification);
}
#pragma mark - 其他
-(void)downLoadImageFromFilePath:(NSString *)filePath ip:(NSString *)ip{
    HMDWeakSelf(self)
    NSLog(@"downLoadImageFromFilePath%@",self.remoteDao);
    [self.remoteDao downLoadImageFromFilepath:filePath ip:ip Finish:^(BOOL success, NSData *imageData) {
        HMDStrongSelf(self)
        NSLog(@"还活着%@",strongSelf);
    }];
}
#pragma mark - 懒加载
-(HMDTVRemoteDao *)remoteDao{
    if (_remoteDao == nil) {
        _remoteDao = [[HMDTVRemoteDao alloc]init];
    }
    return _remoteDao;
}

-(MPVolumeView *)systemVolumeView{
    if (_systemVolumeView == nil) {
        MPVolumeView *systemVolumeView = [[MPVolumeView alloc]initWithFrame:CGRectMake(0, -100, 5, 5)];
        [self.view addSubview:systemVolumeView];
        _systemVolumeView = systemVolumeView;
    }
    return _systemVolumeView;
}

-(UIImageView *)touchImageView{
    if (_touchImageView == nil) {
        UIImageView *touchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        touchImageView.image = [UIImage imageNamed:@"remote_focus"];
        [self.gestureView addSubview:touchImageView];
        _touchImageView = touchImageView;
    }
    return _touchImageView;
}
@end
