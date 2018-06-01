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
    HMDSearchTVRecordAndHotTipsType = 0,        //记录与热词
    HMDSearchTVRecommendTipsType = 1,           //推荐
    HMDSearchTVOnleHotTipsType = 2,             //只有热词
    HMDSearchTVOnlyRecordTipsType = 3,          //只有记录
} HMDSearchTVTipsType;

typedef void(^HMDSearchTVTipBlock)(NSString *keyWord);
@interface HMDSearchTVTipsCollectionView : UICollectionView
@property (nonatomic,strong) NSMutableArray *recordArray;                       //搜索记录词组
@property (nonatomic,strong) NSArray *hotArray;                                 //热门词组
@property (nonatomic,strong) NSArray *recommendArray;                           //推荐词组
@property (nonatomic,assign) HMDSearchTVTipsType searchTVTipsType;              //推荐模式
@property (nonatomic,copy) HMDSearchTVTipBlock searchTVTipBlock;                //关键词搜索
@property (nonatomic,copy) void(^scrollViewWillBeginDraggingBlock)(void);       //界面拖动
@property (nonatomic,strong) NSString *curKeyWord;
@end
