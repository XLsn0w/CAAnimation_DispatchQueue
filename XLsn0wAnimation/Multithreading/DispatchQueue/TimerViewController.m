//
//  TimerViewController.m
//  XLsn0wAnimation
//
//  Created by XLsn0w on 2018/9/3.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "TimerViewController.h"

@interface TimerViewController ()

@property (nonatomic, strong) dispatch_source_t gcdTimer;

@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

int count = 0;
- (void)GCDTimer {
    self.gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC); // 从现在开始两秒后执行
    dispatch_source_set_timer(self.gcdTimer, startTime, (int64_t)(2.0 * NSEC_PER_SEC), 0); // 每两秒执行一次
    // 定时器回调
    dispatch_source_set_event_handler(self.gcdTimer, ^{
        NSLog(@"CGD定时器-----%@",[NSThread currentThread]);
        count++;
        if (count == 5) { // 执行5次,让定时器取消
            dispatch_cancel(self.gcdTimer);
            self.gcdTimer = nil;
        }
        
    });
    // 启动定时器: GCD定时器默认是暂停的
    dispatch_resume(self.gcdTimer);
}

//dispatch_group
//在某些特殊的场景下我们需要同时执行多个耗时任务,并且在多个任务都完成的之后在回到主线程刷新UI,此时就可以使用dispath_group了
#pragma mark - configDispatch_group
- (void)configDispatch_group {
    dispatch_group_t gcdGroup = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_async(gcdGroup, queue, ^{
        NSLog(@"执行第一个任务");
    });
    dispatch_group_async(gcdGroup, queue, ^{
        NSLog(@"执行第二个任务");
    });
    dispatch_group_async(gcdGroup, queue, ^{
        NSLog(@"执行第三个任务");
    });
    dispatch_group_notify(gcdGroup, dispatch_get_main_queue(), ^{
        NSLog(@"回到了主线程");
    });
}

//dispatch_barrier 栅栏函数
//当一个任务的执行与否依赖于上一个任务执行的结果的时候我们可以使用dispatch_barrier,栅栏函数的作用在于控制并发任务执行的先后顺序
#pragma mark - dispatch_barrier
- (void)configDispatch_barrier {
    //    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);///使用全局并发队列不起作用
    dispatch_async(queue, ^{
        NSLog(@"执行第一个任务--%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"执行第二个任务--%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"执行第三个任务--%@",[NSThread currentThread]);
    });
    
    ///拦截
    dispatch_barrier_async(queue, ^{
        NSLog(@"我是栅栏,前边的任务都执行完了,在执行下边的任务--%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"执行第四个任务--%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"执行第五个任务--%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"执行第六个任务--%@",[NSThread currentThread]);
    });
}


//dispatch_semahpore 信号量
//有时候在开发中我们希望执行完一个任务(成功/失败)才接着执行下一个任务,这是我们可以使用信号量来控制
//信号量运行准则:
//信号量就是一个资源计数器,当其不为0时线程正常运行,为0时则阻塞当前线程.
//实现原理:
//使用信号量的PV操作来实现互斥.P:信号量-1,V:信号量+1
//例如:
//默认初始信号量为1
//当A正常运行,使用资源;对信号量实施P操作,信号量-1
//当B期望使用资源来正常运行,发现信号量为0(阻塞),B一直等待
//A执行完成,进行V操作,释放资源,信号量+1
//B检测到信号量不为0,则正常运行
#pragma mark - 信号量
- (void)configDispatch_semaphore {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    NSArray *titleArray = @[@(1),@(1),@(1),@(0),@(1)];
    for (int i = 0; i<titleArray.count; i++) {
        int number = [titleArray[i] intValue];
        dispatch_async(queue, ^{
            //信号量为0是则阻塞当前线程,不为0则减1继续执行当前线程
            dispatch_wait(semaphore, DISPATCH_TIME_FOREVER);
            if (number) {
                NSLog(@"%d--当前线程:%@",i,[NSThread currentThread]);
                dispatch_semaphore_signal(semaphore);
            } else {
                NSLog(@"%d--当前线程:%@",i,[NSThread currentThread]);
                dispatch_semaphore_signal(semaphore);
            }
        });
    }
}

///dispatch_after
#pragma mark - GCD延时函数
- (void)configDispatch_after {
    NSLog(@"开始执行");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"两秒后我执行了");
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
