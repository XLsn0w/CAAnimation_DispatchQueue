//
//  ViewController.m
//  AnimationTest
//
//  Created by zhengqian.shi on 17/1/14.
//  Copyright © 2017年 QITMAC000263. All rights reserved.
//

#import "SimpleAnimeVC.h"
#import "MoveLogoImg.h"  

@interface SimpleAnimeVC ()
{
    dispatch_queue_t    dispatchQueue;
    UInt64 _recordTime;
}
@property(nonatomic,strong) MoveLogoImg *img;
@property(nonatomic,strong) CALayer     *testLayer;
@property(nonatomic,strong) UITextField *fromValueTf;
@property(nonatomic,strong) UITextField *toValueTf;
@property(nonatomic,strong) UITextField *byValueTf;

@end

@implementation SimpleAnimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubviews];
    
    [self initLayer];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    dispatchQueue = dispatch_queue_create("saqueue", NULL);

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    UITouch *touch = [touches anyObject];
//    CALayer *layer = self.view.layer.sublayers[1];
//    CGFloat width = layer.bounds.size.width;
//    width = width<200 ? 200 : 100;
//    layer.bounds = CGRectMake(0, 0, width, width);
//    layer.position = [touch locationInView:self.view];
}

- (void)initSubviews
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4-60, 100, 120, 30)];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn setTitle:@"基础动画" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4*3-60, 100, 120, 30)];
    [btn2 setBackgroundColor:[UIColor grayColor]];
    [btn2 setTitle:@"关键帧动画" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 10, self.view.frame.size.width, 5)];
    [blackView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:blackView];
}

// 基础动画
- (void)btnClick:(id)sender
{
    _testLayer.position = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 35);
    
    CABasicAnimation *basicAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    
    basicAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, 180)];
    basicAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 35)];
    basicAnim.duration = 1.2;

//    basicAnim.removedOnCompletion = NO;
//    basicAnim.fillMode = kCAFillModeForwards;
    
    basicAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [_testLayer addAnimation:basicAnim forKey:@"basicAnimation"];
}

// 关键帧动画
- (void)btn2Click:(id)sender
{
    _testLayer.position = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 35);
    
    CAKeyframeAnimation *keyAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGFloat pathL = self.view.frame.size.height - 35 - 180;
    keyAnim.values = @[[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, 180)],
                       [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 35)],
                       [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 35 - pathL/2)],
                       [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 35)],
                       [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 35 - pathL/4)],
                       [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 35)],
                       [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 35 - pathL/8)],
                       [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 35)],
                       [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 35 - pathL/16)],
                       [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 35)],
                       [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 35 - pathL/32)],
                       [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 35)],
                       [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 35 - pathL/64)],
                       [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 35)],
                       [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 35 - pathL/128)],
                       [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 35)]];
    keyAnim.keyTimes = [[self getKeyTimes] subarrayWithRange:NSMakeRange(0, 15)];
    
    keyAnim.duration = [(NSNumber *)[self getKeyTimes].lastObject doubleValue];
    
    keyAnim.timingFunctions = [self getTimingFunc];
    
    [_testLayer addAnimation:keyAnim forKey:@"keyframeAnimation"];
}

- (NSArray*)getKeyTimes
{
    CGFloat time = 1.2;
    CGFloat totalTime = time;
    NSMutableArray *times = [NSMutableArray array];
    [times addObject:[NSNumber numberWithFloat:0]];
    for (int i = 0; i<14; i++)
    {
        time /= 1.414;
        totalTime += time;
    }
    time = 1.2;
    CGFloat timeRate = time/totalTime;
    [times addObject:[NSNumber numberWithFloat:timeRate]];
    for (int i = 0; i<14; i++)
    {
        time /= 1.414;
        timeRate += time/totalTime;
        [times addObject:[NSNumber numberWithFloat:timeRate]];
    }
    [times addObject:[NSNumber numberWithFloat:totalTime]];
    return times;
}

- (NSArray*)getTimingFunc
{
    NSMutableArray *timingFuncs = [NSMutableArray array];
    BOOL flag = YES;
    for (int i = 0; i<15; i++)
    {
        if (flag)
        {
            [timingFuncs addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        }
        else
        {
            [timingFuncs addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        }
        flag = !flag;
    }
    return timingFuncs;
}

- (void)initLayer
{
    _testLayer = [CALayer layer];
    _testLayer.position = CGPointMake(self.view.frame.size.width/2, 180);
    _testLayer.bounds = CGRectMake(0, 0, 50, 50);
    _testLayer.backgroundColor = [UIColor redColor].CGColor;
    _testLayer.cornerRadius = 25;
    [self.view.layer addSublayer:_testLayer];
}

@end
