//
//  MaskLayerTestVC.m
//  AnimationTest
//
//  Created by zhengqian.shi on 17/2/13.
//  Copyright © 2017年 QITMAC000263. All rights reserved.
//

#import "MaskLayerTestVC.h"

@interface MaskLayerTestVC ()<CAAnimationDelegate>
{
    BOOL _locker;
}

@property(nonatomic,strong) UIView *cardView;
@property(nonatomic,strong) CATextLayer *textLayer;
@property(nonatomic,strong) UIView *backView;

@property(nonatomic,strong) UIBezierPath    *path;
@property(nonatomic,strong) CAShapeLayer    *maskLayer;

@end

@implementation MaskLayerTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initViewSubs];
}

- (void)initViewSubs
{
    _cardView = [[UIView alloc] init];
    _cardView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _cardView.bounds = CGRectMake(0, 0, 200, 150);
    _cardView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_cardView];
    
    _backView = [[UIView alloc] init];
    _backView.frame = CGRectMake(25, 75, 150, 36);
    _backView.backgroundColor = [UIColor blackColor];
    [_cardView addSubview:_backView];
    
    _textLayer = [CATextLayer layer];
    _textLayer.string = [self getReward];
    _textLayer.fontSize = 24;
    _textLayer.alignmentMode = kCAAlignmentCenter;
    _textLayer.backgroundColor = [UIColor whiteColor].CGColor;
    _textLayer.foregroundColor = [UIColor blackColor].CGColor;
    _textLayer.frame = CGRectMake(25, 75, 150, 36);

    _maskLayer = [CAShapeLayer layer];
    _maskLayer.strokeColor = [UIColor redColor].CGColor;
    _maskLayer.lineWidth = 12;
    _maskLayer.lineCap = kCALineCapRound;
    _maskLayer.fillColor = [UIColor clearColor].CGColor;
    _maskLayer.frame = CGRectMake(0, 0, 150, 36);
    _textLayer.mask = _maskLayer;

    [_cardView.layer addSublayer:_textLayer];
    
    _path = [UIBezierPath bezierPath];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    btn.center = CGPointMake(_cardView.center.x, _cardView.center.y+150);
    btn.bounds = CGRectMake(0, 0, 120, 30);
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn setTitle:@"再来一次" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!_locker)
    {
        UITouch *touch = [touches anyObject];
        [_path addLineToPoint:[touch locationInView:_backView]];
        _maskLayer.path = _path.CGPath;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!_locker)
    {
        UITouch *touch = [touches anyObject];
        [_path moveToPoint:[touch locationInView:_backView]];
        _maskLayer.path = _path.CGPath;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!_locker)
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        animation.toValue = (__bridge id _Nullable)([UIColor redColor].CGColor);
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.duration = 0.5;
        animation.delegate = self;
        [_maskLayer addAnimation:animation forKey:@"backColor"];
    }
}

- (void)animationDidStart:(CAAnimation *)anim;
{
    _locker = YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
{
    if (_locker)
    {
        _maskLayer.backgroundColor = [UIColor redColor].CGColor;
    }
}

- (void)btnClick:(id)sender
{
    _locker = NO;
    _textLayer.string = [self getReward];
    [_maskLayer removeAllAnimations];
    
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.strokeColor = [UIColor redColor].CGColor;
    _maskLayer.lineWidth = 12;
    _maskLayer.lineCap = kCALineCapRound;
    _maskLayer.fillColor = [UIColor clearColor].CGColor;
    _maskLayer.frame = CGRectMake(0, 0, 150, 36);
    _maskLayer.backgroundColor = [UIColor clearColor].CGColor;
    _textLayer.mask = _maskLayer;
    
    _path = [UIBezierPath bezierPath];
}

- (NSString *)getReward
{
    NSString *str = [NSString string];
    NSInteger reward = arc4random()%10;
    if (reward == 0)
    {
        str = @"一  等  奖";
    }
    else if (reward < 3)
    {
        str = @"二  等  奖";
    }
    else if (reward < 6)
    {
        str = @"三  等  奖";
    }
    else if (reward < 9)
    {
        str = @"安  慰  奖";
    }
    else
    {
        str = @"什么都没有";
    }
    return str;
}

@end
