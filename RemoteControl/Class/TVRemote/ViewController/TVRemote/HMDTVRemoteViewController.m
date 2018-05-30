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

@interface HMDTVRemoteViewController (){
    CGFloat maxX;
    CGFloat maxY;
}
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

@property (nonatomic,weak) UIView *touchShowView;                       //触电位置
@property (nonatomic,strong) CAEmitterLayer *emitterLayer;              //粒子生成器
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

            //开启粒子动画
            [self startEmitterAnimaton];
            break;
        case UIGestureRecognizerStateEnded:

            //关闭粒子动画
            [self endEmitterAnimaton];

            break;
        default:
            
            break;
    }
    
    CGPoint center = [panGesture locationInView:self.gestureView];

    if (center.x < 0) {
        center.x = 0;
    }
    if (center.x > maxX) {
        center.x = maxX;
    }
    if (center.y < 0) {
        center.y = 0;
    }
    if (center.y > maxY) {
        center.y = maxY;
    }
    self.touchShowView.center = center;
    self.emitterLayer.emitterPosition = center;

    CGPoint translation = [panGesture translationInView:self.gestureView];
    CGFloat x = translation.x;
    if (center.x == 0 || center.x == maxX) {
        x = 0;
    }
    CGFloat y = translation.y;
    if (center.y == 0 || center.y == maxY) {
        y = 0;
    }
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
    
    //限制区域
    maxX = CGRectGetWidth(self.gestureView.bounds);
    maxY = CGRectGetHeight(self.gestureView.bounds);
    
    self.touchShowView.center = CGPointMake(maxX * 0.5 , maxY * 0.5);

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
//下载图片
-(void)downLoadImageFromFilePath:(NSString *)filePath ip:(NSString *)ip{
    HMDWeakSelf(self)
    NSLog(@"downLoadImageFromFilePath%@",self.remoteDao);
    [self.remoteDao downLoadImageFromFilepath:filePath ip:ip Finish:^(BOOL success, NSData *imageData) {
        HMDStrongSelf(self)
        NSLog(@"还活着%@",strongSelf);
    }];
}
//粒子动画
-(void)startEmitterAnimaton{
    self.emitterLayer.birthRate = 1;
}

-(void)endEmitterAnimaton{
    self.emitterLayer.birthRate = 0;
}
//外圈动画
-(CAAnimationGroup *)getOutsideTouchImageViewAnimation{
    CABasicAnimation *scaleAnimation_1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation_1.toValue = [NSNumber numberWithFloat:0.8];
    scaleAnimation_1.duration = 1.0f;
    scaleAnimation_1.removedOnCompletion = NO;
    CABasicAnimation *scaleAnimation_2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation_2.fromValue = [NSNumber numberWithFloat:0.8];
    scaleAnimation_2.toValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation_2.duration = 1.0f;
    scaleAnimation_2.beginTime = 1.0;
    scaleAnimation_2.removedOnCompletion = NO;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[scaleAnimation_1,scaleAnimation_2];
    
    groupAnimation.duration = 2;
    
    groupAnimation.removedOnCompletion = NO;
    // 始终保持最新的效果
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.repeatCount = MAXFLOAT;
    return groupAnimation;
}

