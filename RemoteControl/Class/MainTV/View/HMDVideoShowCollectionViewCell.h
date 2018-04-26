//
//  HMDVideoShowCollectionViewCell.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/18.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMDVideoModel;
@interface HMDVideoShowCollectionViewCell : UICollectionViewCell
-(void)setupCellWithVideoModel:(HMDVideoModel *)videoModel;
@end
