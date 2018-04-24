//
//  HMDVideoDataDao.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/18.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseDao.h"
@class HMDVideoModel;
typedef void(^HMDGetRecommendVideoDataFinishBlock)(BOOL success,NSArray *modelArray);               //获取数据
typedef void(^HMDPostPlayNetPosterOrderFinishBlock)(BOOL success);                                  //发送播放命令
@interface HMDVideoDataDao : HMDBaseDao
//获取海报数据
-(void)getRecommendVideoDataFinish:(HMDGetRecommendVideoDataFinishBlock)finish;
//播放对应视频
-(void)PostPlayNetPosterOrder:(HMDVideoModel *)videoModel finishBlock:(HMDPostPlayNetPosterOrderFinishBlock)finish;
@end
