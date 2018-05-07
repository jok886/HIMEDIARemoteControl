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

#import <HPCastLink/HPCastLink.h>
#import <WXApi.h>
#import "HMDDLANNetTool.h"


@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate
static NSString * const kUserHasOnboardedKey = @"user_has_onboarded";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //清空上次登录的设置
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DLANLINKIP];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WXCurHID];
    //微信登录
    [WXApi registerApp:@"wxed8c151bb3208370"];
//乐播SDK
//    if ([[HPCastLink sharedCastLink] appkeyVerify:@"29b77f20395691d76cc69fa9bd8e7971"]) {
//         NSLog(@"appkeyVerify_enableDLNA");
//        [HPCastLink sharedCastLink].enableDLNA = YES;
//    }else{
//        NSLog(@"appkeyVerify");
//    }
    //开启httpweb
    [[HMDDLANNetTool sharedInstance] startWebServer];

    //初始化根控制器

    NSString *userHasOnboardedKey = [[NSUserDefaults standardUserDefaults] objectForKey:kUserHasOnboardedKey];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if ([userHasOnboardedKey isEqualToString:@"1.0"]) {
        [self setupNormalRootViewController];

    }else {
        [self setupOnboardedRootViewController];
//        self.window.rootViewController = [self generateStandardOnboardingVC];

    }

    [self.window makeKeyAndVisible];
    
    return YES;
}

//微信登录
-(void)onResp:(BaseResp *)resp{
    //登录后的回调
    if ([resp isKindOfClass:[SendAuthResp class]]) {//登录
        [[NSNotificationCenter defaultCenter] postNotificationName:HMDWechatLogin object:resp];
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
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"What A Beautiful Photo" body:@"This city background image is so beautiful." image:[UIImage imageNamed:@"blue"] buttonText:@"Enable Location Services" action:^{
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction * actionClear = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        }];
        [alertC addAction:actionCancel];
        [alertC addAction:actionClear];
        [self.window.getCurActiveViewController presentViewController:alertC animated:YES completion:nil];
    }];

    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"I'm so sorry" body:@"I can't get over the nice blurry background photo." image:[UIImage imageNamed:@"red"] buttonText:@"Connect With Facebook" action:^{
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction * actionClear = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alertC addAction:actionCancel];
        [alertC addAction:actionClear];
        [self.window.getCurActiveViewController presentViewController:alertC animated:YES completion:nil];
    }];
    secondPage.movesToNextViewController = YES;
    secondPage.viewDidAppearBlock = ^{

    };

    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"Seriously Though" body:@"Kudos to the photographer." image:[UIImage imageNamed:@"yellow"] buttonText:@"Get Started" action:^{
        [self handleOnboardingCompletion];
    }];

    OnboardingViewController *onboardingVC = [OnboardingViewController onboardWithBackgroundImage:[UIImage imageNamed:@"street"] contents:@[firstPage, secondPage, thirdPage]];
    onboardingVC.shouldFadeTransitions = YES;
    onboardingVC.fadePageControlOnLastPage = YES;
    onboardingVC.fadeSkipButtonOnLastPage = YES;
    [onboardingVC.skipButton setTitle:@"跳过" forState:UIControlStateNormal];
    // If you want to allow skipping the onboarding process, enable skipping and set a block to be executed
    // when the user hits the skip button.
    onboardingVC.allowSkipping = YES;
    onboardingVC.skipHandler = ^{
        [self handleOnboardingCompletion];
    };

    self.window.rootViewController = onboardingVC;
}

- (void)handleOnboardingCompletion {

    [self setupNormalRootViewController];
}
@end
