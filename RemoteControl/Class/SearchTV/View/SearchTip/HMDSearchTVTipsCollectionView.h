//
//  HMDSearchTVTipsCollectionView.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/11.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDSearchTipHeadView.h"
@interface HMDSearchTVTipsCollectionView : UICollectionView
@property (nonatomic,strong) NSMutableArray *recordArray;
@property (nonatomic,strong) NSMutableArray *hotArray;
+(instancetype)searchTVTipsCollectionViewWithFrame:(CGRect)frame;
@end
