//
//  HMDVideoDataDao.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/18.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseDao.h"
@class HMDVideoModel;
@class HMDVideoHistoryModel;
@class HMDFavoriteVideoModel;
typedef void(^HMDGetRecommendVideoDataFinishBlock)(BOOL success,NSArray *modelArray);               //获取数据
typedef void(^HMDPostPlayNetPosterOrderFinishBlock)(BOOL success);                                  //发送播放命令
typedef void(^HMDGetPlayHistoryFinishBlock)(BOOL success,NSArray *modelArray);                      //获取播放记录
typedef void(^HMDPosterCategoryFinishBlock)(BOOL success,NSDictionary *classifyDict);               //获取分类

@interface HMDVideoDataDao : HMDBaseDao
//获取海报数据
-(void)getRecommendVideoDataFinish:(HMDGetRecommendVideoDataFinishBlock)finish;
//播放对应网络视频
-(void)PostPlayNetPosterOrder:(HMDVideoModel *)videoModel finishBlock:(HMDPostPlayNetPosterOrderFinishBlock)finish;
//获取播放记录
-(void)getPlayHistoryFinishBlock:(HMDGetPlayHistoryFinishBlock) finishBlock;
//播放播放记录
-(void)playHistoryWithHistoryModel:(HMDVideoHistoryModel *)videoHistoryModel FinishBlock:(HMDPostPlayNetPosterOrderFinishBlock)finishBlock;
//获取分类
-(void)getPosterCategoryFinishBlock:(HMDPosterCategoryFinishBlock)finishBlock;
//获取播放列表
-(void)getPostListWithParameters:(NSDictionary *)parameters finishBlock:(void(^)(BOOL success,NSArray *posterList))finishBlock;
//获取收藏列表
-(void)getCollectRecordFinishBlock:(void(^)(BOOL success,NSArray *favoriteList))finishBlock;
//播放收藏
-(void)playCollectWithCollectModel:(HMDFavoriteVideoModel *)videoHistoryModel FinishBlock:(HMDPostPlayNetPosterOrderFinishBlock)finishBlock;
//播放对应本地视频
-(void)PostPlayDLanPosterOrder:(HMDVideoModel *)videoModel finishBlock:(HMDPostPlayNetPosterOrderFinishBlock)finish;
@end
