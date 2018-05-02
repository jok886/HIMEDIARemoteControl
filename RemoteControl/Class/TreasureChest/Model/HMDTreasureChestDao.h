//
//  HMDTreasureChestDao.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/12.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDTVBaseFunctionDao.h"

@interface HMDTreasureChestDao : HMDTVBaseFunctionDao
//投屏
+(void)startPlayToTVWithImageData:(NSData *)imageData;
//投屏
+(void)startPlayMediaWithURL:(NSString *)mediaURL;
//投屏
-(void)startPlayMediaWithURL:(NSString *)mediaURL;
//投屏
+(void)startPlayVideoToTVWithURL:(NSString *)videoURL;
@end