//内圈动画
-(CAAnimationGroup *)getMiddleTouchImageViewAnimation{
    CABasicAnimation *scaleAnimation_1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation_1.fromValue = [NSNumber numberWithFloat:0.6];
    scaleAnimation_1.toValue = [NSNumber numberWithFloat:1];
    scaleAnimation_1.duration = 1.0f;
    scaleAnimation_1.removedOnCompletion = NO;
    CABasicAnimation *scaleAnimation_2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation_2.fromValue = [NSNumber numberWithFloat:1];
    scaleAnimation_2.toValue = [NSNumber numberWithFloat:0.6];
    scaleAnimation_2.duration = 1.0f;
    scaleAnimation_2.beginTime = 1.0;
    scaleAnimation_2.removedOnCompletion = NO;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[scaleAnimation_1,scaleAnimation_2];
    
    groupAnimation.duration = 2;
    
    groupAnimation.removedOnCompletion = NO;
    // 始终保持最新的效果
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.repeatCount = MAXFLOAT;
    return groupAnimation;
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

-(UIView *)touchShowView{
    if (_touchShowView == nil) {
        UIView *touchShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        //最外层动画
         UIImageView *touchImageView_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        touchImageView_1.image = [UIImage imageNamed:@"remote_focus_l"];
        CAAnimationGroup *outsideTouchImageViewAnimation = [self getOutsideTouchImageViewAnimation];
        [touchImageView_1.layer addAnimation:outsideTouchImageViewAnimation forKey:@"outsideTouchImageViewAnimation"];
        [touchShowView addSubview:touchImageView_1];
        //中间层动画
         UIImageView *touchImageView_2 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 25, 25)];
        touchImageView_2.image = [UIImage imageNamed:@"remote_focus_l"];
        CAAnimationGroup *middleTouchImageViewAnimation = [self getMiddleTouchImageViewAnimation];
        [touchImageView_2.layer addAnimation:middleTouchImageViewAnimation forKey:@"middleTouchImageViewAnimation"];
        [touchShowView addSubview:touchImageView_2];
        //内层
        UIImageView *touchImageView_3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 15, 15)];
        touchImageView_3.image = [UIImage imageNamed:@"remote_focus_s"];
        [touchShowView addSubview:touchImageView_3];
        
        
        _touchShowView = touchShowView;
        [self.gestureView addSubview:touchShowView];
    }
    return _touchShowView;
}
-(CAEmitterLayer *)emitterLayer{
    if (_emitterLayer == nil) {
        CAEmitterCell *cell = [[CAEmitterCell alloc] init];
        //展示的图片
        UIImage *cellImage = [UIImage imageNamed:@"remote_focus_l"];
        cell.contents = (__bridge id _Nullable)(cellImage.CGImage);
        
        //每秒粒子产生个数的乘数因子，会和layer的birthRate相乘，然后确定每秒产生的粒子个数
        cell.birthRate = 30;
        //每个粒子存活时长
        cell.lifetime = 0.8;
        //粒子生命周期范围
        //    cell.lifetimeRange = 0;
        //粒子透明度变化，设置为－0.4，就是每过一秒透明度就减少0.4，这样就有消失的效果,一般设置为负数。
        cell.alphaSpeed = -1;
        //    cell.alphaRange = 0.5;
        //粒子的速度
        cell.velocity = 0;
        //粒子的速度范围
        cell.velocityRange = 0;
        //周围发射的角度，如果为M_PI*2 就可以从360度任意位置发射
        //cell.emissionRange = M_PI*2;
        //粒子内容的颜色
        //    cell.color = [[UIColor whiteColor] CGColor];
        
        //设置了颜色变化范围后每次产生的粒子的颜色都是随机的
        //    cell.redRange = 0.5;
        //    cell.blueRange = 0.5;
        //    cell.greenRange = 0.5;
//        CGFloat scale = (CGFloat)(35.0/cellImage.size.width);
        //缩放比例
        cell.scale = 0.5;
        cell.scaleSpeed = -0.8;
        //缩放比例范围
//            cell.scaleRange = 0.02;
        
        //粒子的初始发射方向
        //    cell.emissionLongitude = M_PI;
        //Y方向的加速度
        cell.yAcceleration = 0;
        //X方向加速度
        //    cell.xAcceleration = 20.0;
        
        _emitterLayer = [CAEmitterLayer layer];
        
        //发射位置
        _emitterLayer.emitterPosition = CGPointZero;
        //粒子产生系数，默认为1
        _emitterLayer.birthRate = 1;
        //发射器的尺寸
        //    _emitterLayer.emitterSize = CGSizeMake(SCREEN_WIDTH, 0);
        //发射的形状
        _emitterLayer.emitterShape = kCAEmitterLayerLine;
        //发射的模式
        _emitterLayer.emitterMode = kCAEmitterLayerLine;
        //渲染模式
        _emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
        _emitterLayer.masksToBounds = NO;
        //_emitterLayer.zPosition = -1;
        _emitterLayer.emitterCells = @[cell];
        [self.gestureView.layer addSublayer:_emitterLayer];
    }
    return _emitterLayer;
}
@end
