//
//  HMDUpUserInfoDao.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/21.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseDao.h"

@interface HMDUpUserInfoDao : HMDBaseDao
//修改昵称updateNickname
-(void)updateNicknameWithPhone:(NSString *)phoneNum nickName:(NSString *)nickName finishBlock:(void(^)(NSInteger status))finishBlock;
//修改昵称updateNickname
-(void)uploadAvatarWithPhone:(NSString *)phoneNum imageData:(NSData *)imageData finishBlock:(void(^)(BOOL success,NSString *imageURL))finishBlock;
@end
