//
//  HMDImageCropperViewController.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/21.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseViewController.h"

@class HMDImageCropperViewController;

@protocol HMDImageCropperDelegate <NSObject>

- (void)imageCropper:(HMDImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(HMDImageCropperViewController *)cropperViewController;

@end

@interface HMDImageCropperViewController : HMDBaseViewController
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<HMDImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;
@end
