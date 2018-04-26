//
//  HMDSearchTipCollectionViewCell.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/11.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>

/**君子协议*/
@protocol HMDSearchTipCollectionViewCellDelegate <NSObject>
-(void)searchTipCollectionViewCellDeleteAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface HMDSearchTipCollectionViewCell : UICollectionViewCell
@property (nonatomic,weak) id<HMDSearchTipCollectionViewCellDelegate> delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
-(void)setupCellWithTipSting:(NSString *)tip needCenter:(BOOL)needCenter deleteBtn:(BOOL)needDeleteBtn;
@end
