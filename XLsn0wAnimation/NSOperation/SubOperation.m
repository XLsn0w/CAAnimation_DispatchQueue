//
//  SubOperation.m
//  XLsn0wAnimation
//
//  Created by HL on 2018/7/18.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "SubOperation.h"

@implementation SubOperation {
    BOOL        executing;
    BOOL        finished;
}

- (void)main {
    @try {
        
        // Do the main work of the operation here.
        
        [self completeOperation];
    }
    @catch(...) {
        // Do not rethrow exceptions.
    }
}

- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

//GCD和NSOperation的区别
//1、GCD是一种轻量级的方法来实现多线程。控制起来比较麻烦，比如取消和暂停一个线程。
//2、NSOperation和NSOperationQueue相对于GCD效率上要低一点，他们是面向对象的方式，从Mac OS X v10.6和iOS4开始，NSOperation底层也是用的GCD来实现的。可以在多个操作中添加附属，也可以重用操作，取消或者暂停。NSOperation和KVO是兼容，也就是说，可以在NSOperation中使用KVO，例如，你可以通过NSNotificationCenter去让一个操作开始执行。
//
//3、NSOperation的使用方法
//【1】、继承NSOperation类
//【2】、重写“main”方法
//【3】、在“main”方法中创建一个autoreleasepool
//【4】、将自己的代码放在autoreleasepool中
//注意：创建自动释放池的原因是，你不能访问主线程的自动释放池，所以需要自己创建一个。
//
//4、NSOperation的常用方法
//【1】、start：开始方法，当把NSOperation添加到NSOperationQueue中去后，队列会在操作中调用start方法。
//【2】、addDependency，removeDependency：添加从属性，删除从属性，比如说有线程a，b，如果操作a从属于b，那么a会等到b结束后才开始执行。
//【3】、setQueuePriority：设置线程的优先级。例：[a setQueuePriority:NSOperationQueuePriorityVeryLow];一共有四个优先级：NSOperationQueuePriorityLow，NSOperationQueuePriorityNormal，NSOperationQueuePriorityHigh，NSOperationQueuePriorityVeryHigh。
//当你添加一个操作到一个队列时，在对操作调用start之前，NSOperationQueue会浏览所有的操作，具有较高优先级的操作会优先执行，具有相同优先级的操作会按照添加到队列中顺序执行。
//【4】、setCompletionBlock：设置回调方法，当操作结束后，会调用设置的回调block。这个block会在主线程中执行。
//
//
//
//说法二
//
//
//
//GCD是基于c的底层api，NSOperation属于object-c类。ios 首先引入的是NSOperation，IOS4之后引入了GCD和NSOperationQueue并且其内部是用gcd实现的。
//
//相对于GCD：
//1，NSOperation拥有更多的函数可用，具体查看api。
//2，在NSOperationQueue中，可以建立各个NSOperation之间的依赖关系。
//3，有kvo，可以监测operation是否正在执行（isExecuted）、是否结束（isFinished），是否取消（isCanceld）。
//4，NSOperationQueue可以方便的管理并发、NSOperation之间的优先级。
//GCD主要与block结合使用。代码简洁高效。
//GCD也可以实现复杂的多线程应用，主要是建立个个线程时间的依赖关系这类的情况，但是需要自己实现相比NSOperation要复杂。
//具体使用哪个，依需求而定。 从个人使用的感觉来看，比较合适的用法是：除了依赖关系尽量使用GCD，因为苹果专门为GCD做了性能上面的优化。

@end
