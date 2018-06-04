//
//  HMDPhotoBrowserCollectionViewCell.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/6/1.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDPhotoBrowserCollectionViewCell.h"
@interface HMDPhotoBrowserCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (nonatomic,assign) CGFloat maxScale;                                  //最大倍数
//@property (nonatomic,assign) CGFloat minScale;                                  //最小倍数
@property (nonatomic,assign) CGFloat ordinaryH;                                 //图片正常高
@property (nonatomic,assign) CGFloat ordinaryW;                                 //图片正常宽
@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic) CGAffineTransform imageViewTransform;                      //当前的imageViewTransform
@property (nonatomic,strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
@end
@implementation HMDPhotoBrowserCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addGestureRecognizer];
}

-(void)setCellWithImage:(UIImage *)image{
    self.photoImageView.image = image;
    self.photoImageView.transform = CGAffineTransformIdentity;
    self.ordinaryW = self.frame.size.width;
    self.panGestureRecognizer.enabled = NO;
}

//缩放手势
-(void)addGestureRecognizer{
    self.maxScale = 3.0;
//    self.minScale = 0.5;
    
    //增加平移手势和捏合手势
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewPanGestureRecognizer:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewPinchGestureRecognizer:)];
    [self addGestureRecognizer:self.pinchGestureRecognizer];
}

-(void)imageViewPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    CGPoint translation = [panGestureRecognizer translationInView:self];
    CGRect imageViewFrame = self.photoImageView.frame;
    imageViewFrame.origin.x +=translation.x;
    imageViewFrame.origin.y +=translation.y;
    self.photoImageView.frame = imageViewFrame;

    [panGestureRecognizer setTranslation:CGPointZero inView:self];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        [self fixImageViewTranslation];
    }
}

-(void)imageViewPinchGestureRecognizer:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
    CGFloat scale = pinchGestureRecognizer.scale;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.imageViewTransform = self.photoImageView.transform;

    }
    
    CGAffineTransform imageViewTransform = CGAffineTransformScale(self.imageViewTransform,scale,scale);
    
    [self.photoImageView setTransform:imageViewTransform];
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat videoWidth = CGRectGetWidth(self.photoImageView.frame);
        self.panGestureRecognizer.enabled = YES;
        if (videoWidth< self.ordinaryW) {
            [self.photoImageView setTransform:CGAffineTransformIdentity];
            self.panGestureRecognizer.enabled = NO;
        }
        if (videoWidth > self.ordinaryW * self.maxScale) {
            CGAffineTransform imageViewTransform = CGAffineTransformScale(CGAffineTransformIdentity,self.maxScale,self.maxScale);
            [self.photoImageView setTransform:imageViewTransform];
        }
        [self fixImageViewTranslation];
    }
}

-(void)fixImageViewTranslation{
    CGRect imageViewFrame = self.photoImageView.frame;
    CGPoint fixPoint = CGPointZero;
    if (imageViewFrame.origin.x > CGRectGetMinX(self.bounds)) {
        fixPoint.x = CGRectGetMinX(self.bounds) - imageViewFrame.origin.x;
    }

    if (CGRectGetMaxX(imageViewFrame)<CGRectGetMaxX(self.bounds)) {
        fixPoint.x = CGRectGetMaxX(self.bounds) - CGRectGetMaxX(imageViewFrame);
    }
    if (imageViewFrame.size.height <= CGRectGetHeight(self.bounds)) {
        CGPoint center = self.photoImageView.center;
        center.y = CGRectGetHeight(self.bounds) *0.5;
        fixPoint.y = center.y-imageViewFrame.origin.y-0.5*imageViewFrame.size.height;

    }else{
        if (imageViewFrame.origin.y > CGRectGetMinY(self.bounds)) {
            fixPoint.y = CGRectGetMinY(self.bounds)-imageViewFrame.origin.y;
        }
        if (CGRectGetMaxY(imageViewFrame)<CGRectGetMaxY(self.bounds)) {
            fixPoint.y = CGRectGetMaxY(self.bounds) - CGRectGetMaxY(imageViewFrame);
        }
    }

    imageViewFrame.origin.x += fixPoint.x;
    imageViewFrame.origin.y += fixPoint.y;
//    NSLog(@"fixPoint.y%f_____imageViewFrame.origin.y%f",fixPoint.y,imageViewFrame.origin.y);
    [UIView animateWithDuration:0.5 animations:^{
        self.photoImageView.frame = imageViewFrame;
    }];
    
}
@end
