//
//  ViewController.m
//  RedBookTransitionDemo
//
//  Created by MKJING on 16/11/15.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "ViewController.h"
#import "MKJParseHelper.h"
#import <CHTCollectionViewWaterfallLayout.h>
#import "FirstCollectionViewCell.h"
#import "RedBookModel.h"
#import <UIImageView+WebCache.h>
#import "SecondViewController.h"
#import "MKJNavigationViewController.h"
#import "MKJExplosionView.h"
#import "FourthViewController.h"
#import "YYFPSLabel.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *lists;
@property (weak, nonatomic) IBOutlet CHTCollectionViewWaterfallLayout *customLayout;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) MKJExplosionView *mkjView; // 下雪的爱心

@end

static NSString *identify1 = @"FirstCollectionViewCell";
static NSString *identify2 = @"SecondCollectionViewCell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.titleView = [[YYFPSLabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 0, 80, 44);

    [self.button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.button setTitle:@"瀑布流" forState:UIControlStateNormal];
    [self.button setTitle:@"列表布局" forState:UIControlStateSelected];
    self.button.enabled = NO;
    self.button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.button];
    self.navigationItem.rightBarButtonItem = item;
    
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button1.frame = CGRectMake(0, 0, 80, 44);
    
    [self.button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.button1 setTitle:@"碎裂效果" forState:UIControlStateNormal];
    self.button1.enabled = NO;
    self.button1.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.button1 addTarget:self action:@selector(clickButton1:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:self.button1];
    self.navigationItem.leftBarButtonItem = item1;
    
    
    
    
    
    
    self.customLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    // sectionHeader高度
    //    self.customLayout.headerHeight = 80;
    // sectionFooterHeight
    //    self.CHTLayout.footerHeight = 10;
    // 间距
    self.customLayout.minimumColumnSpacing = 10;
    self.customLayout.minimumInteritemSpacing = 10;
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:identify1 bundle:nil] forCellWithReuseIdentifier:identify1];
    [self.collectionView registerNib:[UINib nibWithNibName:identify2 bundle:nil] forCellWithReuseIdentifier:identify2];
    
    [self refreshData];
    
    self.mkjView = [[MKJExplosionView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [self.view addSubview:self.mkjView];
    
    
}

- (void)refreshData
{
    __weak typeof(self)weakSelf = self;
    [[MKJParseHelper shareHelper] requestData:^(id obj, NSError *error) {
        
        weakSelf.lists = (NSArray *)obj;
        [weakSelf.collectionView reloadData];
        
        
    } failure:^(id obj, NSError *error) {
        
    }];
}


#pragma mark - collectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.lists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = nil;
    if (!self.button.selected)
    {
        ID = identify1;
    }
    else
    {
        ID = identify2;
    }
    FirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    [self configCell:cell indexpath:indexPath];
    return cell;
}


- (void)configCell:(FirstCollectionViewCell *)cell indexpath:(NSIndexPath *)indexpath
{
    RedBookDetails *bookDetail = self.lists[indexpath.item];
    __weak typeof(cell)weakCell = cell;
    if (!self.button.selected)
    {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:bookDetail.img] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
           
            if (image && cacheType == SDImageCacheTypeNone) {
                weakCell.imageView.alpha = 0;
                [UIView animateWithDuration:2.0 animations:^{
                    
                    weakCell.imageView.alpha = 1.0f;
                    
                }];
            }
            else
            {
                weakCell.imageView.alpha = 1.0f;
            }
        }];
        [cell.imageView layoutIfNeeded];
        if ([bookDetail.h floatValue] > [bookDetail.w floatValue]) {
            CGFloat rate = [bookDetail.h floatValue] / [bookDetail.w floatValue];
            cell.imageViewHeight.constant = (kScreenWidth - 30) / 2 * rate;
        }
        else
        {
            cell.imageViewHeight.constant = (kScreenWidth - 30) / 2;
        }
        
        cell.descLabel.text = bookDetail.des;
        cell.nameLabel.text = bookDetail.name;
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:bookDetail.icon]];
    }
    else
    {
        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:bookDetail.img] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image && cacheType == SDImageCacheTypeNone) {
                weakCell.imageView.alpha = 0;
                [UIView animateWithDuration:2.0 animations:^{
                    
                    weakCell.imageView.alpha = 1.0f;
                    
                }];
            }
            else
            {
                weakCell.imageView.alpha = 1.0f;
            }
        }];
        cell.descLabel2.text = bookDetail.des;
        cell.nameLabel2.text = bookDetail.name;
        [cell.headerImageView2 sd_setImageWithURL:[NSURL URLWithString:bookDetail.icon]];
    }
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RedBookDetails *bookDetail = self.lists[indexPath.item];
    if (!self.button.selected)
    {
        if ([bookDetail.h floatValue] > [bookDetail.w floatValue]) {
            CGFloat rate = [bookDetail.h floatValue] / [bookDetail.w floatValue];
            rate = ((kScreenWidth - 30) / 2 * rate + 120 )  / ((kScreenWidth - 30) / 2);
            return CGSizeMake(1,rate);

        }
        else
        {
            CGFloat rate = ((kScreenWidth - 30) / 2 + 120 )  / ((kScreenWidth - 30) / 2);
            return CGSizeMake(1, rate);
        }
    }
    else
    {
        return CGSizeMake(1, 0.5);
    }
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumColumnSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RedBookDetails *bookDetail = self.lists[indexPath.item];
    CGFloat rate = [bookDetail.h floatValue] / [bookDetail.w floatValue];
    CGRect descRec = CGRectMake(0, 64 + 50, kScreenWidth, kScreenWidth * rate);
    CGRect originalRec;
    UIImageView *imageView = nil;
    FirstCollectionViewCell *firstCell = (FirstCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    if (self.button.selected)
    {
        originalRec = [firstCell.imageView2 convertRect:firstCell.imageView2.frame toView:self.view];
        imageView = firstCell.imageView2;
    }
    else
    {
        originalRec = [firstCell.imageView convertRect:firstCell.imageView.frame toView:self.view];
        imageView = firstCell.imageView;
    }
    
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    [secondVC refreshData:bookDetail destinationRec:descRec];
    MKJNavigationViewController *mkjNvc = (MKJNavigationViewController *)self.navigationController;
    [mkjNvc pushViewController:secondVC imageView:imageView desRec:descRec original:originalRec deleagte:secondVC isRight:YES];
    
    

}





- (void)clickButton:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected)
    {
        self.customLayout.minimumContentHeight = 150;
        // 多少列
        self.customLayout.columnCount = 1;
    }
    else
    {
        self.customLayout.minimumContentHeight = (kScreenWidth - 30) / 2 + 130;
        // 多少列
        self.customLayout.columnCount = 2;
    }
    [self.collectionView reloadData];
    
    
}

- (void)clickButton1:(UIButton *)button
{
    FourthViewController *secondVC = [[FourthViewController alloc] init];
    
    MKJNavigationViewController *mkjNvc = (MKJNavigationViewController *)self.navigationController;
    [mkjNvc pushViewController:secondVC imageView:nil desRec:CGRectZero original:CGRectZero deleagte:nil isRight:NO];
}


- (NSArray *)lists
{
    if (_lists == nil) {
        _lists = [[NSArray alloc] init];
    }
    return _lists;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
