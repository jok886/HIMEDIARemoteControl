//
//  HMDProgressHub.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMDProgressHub : NSObject
+ (void)showMessage:(NSString *)message hideAfter:(CGFloat)time; 
@end
