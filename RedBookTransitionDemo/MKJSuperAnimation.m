//
//  MKJSuperAnimation.m
//  RedBookTransitionDemo
//
//  Created by 宓珂璟 on 2016/11/20.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "MKJSuperAnimation.h"

@implementation MKJSuperAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 3.0f;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 获取两个VC和对应的View
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    
    UIView *toView = toVC.view;
    UIView *fromeView = fromVC.view;
    
    // push是要判断的，present是有属性跟踪的
    BOOL isPush = ([toVC.navigationController.viewControllers indexOfObject:toVC] > [toVC.navigationController.viewControllers indexOfObject:fromVC]);
    
    [containerView addSubview:toView];
    
    
    
    UIImage *fromSnapshotImage;
    __block UIImage *toSnapShotImage;
    // 截屏
    UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, YES, containerView.window.screen.scale);
    // 这句话太关键了，不然就无法截屏黑了
    [fromeView drawViewHierarchyInRect:containerView.bounds afterScreenUpdates:NO];
    fromSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, YES, containerView.window.screen.scale);
        [toView drawViewHierarchyInRect:containerView.bounds afterScreenUpdates:NO];
        toSnapShotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    
    
    // 加一层动画的View，这里会有layer一个个铺在上面，是原始切割数量的两倍，正面是from，背面是to，事先摆好位置
    UIView *transitionContainerView = [[UIView alloc] initWithFrame:containerView.bounds];
    
    transitionContainerView.backgroundColor = [UIColor blackColor];
    [containerView addSubview:transitionContainerView];
    
    CATransform3D t = CATransform3DIdentity;
    
    t.m34 = 1/ -999;
    transitionContainerView.layer.transform = t;
    
    CGFloat sliceSize = round(CGRectGetWidth(containerView.bounds) / 8.f);
    NSUInteger xSlices = ceil(CGRectGetWidth(containerView.bounds) / sliceSize);
    NSUInteger ySlices = ceil(CGRectGetHeight(containerView.bounds) / sliceSize);
    
    const CGFloat transitionSpacing = 160.f;
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    CGVector transitionVector;
    if (isPush) {
        transitionVector = CGVectorMake(CGRectGetMaxX(transitionContainerView.bounds) - CGRectGetMinX(transitionContainerView.bounds),
                                        CGRectGetMaxY(transitionContainerView.bounds) - CGRectGetMinY(transitionContainerView.bounds));
    } else {
        transitionVector = CGVectorMake(CGRectGetMinX(transitionContainerView.bounds) - CGRectGetMaxX(transitionContainerView.bounds),
                                        CGRectGetMinY(transitionContainerView.bounds) - CGRectGetMaxY(transitionContainerView.bounds));
    }
    
    // sqrt对应的是平方根 f代表float类型  求得对角线长度765
    CGFloat transitionVectorLength = sqrtf( transitionVector.dx * transitionVector.dx + transitionVector.dy * transitionVector.dy );
    // 单位速度 dx/对角线   0.49   0.87
    CGVector transitionUnitVector = CGVectorMake(transitionVector.dx / transitionVectorLength, transitionVector.dy / transitionVectorLength);
                           
    
    // 防止layer，layer是加到小格子View上面的，但是layer是全屏的，所以每个小格子要对应上必须进行负数偏移，不然图像都不完整了
    for (NSUInteger y = 0 ; y < ySlices; y++)
    {
        for (NSUInteger x = 0; x < xSlices; x++)
        {
            CALayer *fromContentLayer = [CALayer new];
            fromContentLayer.frame = CGRectMake(x * sliceSize * -1.f, y * sliceSize * -1.f, containerView.bounds.size.width, containerView.bounds.size.height);
            fromContentLayer.rasterizationScale = fromSnapshotImage.scale;
            fromContentLayer.contents = (__bridge id)fromSnapshotImage.CGImage;
            
            CALayer *toContentLayer = [CALayer new];
            toContentLayer.frame = CGRectMake(x * sliceSize * -1.f, y * sliceSize * -1.f, containerView.bounds.size.width, containerView.bounds.size.height);
            
            // 由于toView的截屏是延迟的，所有这里的layer图像也要延迟
            dispatch_async(dispatch_get_main_queue(), ^{
                // Disable actions so the contents are applied without animation.
                BOOL wereActiondDisabled = [CATransaction disableActions];
                [CATransaction setDisableActions:YES]; // YES禁用
                
                toContentLayer.rasterizationScale = toSnapShotImage.scale;
                toContentLayer.contents = (__bridge id)toSnapShotImage.CGImage;
                
                [CATransaction setDisableActions:wereActiondDisabled];
            });
            
            UIView *toCheckboardSquareView = [UIView new];
            toCheckboardSquareView.frame = CGRectMake(x * sliceSize, y * sliceSize, sliceSize, sliceSize);
            toCheckboardSquareView.opaque = NO;
            toCheckboardSquareView.layer.masksToBounds = YES;
            toCheckboardSquareView.layer.doubleSided = NO;
            toCheckboardSquareView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
            [toCheckboardSquareView.layer addSublayer:toContentLayer];
            
            UIView *fromCheckboardSquareView = [UIView new];
            fromCheckboardSquareView.frame = CGRectMake(x * sliceSize, y * sliceSize, sliceSize, sliceSize);
            fromCheckboardSquareView.opaque = NO;
            fromCheckboardSquareView.layer.masksToBounds = YES;
            fromCheckboardSquareView.layer.doubleSided = NO;
            fromCheckboardSquareView.layer.transform = CATransform3DIdentity;
            [fromCheckboardSquareView.layer addSublayer:fromContentLayer];
            
            [transitionContainerView addSubview:toCheckboardSquareView];
            [transitionContainerView addSubview:fromCheckboardSquareView];
        }
    }
    
    // 上面是to和from的View交错放置，所以这个时候需要*2来拿出各自的View
    __block NSUInteger sliceAnimationsPending = 0;
    
    for (NSUInteger y = 0 ; y < ySlices; y++)
    {
        for (NSUInteger x = 0; x < xSlices; x++)
        {
            UIView *toCheckboardSquareView = transitionContainerView.subviews[y * xSlices * 2 + (x * 2)];
            UIView *fromCheckboardSquareView = transitionContainerView.subviews[y * xSlices * 2 + (x * 2 + 1)];
            
            CGVector sliceOriginVector;
            if (isPush) {
                // 最上角开始
                sliceOriginVector = CGVectorMake(CGRectGetMinX(fromCheckboardSquareView.frame) - CGRectGetMinX(transitionContainerView.bounds),
                                                 CGRectGetMinY(fromCheckboardSquareView.frame) - CGRectGetMinY(transitionContainerView.bounds));
            } else {
                // 右下角开始
                sliceOriginVector = CGVectorMake(CGRectGetMaxX(fromCheckboardSquareView.frame) - CGRectGetMaxX(transitionContainerView.bounds),
                                                 CGRectGetMaxY(fromCheckboardSquareView.frame) - CGRectGetMaxY(transitionContainerView.bounds));
            }
            
            
            // 算出对角线上的平方
            CGFloat dot = sliceOriginVector.dx * transitionVector.dx + sliceOriginVector.dy * transitionVector.dy;
            // 算出对角线的比例 宽度/对角线  小宽度/对角线的比例
            CGVector projection = CGVectorMake(transitionUnitVector.dx * dot/transitionVectorLength,
                                               transitionUnitVector.dy * dot/transitionVectorLength);
            
            // 算出对角线
            CGFloat projectionLength = sqrtf( projection.dx * projection.dx + projection.dy * projection.dy );
            
            // 通过上面定的时间计算持续时间以及延迟时间
            NSTimeInterval startTime = projectionLength/(transitionVectorLength + transitionSpacing) * transitionDuration;
            NSTimeInterval duration = ( (projectionLength + transitionSpacing)/(transitionVectorLength + transitionSpacing) * transitionDuration ) - startTime;
            
            sliceAnimationsPending++;
            
            [UIView animateWithDuration:duration delay:startTime options:0 animations:^{
                // toView开始复原，不然都是黑乎乎的一片了之前摆放的位置就是背对着的
                toCheckboardSquareView.layer.transform = CATransform3DIdentity;
                // from就开始旋转
                fromCheckboardSquareView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
            } completion:^(BOOL finished) {
                // Finish the transition once the final animation completes.
                if (--sliceAnimationsPending == 0) {
                    BOOL wasCancelled = [transitionContext transitionWasCancelled];
                    
                    [transitionContainerView removeFromSuperview];
                    
                    // When we complete, tell the transition context
                    // passing along the BOOL that indicates whether the transition
                    // finished or not.
                    [transitionContext completeTransition:!wasCancelled];
                }
            }];
        }
    }

    
    
}


@end
