//
//  MoveLogoImg.m
//  AnimationTest
//
//  Created by zhengqian.shi on 17/1/14.
//  Copyright © 2017年 QITMAC000263. All rights reserved.
//

#import "MoveLogoImg.h"

@implementation MoveLogoImg

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.image = [UIImage imageNamed:@"logo.png"];
        self.layer.cornerRadius = 20;
        self.layer.shadowRadius = 20;
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
//        self.layer.anchorPoint = CGPointMake(0,0);
    }
    
    return self;
}

- (void)showAnimation
{
    // 大小
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@1,@3,@1];
    animation.duration = 4;
    [self.layer addAnimation:animation forKey:@"scaleAnimation"];
    
    // 位置
    CGPoint position = self.layer.position;
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation2.values = @[[NSValue valueWithCGPoint:CGPointMake(0, position.y)],
                         [NSValue valueWithCGPoint:position]];
    animation2.duration = 2;
    [self.layer addAnimation:animation2 forKey:@"moveAnimation"];
    
    // 旋转
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.fromValue = 0;
    rotateAnimation.toValue = [NSNumber numberWithFloat:M_PI*12];
    rotateAnimation.repeatCount = 1;
    rotateAnimation.duration = 4;
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.layer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
    
//    // 阴影
//    CAKeyframeAnimation *shadowAnime = [CAKeyframeAnimation animationWithKeyPath:@"shadowOffset"];
//    shadowAnime.values = @[[NSValue valueWithCGSize:CGSizeMake(0, 0)],
//                           [NSValue valueWithCGSize:CGSizeMake(0, 0)],
//                           [NSValue valueWithCGSize:CGSizeMake(30, 30)]];
//    shadowAnime.duration = 6;
//    [self.layer addAnimation:shadowAnime forKey:@"shadowAnime"];
//    
//    //
//    
//    CAKeyframeAnimation *shadowAnime2 = [CAKeyframeAnimation animationWithKeyPath:@"shadowOpacity"];
//    shadowAnime2.values = @[@0,@0,@0.5];
//    shadowAnime2.duration = 6;
//    [self.layer addAnimation:shadowAnime2 forKey:@"shadowAnime2"];
//    
//    self.layer.shadowOffset = CGSizeMake(30, 30);
//    self.layer.shadowOpacity = 0.5;
    
}

- (void)showTransform
{
    CATransform3D transformT = CATransform3DIdentity;
    CATransform3D transformS = CATransform3DIdentity;
//    CATransform3D transformR = CATransform3DIdentity;

    transformT.m41 = 201;
    //transformT = CATransform3DMakeTranslation(self.layer.position.x,0,0);
    
    transformS.m11 = transformS.m22 = 3;
    //transformS = CATransform3DMakeScale(3, 3, 1);
    
    transformT = CATransform3DMakeRotation(M_PI, 0, 0, 1);

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(transformS, transformT)];
    animation.duration = 2;
    [self.layer addAnimation:animation forKey:@""];
    self.layer.transform = CATransform3DConcat(transformS, transformT);
//    self.layer.transform = transformS;
    
//    self.layer.anchorPoint = CGPointMake(0, 0);
//    self.layer.position = CGPointMake(self.layer.position.x + 100, self.layer.position.y+200);
}

@end
