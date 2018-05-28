//
//  UIImage+HMDImageType.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/23.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSInteger{
    ImageTypeUnknow = 0,
    ImageTypeJPEG,
    ImageTypeJPEG2000,
    ImageTypeTIFF,
    ImageTypeBMP,
    ImageTypeICO,
    ImageTypeICNS,
    ImageTypeGIF,
    ImageTypePNG,
    ImageTypeWebP,
    ImageTypeOther,
}HMDImageType;
@interface UIImage (HMDImageType)
+(HMDImageType)imageDetectType:(NSData *)imageData;
@end
