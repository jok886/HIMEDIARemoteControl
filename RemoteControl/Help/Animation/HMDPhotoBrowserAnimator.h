//
//  HMDPhotoBrowserAnimator.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/23.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol HMDPresentDelegate <NSObject>
-(CGRect)homeRectAtIndexPath:(NSIndexPath *)indexPath;
-(CGRect)photoBrowserRectAtIndexPath:(NSIndexPath *)indexPath;
-(UIImageView *)imageViewAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol HMDDismissDelegate <NSObject>
-(NSIndexPath *)currentIndexPath;
-(UIImageView *)imageView;
@end
@interface HMDPhotoBrowserAnimator : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic,copy) id<HMDPresentDelegate> presentDelegate;
@property (nonatomic,copy) id<HMDDismissDelegate> dismissDelegate;
@property (nonatomic,assign) BOOL isPresent;
@property (nonatomic,strong) NSIndexPath *indexPath;
@end
