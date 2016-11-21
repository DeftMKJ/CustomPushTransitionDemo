//
//  ThirdViewController.m
//  RedBookTransitionDemo
//
//  Created by 宓珂璟 on 2016/11/20.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *texField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TFHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TFWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@end

@implementation ThirdViewController
- (IBAction)close:(id)sender {
    self.TFWidthConstraint.constant = 0;
    self.labelWidthConstraint.constant = 0;
    
    CGAffineTransform form = CGAffineTransformMakeRotation(M_PI);
    
    form = CGAffineTransformScale(form, 0.1, 0.1);
    [UIView animateWithDuration:0.8 animations:^{
        self.closeButton.transform = form;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.closeButton.alpha = 0;
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDimming:)];
    
    
}

- (void)clickDimming:(UITapGestureRecognizer *)tap
{
    [self close:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    for (UIView *dimmingView in self.view.superview.subviews) {
        if (![dimmingView isEqual:self.view])
        {
            [dimmingView addGestureRecognizer:self.tap];
        }
        
    }
    self.TFWidthConstraint.constant = self.view.bounds.size.width * 2 /3;
    self.labelWidthConstraint.constant = self.view.bounds.size.width * 2 / 3;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.closeButton.alpha = 1.0f;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
