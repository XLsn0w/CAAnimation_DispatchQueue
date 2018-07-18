//
//  NSOperationViewController.m
//  XLsn0wAnimation
//
//  Created by HL on 2018/7/18.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "NSOperationViewController.h"

@interface NSOperationViewController ()

@end

@implementation NSOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 1.NSOperation是一个抽象类,并不具备封装操作的能力,必须使用它的子类
 NSOperation的子类
 1.NSInvocationOperation
 2.NSBlockOperation
 3.自定义继承NSOperation的子类,实现子类内部的main(对象方法)方法

*/

@end
