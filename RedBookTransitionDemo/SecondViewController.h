//
//  SecondViewController.h
//  RedBookTransitionDemo
//
//  Created by MKJING on 16/11/17.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedBookModel.h"
#import "MKJAnimator.h"
@interface SecondViewController : UIViewController <MKJAnimatorDelegate>

- (void)refreshData:(RedBookDetails *)details destinationRec:(CGRect)destinationRec;

@end
