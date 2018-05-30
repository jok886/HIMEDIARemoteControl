//
//  HMDLocationVideoCollectionViewCell.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/29.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMDLocationVideoModel;
@interface HMDLocationVideoCollectionViewCell : UICollectionViewCell
-(void)setupCellWithLocationVideoModel:(HMDLocationVideoModel *)videoModel;
@end
