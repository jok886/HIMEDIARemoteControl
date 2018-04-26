//
//  HMDSearchTVResultCollectionView.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/11.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMDSearchTVResultCollectionView;
@class HMDVideoModel;
@protocol HMDSearchTVResultCollectionViewDelegate <NSObject>
-(void)searchTVResultCollectionView:(HMDSearchTVResultCollectionView *)earchTVResultCollectionView didSelectItemWithModel:(HMDVideoModel *)videoModel;
@end

@interface HMDSearchTVResultCollectionView : UICollectionView
@property (nonatomic,strong) NSArray *tvModelArray;
@property (nonatomic,weak) id<HMDSearchTVResultCollectionViewDelegate> searchDelegate;

+(instancetype)searchTVResultCollectionViewWithFrame:(CGRect)frame;
@end
