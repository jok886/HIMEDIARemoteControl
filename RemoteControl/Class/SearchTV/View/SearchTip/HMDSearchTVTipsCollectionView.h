//
//  HMDSearchTVTipsCollectionView.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/11.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDSearchTipHeadView.h"

typedef enum {
    HMDSearchTVRecordTipsType = 0,              //记录
    HMDSearchTVHotTipsType = 1,                 //热词
    HMDSearchTVRecordAndHotTipsType = 2,        //记录与热词
    HMDSearchTVRecommendTipsType = 3,           //推荐
} HMDSearchTVTipsType;

typedef void(^HMDSearchTVTipBlock)(NSString *keyWord);
@interface HMDSearchTVTipsCollectionView : UICollectionView
@property (nonatomic,strong) NSMutableArray *recordArray;                       //搜索记录词组
@property (nonatomic,strong) NSArray *hotArray;                                 //热门词组
@property (nonatomic,strong) NSArray *recommendArray;                           //推荐词组
@property (nonatomic,assign) HMDSearchTVTipsType searchTVTipsType;              //推荐模式
@property (nonatomic,copy) HMDSearchTVTipBlock searchTVTipBlock;                //关键词搜索


+(instancetype)searchTVTipsCollectionViewWithFrame:(CGRect)frame;
@end
