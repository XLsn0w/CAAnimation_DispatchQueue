//
//  NSOperationViewController.m
//  XLsn0wAnimation
//
//  Created by HL on 2018/7/18.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "NSOperationViewController.h"

@interface NSOperationViewController ()

//GCD & NSOperationQueue 队列类型的创建方式
//GCD 队列类型的创建方式：
//（1）并发队列：手动创建、全局
//
//（2）串行队列：手动创建、主队列
//
//NSOperationQueue的队列类型的创建方法：
//（1）主队列：[NSOperationQueue mainQueue]
//
//凡是添加到主队列中的任务（NSOperation），都会放到主线程中执行
//（2）其他队列（同时包含了串行、并发功能）：[NSOperationQueue alloc]init]
//
//添加到这种队列中的任务（NSOperation），就会自动放到子线程中执行

@end

@implementation NSOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
//    NSInvocationOperation
//    //创建NSInvocationOperation对象
//    - (id)initWithTarget:(id)target selector:(SEL)sel object:(id)arg;
//
//    //调用start方法开始执行操作，一旦执行操作，就会调用target的sel方法
//    - (void)start;
    
    NSInvocationOperation *iop = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download1:) object:nil];
    [iop start];
    
    //    操作优先级
    //    设置NSOperation在queue中的优先级，可以改变操作的执行优先级：
    //
    //    @property NSOperationQueuePriority queuePriority;
    //
    //    - (void)setQueuePriority:(NSOperationQueuePriority)p;
    //    优先级的取值：优先级高的任务，调用的几率会更大
    //
    //    typedef NS_ENUM(NSInteger, NSOperationQueuePriority) {
    //        NSOperationQueuePriorityVeryLow = -8L,
    //        NSOperationQueuePriorityLow = -4L,
    //        NSOperationQueuePriorityNormal = 0,
    //        NSOperationQueuePriorityHigh = 4,
    //        NSOperationQueuePriorityVeryHigh = 8
    //    };
    iop.queuePriority = NSOperationQueuePriorityVeryHigh;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    ///一定要在把操作添加到队列之前，进行设置操作依赖。
//    任务添加的顺序并不能够决定执行顺序，执行的顺序取决于依赖。
    //创建对象，封装操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download1----%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download2----%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download3----%@", [NSThread currentThread]);
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 5; i++) {
            NSLog(@"download4----%@", [NSThread currentThread]);
        }
    }];
    
    NSBlockOperation *op5 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download5----%@", [NSThread currentThread]);
    }];
    //操作的监听
    op5.completionBlock = ^{
        NSLog(@"op5执行完毕---%@", [NSThread currentThread]);
    };
    
    //设置操作依赖（op4执行完，才执行 op3）
    [op3 addDependency:op1];
    [op3 addDependency:op2];
    [op3 addDependency:op4];
    
    //把操作添加到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    [queue addOperation:op5];
    
    
//    NSBlockOperation
//    //创建 NSBlockOperation 操作对象
//    + (id)blockOperationWithBlock:(void (^)(void))block;
//
//    // 添加操作
//    - (void)addExecutionBlock:(void (^)(void))block;
    
    // 1.创建 NSBlockOperation 操作对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        // 在主线程
        NSLog(@"下载1------%@", [NSThread currentThread]);
    }];
    
    // 2.添加操作（额外的任务）（在子线程执行)
    [op addExecutionBlock:^{
        NSLog(@"下载2------%@", [NSThread currentThread]);
    }];
    

        [op addExecutionBlock:^{
            NSLog(@"下载2------%@", [NSThread currentThread]);
        }];
        [op addExecutionBlock:^{
            NSLog(@"下载3------%@", [NSThread currentThread]);
        }];
        [op addExecutionBlock:^{
            NSLog(@"下载4------%@", [NSThread currentThread]);
        }];
        // 3.开启执行操作
        [op start];
    
//    NSOperationQueue
//    NSOperationQueue的作用：添加操作到NSOperationQueue中，自动执行操作，自动开启线程
//
//    NSOperation 可以调用 start 方法来执行任务，但默认是同步执行的
//    如果将 NSOperation 添加到 NSOperationQueue（操作队列）中，系统会自动异步执行NSOperation中的操作
//    添加操作到 NSOperationQueue 中：2种方式
//
//
//    - (void)addOperation:(NSOperation *)op;
//
//    - (void)addOperationWithBlock:(void (^)(void))block NS_AVAILABLE(10_6, 4_0);
    

}

#pragma mark - 把操作添加到队列中,方式1：addOperation
- (void)operationQueue1 {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    
    // 2.设置最大并发操作数(大并发操作数 = 1,就变成了串行队列)
    queue.maxConcurrentOperationCount = 2;
    
    // 2.1 方式1：创建操作（任务）NSInvocationOperation ，封装操作
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self
                                                                      selector:@selector(download1)
                                                                        object:nil];
    
    // 2.2 方式2：创建NSBlockOperation ，封装操作
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download2 --- %@", [NSThread currentThread]);
    }];
    
    // 添加操作
    [op2 addExecutionBlock:^{
        NSLog(@"download3 --- %@", [NSThread currentThread]);
    }];
    
    // 3.把操作（任务）添加到队列中，并自动调用 start 方法
    [queue addOperation:op1];
    [queue addOperation:op2];
    
    
