//
//  MKJExplosionView.m
//  点赞按钮的栗子爆炸
//
//  Created by 宓珂璟 on 16/7/7.
//  Copyright © 2016年 UITableView. All rights reserved.
//

#import "MKJExplosionView.h"
#import <QuartzCore/QuartzCore.h>

@interface MKJExplosionView ()

@property (nonatomic,strong) CAEmitterLayer *emitterLayer;

@end

@implementation MKJExplosionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self prepareedAnimation];
}


- (void)prepareedAnimation
{
    self.clipsToBounds = NO; // 让例子能弹出固定的框框，不然只有在框框内而已
    self.userInteractionEnabled = NO; // 取消交互，不然点不到
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.contents = (id)[UIImage imageNamed:@"favorite_hl"].CGImage; // 这里要的是CGImage
    cell.name = @"snow";
    cell.lifetime = 10.0f;
    cell.lifetimeRange = 100.0;
    // 隐掉的时间
    // 初始化右多少个
    cell.birthRate = 10;
    cell.velocity = 10.0f; // 越大越往外 速度越快
    cell.velocityRange = 10.0f; // 越小就越接近圆形，越大越不规则
    cell.emissionRange = M_PI_2; // 发散的范围
    cell.yAcceleration = 2;
    cell.scale = 0.5f; // 栗子倍数
    cell.scaleRange = 0.02;
    
    
    _emitterLayer = [CAEmitterLayer layer];
    _emitterLayer.emitterShape = kCAEmitterLayerLine; // layer的形状
    _emitterLayer.emitterMode = kCAEmitterLayerSurface; // layer的弹出方式
    _emitterLayer.emitterSize = CGSizeMake(self.bounds.size.width * 2, 100);
    _emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
    _emitterLayer.masksToBounds = NO;
    _emitterLayer.emitterCells = @[cell];
    _emitterLayer.frame = [UIScreen mainScreen].bounds;
    _emitterLayer.emitterPosition = CGPointMake(100, -40);
    
    [self.layer addSublayer:_emitterLayer];
    
    
    
    
}


- (void)startAnimated
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.emitterLayer.beginTime = CACurrentMediaTime();
        CABasicAnimation *baseAni = [CABasicAnimation animationWithKeyPath:@"emitterCells.explosion.birthRate"];
        baseAni.fromValue = @(0);
        baseAni.toValue = @(1000);
        [_emitterLayer addAnimation:baseAni forKey:nil];
    });
    
}

@end
