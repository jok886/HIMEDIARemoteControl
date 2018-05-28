//
//  HMDSaveTool.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/23.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMDSaveTool : NSObject
//图片文件夹路径
+(NSString *)getImageFile;
//随机生成文件名,并返回文件路径
+(NSString *)getSaveImageFilePathWithImageData:(NSData *)imageData;
//返回所有的图片
+(NSArray *)getAllImageFile;
@end
