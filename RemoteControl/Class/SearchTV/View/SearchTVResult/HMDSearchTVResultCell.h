//
//  HMDSearchTVResultCell.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/25.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDVideoModel.h"
@interface HMDSearchTVResultCell : UICollectionViewCell

-(void)setupCellWithVideoModel:(HMDVideoModel *)videoModel;
@end
