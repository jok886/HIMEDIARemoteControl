//
//  HMDFavoriteVideoTableViewCell.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/17.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDVideoHistoryModel.h"
@interface HMDFavoriteVideoTableViewCell : UITableViewCell
-(void)setupCellWithModel:(HMDVideoHistoryModel *)videoModel;
@end