//
//  HMDTVFilterCollectionViewCell.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/27.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDVideoModel.h"
@interface HMDTVFilterCollectionViewCell : UICollectionViewCell

-(void)setupTVFilterCellWithModel:(HMDVideoModel *)videoModel;
@end
