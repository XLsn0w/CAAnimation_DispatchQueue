//
//  UIViewAnimationTestVC.m
//  AnimationTest
//
//  Created by zhengqian.shi on 17/2/9.
//  Copyright © 2017年 QITMAC000263. All rights reserved.
//

#import "UIViewAnimationTestVC.h"
#import "MyTestView.h"

@interface UIViewAnimationTestVC ()
{
    UInt64 _recordTime3;
    UInt64 _recordTime1;

}

@property(nonatomic,strong) MyTestView  *testView;

@end

@implementation UIViewAnimationTestVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self initSubs];
    
    [self layerTest];

    [self viewTest];
}

- (void)layerTest
{
    NSLog(@"--------------------------------");
    
    NSLog(@"view.center:(%f,%f)",_testView.center.x,_testView.center.y);
    
    _testView.layer.position = CGPointMake(200, 200);
    
    NSLog(@"view.center:(%f,%f)",_testView.center.x,_testView.center.y);
}

- (void)viewTest
{
    _testView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _testView.bounds = CGRectMake(0, 0, 100, 100);
    [_testView setBackgroundColor:[UIColor redColor]];
}

- (void)initSubs
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4-60, 100, 120, 30)];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn setTitle:@"直接改变大小" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4*3-60, 100, 120, 30)];
    [btn2 setBackgroundColor:[UIColor grayColor]];
    [btn2 setTitle:@"动画改变大小" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4-60, self.view.frame.size.height-100, 120, 30)];
    [btn3 setBackgroundColor:[UIColor grayColor]];
    [btn3 setTitle:@"UIView动画3s" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(btn3Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4*3-60, self.view.frame.size.height-100, 120, 30)];
    [btn4 setBackgroundColor:[UIColor grayColor]];
    [btn4 setTitle:@"UIView动画1s" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(btn4Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    _testView = [[MyTestView alloc] init];
    [self.view addSubview:_testView];
}

- (void)btnClick:(id)sender
{
    if (_testView.bounds.size.width > 150)
    {
        _testView.bounds = CGRectMake(0, 0, 100, 100);
    }
    else
    {
        _testView.bounds = CGRectMake(0, 0, 200, 200);
    }
}

- (void)btn2Click:(id)sender
{
    _testView.showAnimation = YES;
    if (_testView.bounds.size.width > 150)
    {
        _testView.bounds = CGRectMake(0, 0, 100, 100);
    }
    else
    {
        _testView.bounds = CGRectMake(0, 0, 200, 200);
    }
    _testView.showAnimation = NO;
}

- (void)btn3Click:(id)sender
{
    CGRect originBounds = _testView.bounds;
    
    /** UIView动画会生成一个CABassicAnimation,默认时间函数为EaseInEaseOut,默认填充方式为both
     ** fromValue为动画前的值，没有toValue和byValue:即会在动画前与当前值之间进行插值，当前值就是我们block中设置的值，也是modelLayer的对应值
     ** 可在MyTestView的actionForLayer方法中断点查看 */
    
    [UIView animateWithDuration:3 animations:^(void){
        _recordTime3 = [[NSDate date] timeIntervalSince1970]*1000;

        if (_testView.bounds.size.width > 150)
        {
            _testView.bounds = CGRectMake(0, 0, 100, 100);
        }
        else
        {
            _testView.bounds = CGRectMake(0, 0, 200, 200);
        }

        /** 在block中set新值会进行判断，如果没有发生改变则不会设置它layer的对应属性，也就不会回调actionForLayer，直接回调finished方法
         ** 如果手动调用actionForLayer，会返回一个动画对象，但我们并没有将这个动画对象加到layer上面，也就不会回调finished方法。*/
       /*_testView.bounds = originBounds;
       id action = [_testView.layer.delegate actionForLayer:_testView.layer forKey:@"bounds"];
       NSLog(@"%@",action);*/
        
    } completion:^(BOOL finished){
        NSLog(@"%d",finished);
        
        UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
        NSLog(@"%llu毫秒",recordTime-_recordTime3);
    }];
}

- (void)btn4Click:(id)sender
{
//    NSLog(@"presentationLayer:%f",_testView.layer.presentationLayer.bounds.size.height);
    
    [UIView animateWithDuration:1 animations:^(void){
        _recordTime1 = [[NSDate date] timeIntervalSince1970]*1000;
        
        if (_testView.bounds.size.width > 150)
        {
            _testView.bounds = CGRectMake(0, 0, 100, 100);
        }
        else
        {
            _testView.bounds = CGRectMake(0, 0, 200, 200);
        }
        
    } completion:^(BOOL finished){
        NSLog(@"%d",finished);
        
        UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
        NSLog(@"%llu毫秒",recordTime-_recordTime1);
    }];
}


@end
