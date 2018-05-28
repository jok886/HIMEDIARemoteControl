//
//  HMDSaveTool.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/23.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDSaveTool.h"

#import "UIImage+HMDImageType.h"
@implementation HMDSaveTool
+(NSString *)getImageFile{
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"/HMDDocument/image"];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"FileDir is exists.");
    }
    
    return filePath;
}

+(NSArray *)getAllImageFile{
    NSMutableArray *filePathArray = [NSMutableArray array];
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSString *filePath = [HMDSaveTool getImageFile];
    // 文件属性
    NSDictionary *attrs = [mgr attributesOfItemAtPath:filePath error:nil];
    if ([attrs.fileType isEqualToString:NSFileTypeDirectory]) { // 如果是文件夹
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:filePath];
        for (NSString *subpath in enumerator) {
            // 全路径
            NSString *fullSubpath = [filePath stringByAppendingPathComponent:subpath];
            [filePathArray addObject:fullSubpath];
        }
    }
    return filePathArray;
}

+(NSString *)getSaveImageFilePathWithImageData:(NSData *)imageData{
    HMDImageType type = [UIImage imageDetectType:imageData];
//    ImageTypeUnknow = 0,
//    ImageTypeJPEG,
//    ImageTypeJPEG2000,
//    ImageTypeTIFF,
//    ImageTypeBMP,
//    ImageTypeICO,
//    ImageTypeICNS,
//    ImageTypeGIF,
//    ImageTypePNG,
//    ImageTypeWebP,
//    ImageTypeOther,
    NSString *imageName ;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyyMMddhhmmssSSSS"];
    NSString *curTime = [formatter stringFromDate:[NSDate date]];
    switch (type) {
        case ImageTypeJPEG:
        case ImageTypeJPEG2000:
            imageName = [curTime stringByAppendingString:@".jpg"];
            break;
        case ImageTypePNG:
            imageName = [curTime stringByAppendingString:@".png"];
            break;
        default:
            break;
    }
    NSString *filePath = [HMDSaveTool getImageFile];
    filePath = [filePath stringByAppendingPathComponent:imageName];
    return filePath;
}
@end
