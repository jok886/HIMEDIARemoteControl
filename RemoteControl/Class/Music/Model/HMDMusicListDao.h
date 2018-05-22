//
//  HMDMusicListDao.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/22.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseDao.h"

@interface HMDMusicListDao : HMDBaseDao
//音乐列表
-(void)getAllMusicListFinishBlock:(void(^)(BOOL success, NSArray *musicArray))finishBlock;
//播放音乐
-(void)playMusicWithFilePath:(NSString *)filePath finishBlock:(void(^)(BOOL success))finishBlock;
@end
