//
//  UIViewAnimationViewController.m
//  XLsn0wAnimation
//
//  Created by HL on 2018/7/19.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "UIViewAnimationViewController.h"

@interface UIViewAnimationViewController ()

@end

@implementation UIViewAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIView动画
//    UIKit直接将动画集成到UIView类中，当内部的一些属性发生改变时，UIView将为这些改变提供动画支持.
//
//    执行动画所需要的工作由UIView类自动完成，但仍要在希望执行动画时通知视图，为此需要将改变属性的代码放在[UIView beginAnimations:nil context:nil]和[UIView commitAnimations]之间
//
//    常见方法解析:
//
//    + (void)setAnimationDelegate:(id)delegate
//
//    设置动画代理对象，当动画开始或者结束时会发消息给代理对象
//
//    + (void)setAnimationWillStartSelector:(SEL)selector
//
//    当动画即将开始时，执行delegate对象的selector，并且把beginAnimations:context:中传入的参数传进selector
//
//    + (void)setAnimationDidStopSelector:(SEL)selector
//
//    当动画结束时，执行delegate对象的selector，并且把beginAnimations:context:中传入的参数传进selector
    
    //说明需要执行动画
    [UIView beginAnimations:nil context:nil];
    //设置动画持续时间
    [UIView setAnimationDuration:1];
    //设置转场动画
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    //交换子视图的位置
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    //提交动画
    [UIView commitAnimations];
    
//    + (void)setAnimationDuration:(NSTimeInterval)duration
//    //动画的持续时间，秒为单位
//    + (void)setAnimationDelay:(NSTimeInterval)delay
//    //动画延迟delay秒后再开始
//    + (void)setAnimationStartDate:(NSDate *)startDate
//    //动画的开始时间，默认为now
//    + (void)setAnimationCurve:(UIViewAnimationCurve)curve
//    //动画的节奏控制,具体看下面的”备注”
//    + (void)setAnimationRepeatCount:(float)repeatCount
//    //动画的重复次数
//    + (void)setAnimationRepeatAutoreverses:(BOOL)repeatAutoreverses
//    //如果设置为YES,代表动画每次重复执行的效果会跟上一次相反
//    + (void)setAnimationTransition:(UIViewAnimationTransition)transitionforView:(UIView *)view cache:(BOOL)cache
 
    /*
    Block动画
    
    + (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
    
    参数解析:
    
    duration：动画的持续时间
    
    delay：动画延迟delay秒后开始
    
    options：动画的节奏控制
    
    animations：将改变视图属性的代码放在这个block中
    
    completion：动画结束后，会自动调用这个block
    
    + (void)transitionWithView:(UIView *)view duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
    
    参数解析:
    
    duration：动画的持续时间
    
    view：需要进行转场动画的视图
    
    options：转场动画的类型
    
    animations：将改变视图属性的代码放在这个block中
    
    completion：动画结束后，会自动调用这个block
    
    + (void)transitionFromView:(UIView *)fromView toView:(UIView *)toView duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion
    
    方法调用完毕后，相当于执行了下面两句代码：
    
    // 添加toView到父视图
    
    [fromView.superview addSubview:toView];
    
    // 把fromView从父视图中移除
    
    [fromView.superview removeFromSuperview];
    
    参数解析:
    
    duration：动画的持续时间
    
    options：转场动画的类型
    
    animations：将改变视图属性的代码放在这个block中
    
    completion：动画结束后，会自动调用这个block
    
    UIImageView的帧动画
    UIImageView可以让一系列的图片在特定的时间内按顺序显示 .
    
    相关属性解析:
    
    animationImages：要显示的图片(一个装着UIImage的NSArray) .
    
    animationDuration：完整地显示一次animationImages中的所有图片所需的时间 .
    
    animationRepeatCount：动画的执行次数(默认为0，代表无限循环)
    
    相关方法解析:
    
    - (void)startAnimating; 开始动画 .
    
    - (void)stopAnimating;  停止动画 .
    
    - (BOOL)isAnimating;  是否正在运行动画. */
    
    
//    UIActivityIndicatorView
//    是一个旋转进度轮，可以用来告知用户有一个操作正在进行中，一般用initWithActivityIndicatorStyle初始化
//    - (void)startAnimating;开始动画
//
//    - (void)stopAnimating;  停止动画
//
//    - (BOOL)isAnimating;  是否正在运行动画
//
//    UIActivityIndicatorViewStyle有3个值可供选择：
//
//    UIActivityIndicatorViewStyleWhiteLarge   //大型白色指示器
//
//    UIActivityIndicatorViewStyleWhite      //标准尺寸白色指示器
//
//    UIActivityIndicatorViewStyleGray    //灰色指示器，用于白色背景
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
    [loading startAnimating];
    [loading isAnimating];
    [loading stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
