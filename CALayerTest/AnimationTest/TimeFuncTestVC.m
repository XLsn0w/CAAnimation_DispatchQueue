//
//  TimeFuncTestVC.m
//  AnimationTest
//
//  Created by zhengqian.shi on 17/2/13.
//  Copyright © 2017年 QITMAC000263. All rights reserved.
//

#import "TimeFuncTestVC.h"

@interface TimeFuncTestVC ()
{
    NSTimeInterval _beginTime;
}

@property(nonatomic,strong) UIView  *testView;
@property(nonatomic,strong) UILabel *speed;
@property(nonatomic,strong) CADisplayLink *displk;

@end

@implementation TimeFuncTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_displk invalidate];
    _displk = nil;
    
    [super viewWillAppear:animated];
}

- (void)initSubViews
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4-60, 100, 120, 30)];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn setTitle:@"匀  速" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4*3-60, 100, 120, 30)];
    [btn2 setBackgroundColor:[UIColor grayColor]];
    [btn2 setTitle:@"匀加速" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    _speed = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 200, 70, 180, 30)];
    _speed.textAlignment = NSTextAlignmentRight;
    _speed.text = @"实时速度：0";
    [self.view addSubview:_speed];
    
    _testView = [[UIView alloc] init];
    _testView.center = CGPointMake(self.view.frame.size.width/2, 180);
    _testView.bounds = CGRectMake(0, 0, 50, 50);
    _testView.backgroundColor = [UIColor redColor];
    _testView.layer.cornerRadius = 25;
    [self.view addSubview:_testView];
}

// 匀速
- (void)btnClick:(id)sender
{
    [_displk invalidate];
    _displk = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplay1:)];
    [_displk addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    _beginTime = CACurrentMediaTime();
    
}

// 匀加速
- (void)btn2Click:(id)sender
{
    [_displk invalidate];
    _displk = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplay2:)];
    [_displk addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    _beginTime = CACurrentMediaTime();
}

- (void)onDisplay1:(CADisplayLink *)displk
{
    NSTimeInterval duration = 2;
    CGFloat fromY = 180;
    CGFloat toY = self.view.frame.size.height - 25;
    
    NSTimeInterval showedTime = CACurrentMediaTime() - _beginTime;
    
    CGFloat percent = showedTime/duration;
    
    if (percent > 1)
    {
        percent = 1;
        [displk invalidate];
    }
    
    CGFloat nowX = _testView.center.x;
    CGFloat nowY = fromY + percent*(toY - fromY);
    
    _speed.text = [NSString stringWithFormat:@"实时速度：%.1f",(toY - fromY)/duration];
    if (1 - percent <CGFLOAT_MIN)
    {
        _speed.text = [NSString stringWithFormat:@"实时速度：0"];
    }
    _testView.center = CGPointMake(nowX, nowY);
}

- (void)onDisplay2:(CADisplayLink *)displk
{
    NSTimeInterval duration = 2;
    CGFloat fromY = 180;
    CGFloat toY = self.view.frame.size.height - 25;
    
    NSTimeInterval showedTime = CACurrentMediaTime() - _beginTime;
    
    // 匀加速，实时动画进度比例ps为实时时间比例的二次函数
    CGFloat percent = (showedTime/duration)*(showedTime/duration);
    
    if (percent > 1)
    {
        percent = 1;
        [displk invalidate];
    }
    
    CGFloat nowX = _testView.center.x;
    CGFloat nowY = fromY + percent*(toY - fromY);
    
    NSInteger timeScale = showedTime/duration * 60;
    if (timeScale%4 == 0)
    {
        _speed.text = [NSString stringWithFormat:@"实时速度：%.1f",2*(toY - fromY)*percent/duration];
    }
    if (1 - percent <CGFLOAT_MIN)
    {
        _speed.text = [NSString stringWithFormat:@"实时速度：0"];
    }
    _testView.center = CGPointMake(nowX, nowY);
}

@end
