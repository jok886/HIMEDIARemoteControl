//
//  HMDSearchTipCollectionViewCell.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/11.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HMDSearchTipCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSIndexPath *indexPath;
-(void)setupCellWithTipSting:(NSString *)tip needCenter:(BOOL)needCenter deleteBtn:(BOOL)needDeleteBtn;
@end
