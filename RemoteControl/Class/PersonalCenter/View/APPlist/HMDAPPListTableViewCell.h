//
//  HMDAPPListTableViewCell.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/23.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDAPKModel.h"
@interface HMDAPPListTableViewCell : UITableViewCell
-(void)setupCellWithAPKModel:(HMDAPKModel *)model;
@end
