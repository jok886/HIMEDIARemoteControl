//
//  AppDelegate.m
//  RemoteControl
//
//  Created by Lin on 2018/3/30.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "AppDelegate.h"
#import "HMDMainViewController.h"
#import "OnboardingViewController.h"
#import "OnboardingContentViewController.h"

#import <Bugly/Bugly.h>
#import <WXApi.h>
#import "HMDDLANNetTool.h"
#import "HMDLoginDao.h"

@interface AppDelegate ()<WXApiDelegate>
@property (strong, nonatomic) HMDLoginDao *loginDao;
@end

@implementation AppDelegate
static NSString * const kUserHasOnboardedKey = @"user_has_onboarded";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //清空上次登录的设置
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DLANLINKIP];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WXCurHID];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HMDLoginState];
    //微信登录
    [WXApi registerApp:@"wxed8c151bb3208370"];
    //bugly
    BuglyConfig *buglyConfig = [[BuglyConfig alloc] init];
    buglyConfig.blockMonitorEnable = YES;
    buglyConfig.blockMonitorTimeout = 1;
    [Bugly startWithAppId:@"9c9b07050c" config:buglyConfig];
    //开启httpweb
    [[HMDDLANNetTool sharedInstance] setupWebServer];
    [[HMDDLANNetTool sharedInstance] startNotificationWifi];
    //初始化根控制器
    NSLocalizedString(@"",@"");
    NSString *userHasOnboardedKey = [[NSUserDefaults standardUserDefaults] objectForKey:kUserHasOnboardedKey];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if ([userHasOnboardedKey isEqualToString:version]) {
        [self setupNormalRootViewController];
        
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:kUserHasOnboardedKey];
        [self setupOnboardedRootViewController];
    }

    [self.window makeKeyAndVisible];
    
    return YES;
}

//微信登录
-(void)onResp:(BaseResp *)resp{
    //登录后的回调
    if ([resp isKindOfClass:[SendAuthResp class]]) {//登录
        SendAuthResp *authResp = (SendAuthResp *)resp;
//        [[NSNotificationCenter defaultCenter] postNotificationName:HMDWechatLogin object:resp];
        if (authResp.errCode == 0) {
            NSLog(@"登录成功");
            NSString *code = authResp.code;
            HMDWeakSelf(self)
            [self.loginDao getWechatInfoWithCode:code finishBlock:^(BOOL success, HMDUserModel *userModel) {
                if (success) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:HMDLogin object:userModel];
                    weakSelf.userModel = userModel;
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:HMDLogin object:nil];
                }
            }];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:HMDLogin object:nil];
            NSLog(@"登录失败");
        }
    }
}

-(void)onReq:(BaseReq *)req{
    NSLog(@"");
}
-(BOOL)application:(UIApplication *)app openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return [WXApi handleOpenURL:url delegate:self];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 初始化控制器
-(void)setupNormalRootViewController{

    HMDMainViewController *mainVC = [[HMDMainViewController alloc] init];
    self.window.rootViewController = mainVC;
}

-(void)setupOnboardedRootViewController {
    HMDWeakSelf(self)
    NSMutableArray *pageArray = [NSMutableArray array];
    NSString *name ;
    int maxPage = 4;
    for (int i = 1; i <= maxPage; i++) {
        if (iPhoneX) {
            name = [NSString stringWithFormat:@"iphoneX-guide%d",i];
        }else{
            name = [NSString stringWithFormat:@"guide%d",i];
        }
        OnboardingContentViewController *page;
        
        if (i == maxPage) {
            page = [OnboardingContentViewController contentWithTitle:nil body:nil image:[UIImage imageNamed:name] buttonText:@"立即体验" action:^{
                [weakSelf handleOnboardingCompletion];
            }];
            page.actionButtonWidth = 180;
            page.actionButton.titleLabel.font = [UIFont systemFontOfSize:18];
            [page.actionButton setTitleColor:HMDMAIN_COLOR forState:UIControlStateNormal];
            page.actionButton.layer.cornerRadius = 25;
            page.actionButton.layer.borderWidth = 1;
            page.actionButton.layer.borderColor = HMDMAIN_COLOR.CGColor;
            page.bottomPadding = 44;
        }else{
            page = [OnboardingContentViewController contentWithTitle:nil body:nil image:[UIImage imageNamed:name] buttonText:nil action:^{
                
            }];
        }
        page.topPadding = 0;
        [pageArray addObject:page];
    }


    
    OnboardingViewController *onboardingVC = [OnboardingViewController onboardWithBackgroundImage:nil contents:pageArray];
//    onboardingVC.shouldFadeTransitions = YES;
    onboardingVC.fadePageControlPage = YES;
    onboardingVC.fadeSkipButtonOnLastPage = YES;
    [onboardingVC.skipButton setTitle:@"跳过" forState:UIControlStateNormal];
//    [onboardingVC.skipButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // If you want to allow skipping the onboarding process, enable skipping and set a block to be executed
    // when the user hits the skip button.
    onboardingVC.allowSkipping = YES;
    onboardingVC.skipHandler = ^{
        [weakSelf handleOnboardingCompletion];
    };
    onboardingVC.finishHandler = ^{
        [weakSelf handleOnboardingCompletion];
    };
    self.window.rootViewController = onboardingVC;
}

- (void)handleOnboardingCompletion {

    [self setupNormalRootViewController];
}

#pragma mark - 懒加载
-(HMDLoginDao *)loginDao{
    if (_loginDao == nil) {
        _loginDao = [[HMDLoginDao alloc]init];
    }
    return _loginDao;
}
@end
