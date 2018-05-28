//
//  HMDImageShowCollectionViewCell.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/24.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum :NSInteger{
    HMDImageShowCollectionViewCellNormalState,
    HMDImageShowCollectionViewCellSelectState,
    HMDImageShowCollectionViewCellUnselectState,
}HMDImageShowCollectionViewCellState;
@interface HMDImageShowCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *cellStateImageView;
@property (nonatomic,assign) HMDImageShowCollectionViewCellState cellState;          //选择状态
@end
