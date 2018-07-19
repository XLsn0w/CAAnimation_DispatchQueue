//
//  ViewController.m
//  AnimationTest
//
//  Created by zhengqian.shi on 17/1/14.
//  Copyright © 2017年 QITMAC000263. All rights reserved.
//

#import "ViewController.h"
#import "MoveLogoImg.h"
#import "SimpleAnimeVC.h"
#import "UIViewAnimationTestVC.h"
#import "PMLayerTestVC.h"
#import "CAPauseTestVC.h"
#import "TimeFuncTestVC.h"
#import "MaskLayerTestVC.h"
#import "EmitterLayerTestVC.h"

@interface ViewController ()
{
    NSArray<NSString *> *_tests;
}

@property(nonatomic,strong) CAEmitterLayer  *testLayer;
@property(nonatomic,strong) UIImageView     *backImg;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"CoreAnimationTest";
    
    [self initTests];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.rowHeight = 50;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self makeBlurBack];
    
    [self initEmitter];
    
    [self makeSnow];
    
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tests.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row >= 0 && indexPath.row < _tests.count)
    {
        cell.textLabel.text = _tests[indexPath.row];
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc;
    
    if (indexPath.row == 0)
    {
        vc = [[SimpleAnimeVC alloc] init];
    }
    else if (indexPath.row == 1)
    {
        vc = [[UIViewAnimationTestVC alloc] init];
    }
    else if (indexPath.row == 2)
    {
        vc = [[CAPauseTestVC alloc] init];
    }
    else if (indexPath.row == 3)
    {
        vc = [[PMLayerTestVC alloc] init];
    }
    else if (indexPath.row == 4)
    {
        vc = [[TimeFuncTestVC alloc] init];
    }
    else if (indexPath.row == 5)
    {
        vc = [[MaskLayerTestVC alloc] init];
    }
    else if (indexPath.row == 6)
    {
        vc = [[EmitterLayerTestVC alloc] init];
    }
    
    if (vc)
    {
        vc.title = _tests[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)initTests
{
    _tests = @[@"简单动画",@"UIView动画",@"动画的暂停和继续",@"modelLayer与presentationLayer",@"模拟时间函数插值",@"蒙版实现刮刮卡效果",@"粒子效果"];
}

- (void)makeBlurBack
{
    _backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg1"]];
    
    self.view.backgroundColor = [UIColor cyanColor];
    self.tableView.backgroundView = _backImg;
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    blurView.alpha = 0.93;
    blurView.frame = self.tableView.frame;
    [_backImg addSubview:blurView];
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
