//
//  GCDViewController.m
//  XLsn0wAnimation
//
//  Created by HL on 2018/7/17.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t main_queue   = dispatch_get_main_queue();
    
    dispatch_async(global_queue, ^{
        // long-running task
        dispatch_async(main_queue, ^{
            // update UI
        });
    });
    
    dispatch_queue_t serialDiapatchQueue=dispatch_queue_create("com.test.queue", NULL);
    dispatch_queue_t dispatchgetglobalqueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    
    dispatch_set_target_queue(serialDiapatchQueue, dispatchgetglobalqueue);
    
    dispatch_async(serialDiapatchQueue, ^{
        NSLog(@"我优先级低，先让让");
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"我优先级高,我先block");
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //
    });
    
    
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group=dispatch_group_create();
    dispatch_group_async(group, queue, ^{NSLog(@"0");});
    dispatch_group_async(group, queue, ^{NSLog(@"1");});
    dispatch_group_async(group, queue, ^{NSLog(@"2");});
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"down");
    });

}



- (void)touchUpInsideByThreadOne:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL * url = [NSURL URLWithString:@"http://avatar.csdn.net/2/C/D/1_totogo2010.jpg"];
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.imageView.image = image; 回到主线程刷新UI
            });
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 GCD是和block紧密相连的,所以最好先了解下block(可以查看这里).GCD是C level的函数,这意味着它也提供了C的函数指针作为参数,方便了C程序员.
 
 一、下面首先来看GCD的使用:
 
 dispatch_async(dispatch_queue_t queue, dispatch_block_t block);
 async表明异步运行,block代表的是你要做的事情,queue则是你把任务交给谁来处理了.(除了async,还有sync,delay,本文以async为例).
 
 之所以程序中会用到多线程是因为程序往往会需要读取数据,然后更新UI.为了良好的用户体验,读取数据的操作会倾向于在后台运行,这样以避免阻塞主线程.GCD里就有三种queue来处理.
 
 先来介绍一下 Main queue：
 
 　　顾名思义,运行在主线程,由dispatch_get_main_queue获得.和ui相关的就要使用Main Queue.
*/

@end
