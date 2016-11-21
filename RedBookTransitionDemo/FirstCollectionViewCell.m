//
//  FirstCollectionViewCell.m
//  RedBookTransitionDemo
//
//  Created by MKJING on 16/11/15.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "FirstCollectionViewCell.h"

@implementation FirstCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headerImageView.layer.cornerRadius = 20.f;
    self.headerImageView.clipsToBounds = YES;
    
}

@end
