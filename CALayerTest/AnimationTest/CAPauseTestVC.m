//
//  CAPauseTestVC.m
//  AnimationTest
//
//  Created by zhengqian.shi on 17/2/12.
//  Copyright © 2017年 QITMAC000263. All rights reserved.
//

#import "CAPauseTestVC.h"

typedef enum : NSUInteger {
    BtnStatusStart,
    BtnStatusPause,
    BtnStatusContinue,
} BtnStatus;

@interface CAPauseTestVC ()<CAAnimationDelegate>
{
    BtnStatus _btnStatus;
    CGFloat _sliderValue;
    CGFloat _fromValue;
    CGFloat _toValue;
    CADisplayLink *_displayLink;
}
@property(nonatomic,strong) UIButton    *btnControl;
@property(nonatomic,strong) CALayer     *testLayer;
@property(nonatomic,strong) CALayer     *testLayer2;
@property(nonatomic,strong) UISlider    *slider;
@property(nonatomic,strong) CABasicAnimation    *testAnimation;

@end

@implementation CAPauseTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initData];
    
    [self initViewSubs];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [_displayLink invalidate];
    _displayLink = nil;
    [_testAnimation setDelegate:nil];
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)initData
{
    _btnControl = 0;
    _testAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    _testAnimation.fromValue = (__bridge id _Nullable)([UIColor redColor].CGColor);
    _testAnimation.toValue = (__bridge id _Nullable)(([UIColor yellowColor].CGColor));
    _testAnimation.duration = 3.0;
    [_testAnimation setDelegate:self];
    
    _fromValue = CGColorGetComponents([UIColor redColor].CGColor)[1];
    _toValue = CGColorGetComponents([UIColor yellowColor].CGColor)[1];
}

- (void)initViewSubs
{
    _testLayer = [[CALayer alloc] init];
    _testLayer.position = CGPointMake(self.view.frame.size.width/2, 200);
    _testLayer.bounds = CGRectMake(0, 0, 200, 100);
    _testLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:_testLayer];
    
    _testLayer2 = [[CALayer alloc] init];
    _testLayer2.position = CGPointMake(self.view.frame.size.width/2, 400);
    _testLayer2.bounds = CGRectMake(0, 0, 200, 100);
    _testLayer2.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:_testLayer2];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(_testLayer.position.x - 100, _testLayer.position.y + 50, 200, 50)];
    [_slider setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.2]];
    [_slider setContinuous:YES];
    [_slider addTarget:self action:@selector(onSliderChanged:) forControlEvents:UIControlEventValueChanged];
    _sliderValue = _slider.value;
    [self.view addSubview:_slider];
    
    _btnControl = [[UIButton alloc] initWithFrame:CGRectMake(_slider.center.x - 50, _testLayer2.position.y + 60, 100, 30)];
    [_btnControl setBackgroundColor:[UIColor grayColor]];
    [_btnControl setTitle:@"开 始" forState:UIControlStateNormal];
    [_btnControl addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnControl];
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink:)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)btnClick:(id)sender
{
    if (BtnStatusStart == _btnStatus)
    {
        NSLog(@"layerCurrentTime:%f",[_testLayer convertTime:CACurrentMediaTime() fromLayer:nil]);
        
        [_testLayer2 addAnimation:_testAnimation forKey:@"testAnimation"];
        [_testLayer addAnimation:_testAnimation forKey:@"testAnimation"];
        _btnStatus = BtnStatusPause;
        [_btnControl setTitle:@"暂 停" forState:UIControlStateNormal];
    }
    else if (BtnStatusPause == _btnStatus)
    {
        _btnStatus = BtnStatusContinue;
        [self pauseAnimation];
        [_btnControl setTitle:@"继 续" forState:UIControlStateNormal];
    }
    else if (BtnStatusContinue == _btnStatus)
    {
        _btnStatus = BtnStatusPause;
        [self continueAnimation];
        [_btnControl setTitle:@"暂 停" forState:UIControlStateNormal];
    }
}

- (void)onDisplayLink:(CADisplayLink *)link
{
    if (_testLayer2.animationKeys.count == 0)
    {
        _btnStatus = BtnStatusStart;
        [_btnControl setTitle:@"开 始" forState:UIControlStateNormal];
        _slider.value = 0;
    }
    else if (_testLayer.speed < 0.0001 && BtnStatusContinue != _btnStatus)
    {
        _btnStatus = BtnStatusContinue;
        [_btnControl setTitle:@"继 续" forState:UIControlStateNormal];
    }
    
    if (BtnStatusStart != _btnStatus)
    {
        CGFloat nowValue = CGColorGetComponents(_testLayer.presentationLayer.backgroundColor)[1];
        
        _slider.value = (nowValue - _fromValue)/(_toValue - _fromValue);
        _sliderValue = _slider.value;
    }
}

- (void)pauseAnimation
{
    _testLayer2.timeOffset = [_testLayer2 convertTime:CACurrentMediaTime() fromLayer:nil];
    _testLayer2.speed = 0;
    
    _testLayer.timeOffset = [_testLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    _testLayer.speed = 0;
    
    NSLog(@"layerCurrentTime:%f",[_testLayer convertTime:CACurrentMediaTime() fromLayer:nil]);
    
    NSLog(@"layerTimeOffset:%f",_testLayer.timeOffset);
}

- (void)continueAnimation
{
    _testLayer2.beginTime = CACurrentMediaTime() - _testLayer2.timeOffset;
    _testLayer2.timeOffset = 0;
    _testLayer2.speed = 1;
    
    _testLayer.beginTime = CACurrentMediaTime() - _testLayer.timeOffset;
    _testLayer.timeOffset = 0;
    _testLayer.speed = 1;
    
      NSLog(@"currentTime:%f",CACurrentMediaTime());
    NSLog(@"layerTimeOffset:%f",_testLayer.timeOffset);
    NSLog(@"beginTime:%f",_testLayer.beginTime);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
{
    _btnStatus = BtnStatusStart;
    [_btnControl setTitle:@"开 始" forState:UIControlStateNormal];
}

- (void)onSliderChanged:(id)sender
{
    if (_testLayer.animationKeys.count == 0)
    {
//        [_testLayer addAnimation:_testAnimation forKey:@"testAnimation"];
//        [_testLayer2 addAnimation:_testAnimation forKey:@"testAnimation"];

//        [self pauseAnimation];
        
        [self btnClick:nil];
        [self btnClick:nil];
    }
    
    if (_testLayer.speed < 0.0001)
    {
        _testLayer.timeOffset += 3*(_slider.value - _sliderValue);
        _testLayer2.timeOffset += 3*(_slider.value - _sliderValue);
//        _testLayer.timeOffset = 3*(_slider.value);
//        _testLayer2.timeOffset = 3*(_slider.value);
    }
    
    NSLog(@"layerCurrentTime:%f",[_testLayer convertTime:CACurrentMediaTime() fromLayer:nil]);
    NSLog(@"layerTimeOffset:%f",_testLayer.timeOffset);
    
    _sliderValue = _slider.value;
}

@end
