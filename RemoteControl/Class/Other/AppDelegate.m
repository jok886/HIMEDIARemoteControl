//
//  AppDelegate.m
//  RemoteControl
//
//  Created by Lin on 2018/3/30.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "AppDelegate.h"
#import "HMDMainViewController.h"
#import <HPCastLink/HPCastLink.h>
#import <WXApi.h>
#import "HMDDLANNetTool.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


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
//    [[HMDDLANNetTool sharedInstance] startWebServer];

    //初始化根控制器
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    HMDMainViewController *mainVC = [[HMDMainViewController alloc] init];
    self.window.rootViewController = mainVC;
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


@end
