//
//  HMDTVClassifyCollectionView.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/27.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDTVClassifyCollectionView : UICollectionView
@property (nonatomic,strong) NSIndexPath *curIndexPath;
@property (nonatomic,strong) NSArray *classifyArray;
@property (nonatomic,copy) void(^selectClassifyBlock)(NSString *classifyName,BOOL videoType);
@end
