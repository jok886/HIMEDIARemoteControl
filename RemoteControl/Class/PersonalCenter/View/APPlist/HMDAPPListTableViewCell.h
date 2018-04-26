//
//  HMDAPPListTableViewCell.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/23.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDAPKModel.h"
typedef enum {
    HMDAPKActionOpen = 0,               //打开
    HMDAPKActionInstall = 1,            //安装
} HMDAPKActionType; //apk的类型

//typedef void(^HMDAPPListTableViewCellActionBlock)(NSString *package,HMDAPKStyle apkStyle);
@interface HMDAPPListTableViewCell : UITableViewCell
//@property (nonatomic,copy) HMDAPPListTableViewCellActionBlock actionBlock;
-(void)setupCellWithAPKModel:(HMDAPKModel *)model;
@end
