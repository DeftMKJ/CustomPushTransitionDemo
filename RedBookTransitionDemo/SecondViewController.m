//
//  SecondViewController.m
//  RedBookTransitionDemo
//
//  Created by MKJING on 16/11/17.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "SecondViewController.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "MKJPresentAnimator.h"
#import "ThirdViewController.h"

@interface SecondViewController ()  <UIViewControllerTransitioningDelegate>
@property (nonatomic,strong) RedBookDetails *redBookModel;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *headerImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *mainImageView;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,assign) CGRect destinationRec;
@property (nonatomic,strong) UIImageView *dotImageView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *tagLabel;
@property (nonatomic,assign) BOOL isShow;

@end

@implementation SecondViewController

- (void)animationFinish
{
    // 图片往上平铺
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.redBookModel.img]];
    
    // 然后做个简单的小动画显示label
    [self showAnimationTag];
}

- (void)showAnimationTag
{
    self.dotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.mainImageView.bounds.size.width / 3, self.mainImageView.bounds.size.height / 2, 1, 1)];
    self.dotImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.dotImageView.image = [UIImage imageNamed:@"dot1"];
    [self.dotImageView sizeToFit];
    [self.mainImageView addSubview:self.dotImageView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor whiteColor];
    self.lineView.layer.cornerRadius = 1.0f;
    self.lineView.layer.masksToBounds = YES;
    [self.mainImageView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(@(0));
        make.height.mas_equalTo(@(2));
        make.left.equalTo(self.dotImageView.mas_right).with.offset(-1);
        make.centerY.equalTo(self.dotImageView);
    }];
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dotImageView);
    }];
    [self.mainImageView layoutIfNeeded];
    
    [UIView animateWithDuration:0.6 animations:^{
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(100));
        }];
        
        [self.mainImageView layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        self.tagLabel = [[UILabel alloc] init];
        self.tagLabel.text = @"哎呦！！不错喔妹子";
        self.tagLabel.font = [UIFont boldSystemFontOfSize:13];
        self.tagLabel.textColor = [UIColor redColor];
        [self.mainImageView addSubview:self.tagLabel];
        [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.dotImageView).with.offset(-15);
            make.left.equalTo(self.dotImageView.mas_right).with.offset(0);
            
        }];
    }];
}

// 点击图片
- (void)clickImageHiddenTag:(UITapGestureRecognizer *)tap
{
    self.isShow = !self.isShow;
    if (!self.isShow)
    {
        [self showAnimationTag];
    }
    else
    {
        CGAffineTransform form = CGAffineTransformMakeScale(1.5, 1.5);
        [UIView animateWithDuration:0.3 animations:^{
            self.dotImageView.transform = form;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.dotImageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(@(0));
                }];
                [UIView animateWithDuration:0.5 animations:^{
                    [self.mainImageView layoutIfNeeded];
                    self.tagLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    self.dotImageView.hidden  = YES;
                }];
            }];
        }];
    }


}


- (void)refreshData:(RedBookDetails *)details destinationRec:(CGRect)destinationRec
{
    self.destinationRec = destinationRec;
    self.redBookModel = details;
    
}

- (void)configUI
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    self.headerImageView = [[UIImageView alloc] init];
    [self.scrollView addSubview:self.headerImageView];
    self.headerImageView.layer.cornerRadius = 20;
    self.headerImageView.layer.masksToBounds = YES;
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.scrollView.mas_left).with.offset(20);
        make.top.equalTo(self.scrollView.mas_top).with.offset(68);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.textColor = [UIColor redColor];
    [self.scrollView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.headerImageView.mas_right).with.offset(20);
        make.centerY.equalTo(self.headerImageView);
    }];
    
    self.mainImageView = [[UIImageView alloc] init];
    self.mainImageView.frame = self.destinationRec;
    [self.scrollView addSubview:self.mainImageView];
    self.mainImageView.backgroundColor = [UIColor whiteColor];
    self.mainImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageHiddenTag:)];
    [self.mainImageView addGestureRecognizer:tap];
    
    
       
        
        
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.textColor = [UIColor blueColor];
    self.detailLabel.font = [UIFont italicSystemFontOfSize:13];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 50;
    [self.scrollView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.scrollView.mas_left).with.offset(20);
        make.top.equalTo(self.mainImageView.mas_bottom).with.offset(20);
        
    }];
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.redBookModel.icon]];
    self.nameLabel.text = self.redBookModel.name;
    [self.nameLabel sizeToFit];
    self.detailLabel.text = self.redBookModel.des;
    [self.scrollView layoutSubviews];
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(self.detailLabel.frame))];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configUI];
    self.isShow = NO;
    UIButton *button  =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button sizeToFit];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    
    
    UIButton *button1  =[UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 40, 40);
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button1 addTarget:self action:@selector(click1:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitle:@"炸弹" forState:UIControlStateNormal];
    [button1 sizeToFit];
    UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = barButton1;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)click:(UIButton *)button
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}


- (void)click1:(UIButton *)button
{
    ThirdViewController *thirdVC = [[ThirdViewController alloc] init];
    thirdVC.modalPresentationStyle = UIModalPresentationCustom; // 貌似只支持几种模式，自己写还是直接用custom好了
    thirdVC.transitioningDelegate =  self; // 自己成为代理，返回动画
    [self presentViewController:thirdVC animated:YES completion:nil];
}


#pragma - present的时候需要的代理方法
#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [MKJPresentAnimator new];
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [MKJPresentAnimator new];
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
