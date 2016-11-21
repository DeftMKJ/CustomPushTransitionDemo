//
//  MKJPresentAnimator.m
//  RedBookTransitionDemo
//
//  Created by 宓珂璟 on 2016/11/20.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "MKJPresentAnimator.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface MKJPresentAnimator ()

@end

@implementation MKJPresentAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.45f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 这个是present的动画
    UIView *containerView = transitionContext.containerView;
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    UIView *fromView = fromViewController.view;
    // 这里present不和push一样需要自己标记，这里直接有跟踪标记
    if (toViewController.beingPresented)
    {
        // toView加进来，设置居中的小框
        
        [containerView addSubview:toView];
        toView.bounds = CGRectMake(0, 0, 1, kScreenHeight *2/3);
        toView.center = containerView.center;
        // 然后再加个蒙层 大小也是很小
        UIView *dimmingView = [[UIView alloc] init];
        dimmingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        dimmingView.center = containerView.center;
        dimmingView.bounds = CGRectMake(0, 0, kScreenWidth * 3 / 5, kScreenHeight * 3 / 5);
        [containerView insertSubview:dimmingView belowSubview:toView];
        // 动画toView开始变宽  蒙层开始变大
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
           
            toView.bounds = CGRectMake(0, 0, kScreenWidth * 3 / 5, kScreenHeight *1/2);
            dimmingView.bounds = containerView.bounds;
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    }
    else
    {
        // 返回的时候直接放fromView动画缩小就行了，提交之后自动消失了
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            fromView.bounds = CGRectMake(0, 0, 1, kScreenHeight * 1 / 2);
            
        } completion:^(BOOL finished) {
           
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    
}


@end
