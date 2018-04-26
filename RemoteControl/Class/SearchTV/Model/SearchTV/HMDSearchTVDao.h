//
//  HMDSearchTVDao.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/12.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseDao.h"

typedef void(^HMDSearchTVTipFinishBlock)(BOOL success, NSArray *searchArray);
typedef void(^HMDSearchTVFinishBlock)(BOOL success, NSArray *searchArray);
@interface HMDSearchTVDao : HMDBaseDao
//关键热词
-(void)searchTVHotTipWithFinishBlock:(HMDSearchTVTipFinishBlock)finishBlock;
//按输入返回联动词汇
-(void)searchTVTipWithKeyWord:(NSString *)key FinishBlock:(HMDSearchTVTipFinishBlock)finishBlock;

//按输入返回联动词汇
-(void)searchTVWithKeyWord:(NSString *)key page:(NSInteger)page FinishBlock:(HMDSearchTVFinishBlock)finishBlock;
@end
