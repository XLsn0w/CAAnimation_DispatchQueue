//
//  SemaphoreViewController.m
//  XLsn0wAnimation
//
//  Created by HL on 2018/7/17.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "SemaphoreViewController.h"

@interface SemaphoreViewController ()

@end

@implementation SemaphoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//dispatch_get_global_queue 会获取一个全局队列，我们姑且理解为系统为我们开启的一些全局线程。我们用priority指定队列的优先级，而flag作为保留字段备用（一般为0）。
//dispatch_get_main_queue 会返回主队列，也就是UI队列。它一般用于在其它队列中异步完成了一些工作后，需要在UI队列中更新界面。

//datawaitUntilDone:这个参数设置为YES和NO的区别:
//设置为YES:只有当这个线程执行完毕,才会接着往下执行,否则一直等待
//设置为NO:不管这个线程有没有执行完毕,都可以继续往下执行

-(void)dispatchSignal{
    //crate的value表示，最多几个资源可访问
    
    NSInteger threadCount = 2;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(threadCount);
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //任务1
    dispatch_async(global_queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 1");
        sleep(1);
        NSLog(@"complete task 1");
        dispatch_semaphore_signal(semaphore);
    });
    
    //任务2
    dispatch_async(global_queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 2");
        sleep(1);
        NSLog(@"complete task 2");
        dispatch_semaphore_signal(semaphore);
    });
    
    //任务3
    dispatch_async(global_queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 3");
        sleep(1);
        NSLog(@"complete task 3");
        dispatch_semaphore_signal(semaphore);
    });
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
