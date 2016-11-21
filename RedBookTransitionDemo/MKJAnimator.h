//
//  MKJAnimator.h
//  RedBookTransitionDemo
//
//  Created by MKJING on 16/11/17.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MKJAnimatorDelegate <NSObject>

- (void)animationFinish;

@end

@interface MKJAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,assign) CGRect destinationRec;
@property (nonatomic,assign) CGRect originalRec;
@property (nonatomic,assign) BOOL isPush;
@property (nonatomic,assign) id<MKJAnimatorDelegate>delegate;

@end
