//
//  MKJAnimator.m
//  RedBookTransitionDemo
//
//  Created by MKJING on 16/11/17.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "MKJAnimator.h"
#import "MKJExplosionView.h"

#define PLAN 0

@implementation MKJAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
#if PLAN
    // 这是种最普通的动画，就是缩小而已
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    
    [UIView animateWithDuration:1 animations:^{
        fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if (self.delegate) {
            [self.delegate animationFinish];
        }
    }];

#else
    // 这个是小红书的动画  通过imageView实现rec的变化，然后消失，代理调用，再把image补上，动画就是衔接得这么不自然......
    UIView* contentView = [transitionContext containerView];
    contentView.backgroundColor = [UIColor whiteColor];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [contentView addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    
    __block UIImageView *imageView = [[UIImageView alloc] initWithImage:self.imageView.image];
    imageView.frame = self.isPush ? self.originalRec : self.destinationRec;
    [contentView addSubview:imageView];
    
    if (!self.isPush) {
        self.imageView.alpha = 0;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
       
        imageView.frame = self.isPush ? self.destinationRec : self.originalRec;
        toViewController.view.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        [imageView removeFromSuperview];
        if (!self.isPush) {
            self.imageView.alpha = 1;
        }
        else
        {
            if (self.delegate) {
                [self.delegate animationFinish];
            }
        }
        imageView = nil;
    }];
#endif
}

@end
