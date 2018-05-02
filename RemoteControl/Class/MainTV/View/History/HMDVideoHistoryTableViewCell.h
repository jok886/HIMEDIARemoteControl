//
//  HMDVideoHistoryTableViewCell.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/25.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDVideoHistoryModel.h"
@interface HMDVideoHistoryTableViewCell : UITableViewCell
-(void)setupCellWithHistoryModel:(HMDVideoHistoryModel *)historyModel;
@end
