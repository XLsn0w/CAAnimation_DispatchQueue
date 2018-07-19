//
//  EmitterLayerTestVC.m
//  AnimationTest
//
//  Created by zhengqian.shi on 17/2/14.
//  Copyright © 2017年 QITMAC000263. All rights reserved.
//

#import "EmitterLayerTestVC.h"

@interface EmitterLayerTestVC ()

@property(nonatomic,strong) CAEmitterLayer  *testLayer;

@end

@implementation EmitterLayerTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self initEmitter];
    
    [self makeSnow];
}

- (void)makeSnow
{
    CAEmitterCell *snowCell = [CAEmitterCell emitterCell];
    snowCell.contents = (__bridge id _Nullable)([UIImage imageNamed:@"snow.png"].CGImage);
    snowCell.birthRate = 5;
    snowCell.lifetime = 20;
    snowCell.velocity = 100;
    snowCell.velocityRange = 50;
    snowCell.emissionLongitude = M_PI_2;
    snowCell.emissionRange = M_PI_2;
    snowCell.scaleRange = 0.5;
    
    _testLayer.emitterCells = @[snowCell];
}

- (void)initEmitter
{
    _testLayer = [CAEmitterLayer layer];
    _testLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _testLayer.renderMode = kCAEmitterLayerAdditive;
    _testLayer.emitterPosition = CGPointMake(self.view.frame.size.width/2, -35);
    _testLayer.emitterSize = CGSizeMake(self.view.frame.size.width, 20);
    [self.view.layer addSublayer:_testLayer];
}

@end
