//
//  MKJNavigationViewController.h
//  RedBookTransitionDemo
//
//  Created by MKJING on 16/11/17.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKJAnimator.h"
@interface MKJNavigationViewController : UINavigationController

- (void)pushViewController:(UIViewController *)viewController imageView:(UIImageView *)imageView desRec:(CGRect)desRec original:(CGRect)originalRec deleagte:(id<MKJAnimatorDelegate>)delegate isRight:(BOOL)isRight;

@end
