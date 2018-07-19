//
//  PMLayerTestVC.m
//  AnimationTest
//
//  Created by zhengqian.shi on 17/2/10.
//  Copyright © 2017年 QITMAC000263. All rights reserved.
//

#import "PMLayerTestVC.h"
#import "MyTestLayer.h"
#import "MyTestView.h"
#import "MoveLogoImg.h"

@interface PMLayerTestVC ()
{
    dispatch_queue_t    dispatchQueue;
}
@property(nonatomic,strong) MyTestLayer *testLayer;
@property(nonatomic,strong) MyTestView  *testView;

@end

@implementation PMLayerTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatchQueue = dispatch_queue_create("saqueue", NULL);
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self viewTest];
    
    [self layerTest];
}

- (void)layerTest
{
    _testLayer = [[MyTestLayer alloc] init];
    _testLayer.position = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 100);
    _testLayer.bounds = CGRectMake(0, 0, 100, 100);
    _testLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:_testLayer];
}

- (void)viewTest
{
    _testView = [[MyTestView alloc] init];
    _testView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 100);
    _testView.bounds = CGRectMake(0, 0, 100, 100);
    [_testView setBackgroundColor:[UIColor purpleColor]];
    [self.view addSubview:_testView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4-60, 100, 120, 30)];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn setTitle:@"改变layer" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4-60, self.view.frame.size.height-100, 120, 30)];
    [btn3 setBackgroundColor:[UIColor grayColor]];
    [btn3 setTitle:@"位置在起点" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(btn3Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4*3-60, self.view.frame.size.height-100, 120, 30)];
    [btn4 setBackgroundColor:[UIColor grayColor]];
    [btn4 setTitle:@"位置在终点" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(btn4Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];

}

- (void)testLayerAnimation
{
    _testLayer.position = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 200);

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 100)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 200)];
    animation.duration = 2;
    //animation.removedOnCompletion = NO;
    //animation.fillMode = kCAFillModeForwards;
    [_testLayer addAnimation:animation forKey:@"BAnimation"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.1) * NSEC_PER_SEC)), dispatchQueue, ^{
        NSLog(@"presentationLayer %@ y %f",_testLayer.presentationLayer, _testLayer.presentationLayer.position.y);
        NSLog(@"presentationLayer.modelLayer %@ y %f",_testLayer.presentationLayer.modelLayer,_testLayer.presentationLayer.modelLayer.position.y);
        NSLog(@"layer.modelLayer %@ y %f",_testLayer.modelLayer,_testLayer.modelLayer.position.y);
        NSLog(@"layer %@",_testLayer);
    });
}
- (void)btnClick:(id)sender
{
    MyTestView *view = [[MyTestView alloc]initWithFrame:CGRectMake(200, 200, 100, 100)];
    [self.view addSubview:view];
    
    view.center = CGPointMake(1000, 1000);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((1/60) * NSEC_PER_SEC)), dispatchQueue, ^{
        NSLog(@"presentationLayer %@ y %f",view.layer.presentationLayer, view.layer.presentationLayer.position.y);
        NSLog(@"layer.modelLayer %@ y %f",view.layer.modelLayer,view.layer.modelLayer.position.y);
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((1/20) * NSEC_PER_SEC)), dispatchQueue, ^{
        NSLog(@"presentationLayer %@ y %f",view.layer.presentationLayer, view.layer.presentationLayer.position.y);
        NSLog(@"layer.modelLayer %@ y %f",view.layer.modelLayer,view.layer.modelLayer.position.y);
    });
}

- (void)btn3Click:(id)sender
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 100)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 50)];
    animation.duration = 1;
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
    [_testView.layer addAnimation:animation forKey:@"baanimation"];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((2) * NSEC_PER_SEC)), dispatchQueue, ^{
//        NSLog(@"presentationLayer %@ y %f",_testView.layer.presentationLayer, _testView.layer.presentationLayer.position.y);
//        NSLog(@"layer.modelLayer %@ y %f",_testView.layer.modelLayer,_testView.layer.modelLayer.position.y);
//    });
}

- (void)btn4Click:(id)sender
{
    [self testLayerAnimation];
}

@end