//    最大并发数
//    并发数：同时执⾏行的任务数 比如,同时开3个线程执行3个任务,并发数就是3
//
//    最大并发数：同一时间最多只能执行的任务的个数
//
//    最⼤并发数的相关⽅方法：
//    //最大并发数，默认为-1
//    @property NSInteger maxConcurrentOperationCount;
//
//    - (void)setMaxConcurrentOperationCount:(NSInteger)cnt;
//    说明：
//
//    如果没有设置最大并发数，那么并发的个数是由系统内存和CPU决定的，内存多就开多一点，内存少就开少一点。
//    最⼤并发数的值并不代表线程的个数，仅仅代表线程的ID。
//    最大并发数不要乱写（5以内），不要开太多，一般以2~3为宜，因为虽然任务是在子线程进行处理的，但是cpu处理这些过多的子线程可能会影响UI，让UI变卡。
//    最大并发数的值为1，就变成了串行队列
    

//    队列的暂停：当前任务结束后，暂停执行下一个任务，而非当前任务
//
//    //暂停和恢复队列（YES代表暂停队列，NO代表恢复队列）
//    - (void)setSuspended:(BOOL)b;
//
//    //当前状态
//    - (BOOL)isSuspended;
//    暂停和恢复的使用场合：
//
//    在tableview界面，开线程下载远程的网络界面，对UI会有影响，使用户体验变差。那么这种情况，就可以设置在用户操作UI（如滚动屏幕）的时候，暂停队列（不是取消队列），停止滚动的时候，恢复队列。
    
    if (queue.isSuspended) {
        queue.suspended = NO; // 恢复队列，继续执行
    } else {
        queue.suspended = YES; // 暂停（挂起）队列，暂停执行
    }
    
//    取消队列的所有操作：相等于调用了所有 NSOperation 的 -(void)cancel 方法，
//    当前任务结束后，取消执行下面的所有任务，而非当前任务
//
//    // 也可调用NSOperation的 -(void)cancel 方法取消单个操作
//    - (void)cancelAllOperations;
    
    // 取消队列的所有操作（相等于调用了所有NSOperation的-(void)cancel方法）
    [queue cancelAllOperations];
    

    

}

#pragma mark - 线程间通信（图片合成）
- (void)test1 {
    // 1.队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    __block UIImage *image1 = nil;
    // 2.下载图片1
    NSBlockOperation *download1 = [NSBlockOperation blockOperationWithBlock:^{
        // 图片的网络路径
        NSURL *url =
        [NSURL URLWithString:@"http://img.pconline.com.cn/images/photoblog/9/9/"
         @"8/1/9981681/200910/11/1255259355826.jpg"];
        // 加载图片
        NSData *data = [NSData dataWithContentsOfURL:url];
        // 生成图片
        image1 = [UIImage imageWithData:data];
    }];
    
    __block UIImage *image2 = nil;
    // 3.下载图片2
    NSBlockOperation *download2 = [NSBlockOperation blockOperationWithBlock:^{
        // 图片的网络路径
        NSURL *url = [NSURL
                      URLWithString:
                      @"http://pic38.nipic.com/20140228/5571398_215900721128_2.jpg"];
        // 加载图片
        NSData *data = [NSData dataWithContentsOfURL:url];
        // 生成图片
        image2 = [UIImage imageWithData:data];
    }];
    
    // 4.合成图片
    NSBlockOperation *combine = [NSBlockOperation blockOperationWithBlock:^{
        // 开启新的图形上下文
        UIGraphicsBeginImageContext(CGSizeMake(100, 100));
        
        // 绘制图片1
        [image1 drawInRect:CGRectMake(0, 0, 50, 100)];
        image1 = nil;
        
        // 绘制图片2
        [image2 drawInRect:CGRectMake(50, 0, 50, 100)];
        image2 = nil;
        
        // 取得上下文中的图片
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        // 结束上下文
        UIGraphicsEndImageContext();
        
        // 5.回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageView.image = image;
        }];
    }];
    
    // 设置依赖操作
    [combine addDependency:download1];
    [combine addDependency:download2];
    
    //把操作添加到队列中
    [queue addOperation:download1];
    [queue addOperation:download2];
    [queue addOperation:combine];
}


- (void)download1 {
    NSLog(@"download1 --- %@", [NSThread currentThread]);
}

#pragma mark - 把操作添加到队列中,方式2：addOperationWithBlock
- (void)operationQueue2 {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.添加操作到队列中
    [queue addOperationWithBlock:^{
        NSLog(@"download1 --- %@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"download2 --- %@", [NSThread currentThread]);
    }];
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
