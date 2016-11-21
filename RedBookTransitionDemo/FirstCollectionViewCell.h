//
//  FirstCollectionViewCell.h
//  RedBookTransitionDemo
//
//  Created by MKJING on 16/11/15.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstCollectionViewCell : UICollectionViewCell

// first
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


// second
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView2;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel2;
@property (weak, nonatomic) IBOutlet UILabel *descLabel2;



@end
