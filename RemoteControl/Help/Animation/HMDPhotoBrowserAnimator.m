//
//  HMDPhotoBrowserAnimator.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/23.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDPhotoBrowserAnimator.h"

@implementation HMDPhotoBrowserAnimator

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.isPresent = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.isPresent = NO;
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 2.0;
}
//动画
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    if (self.isPresent) {
        [self showAnimateForPresentView:transitionContext];
    }else{
        [self showAnimateForDismissView:transitionContext];
    }
}

//显示的动画
-(void)showAnimateForPresentView:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *presentView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [transitionContext.containerView addSubview:presentView];
    if (self.presentDelegate == nil) {
        return;
    }
    if (![self.presentDelegate respondsToSelector:@selector(imageViewAtIndexPath:)]) {
        return;
    }
    UIImageView *imageView = [self.presentDelegate imageViewAtIndexPath:self.indexPath];
    [transitionContext.containerView addSubview:imageView];
    if (![self.presentDelegate respondsToSelector:@selector(homeRectAtIndexPath:)]) {
        return;
    }
    CGRect rect = [self.presentDelegate homeRectAtIndexPath:self.indexPath];
    imageView.frame = rect;
    presentView.alpha = 0;
    transitionContext.containerView.backgroundColor = [UIColor blackColor];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        imageView.frame = [self.presentDelegate photoBrowserRectAtIndexPath:self.indexPath];
    } completion:^(BOOL finished) {
        presentView.alpha = 1;
        transitionContext.containerView.backgroundColor = [UIColor clearColor];
        [transitionContext completeTransition:YES];
    }];
    
}
//消失的动画
-(void)showAnimateForDismissView:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *dissmissView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [dissmissView removeFromSuperview];
    if (self.presentDelegate && self.presentDelegate) {
        UIImageView *imageView = [self.dismissDelegate imageView];
        [transitionContext.containerView addSubview:imageView];
        NSIndexPath *indexPath = [self.dismissDelegate currentIndexPath];
        imageView.frame = [self.presentDelegate photoBrowserRectAtIndexPath:indexPath];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            imageView.frame = [self.presentDelegate homeRectAtIndexPath:indexPath];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}
@end
