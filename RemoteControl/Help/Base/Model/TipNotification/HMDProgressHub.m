//
//  HMDProgressHub.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDProgressHub.h"
#import "MBProgressHUD.h"

@implementation HMDProgressHub
+(void)showMessage:(NSString *)message hideAfter:(CGFloat)time{
    MBProgressHUD *hub =[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hub.mode = MBProgressHUDModeText;
    hub.label.text = message;
    hub.userInteractionEnabled = NO;
    [hub hideAnimated:YES afterDelay:time];
}
@end