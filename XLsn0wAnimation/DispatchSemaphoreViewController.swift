//
//  DispatchSemaphoreViewController.swift
//  XLsn0wAnimation
//
//  Created by HL on 2018/7/17.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

import UIKit

class DispatchSemaphoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        ///信号量
//        为了线程安全的统计数量，我们会使用信号量作计数。原来的dispatch_semaphore_t现在用DispatchSemaphore对象表示。
//        初始化方法只有一个，传入一个Int类型的数。
        let semaphore = DispatchSemaphore(value: 5)
        
 
        semaphore.wait()
        semaphore.signal()

        
        
        
        ///swift 3中对C层级的GCD的API进行了彻头彻尾的改变。本文将从实际使用场景来了解一下新的api使用。
        
       // dispatch_async 一个常见的场景就是在一个全局队列进行一些操作后切换到主线程配置UI。现在是这么写：
        
        DispatchQueue.global().async {
            // code
            DispatchQueue.main.async {
                // 主线程中
            }
        }



//        * DISPATCH_QUEUE_PRIORITY_HIGH:         .userInitiated
//        * DISPATCH_QUEUE_PRIORITY_DEFAULT:      .default
//        * DISPATCH_QUEUE_PRIORITY_LOW:          .utility
//        * DISPATCH_QUEUE_PRIORITY_BACKGROUND:   .background
       
//        DispatchQueue的默认初始化方法创建的就是一个同步队列，如果要创建并发的队列，在attributes中声明concurrent。
        
        // 同步队列
        let serialQueue = DispatchQueue(label: "queuename")
        
        // 并发队列
        let concurrentQueue = DispatchQueue(label: "queuename", attributes: .concurrent)
        
//        推迟时间后执行
//        原先的dispatch_time_t现在由DispatchTime对象表示。可以用静态方法now获得当前时间，然后再通过加上一个DispatchTimeInterval枚举来获得一个需要延迟的时间。
        
        let delay = DispatchTime.now() + DispatchTimeInterval.seconds(60)DispatchQueue.main.asyncAfter(deadline: delay) {
            // 延迟执行
            
        }
            这里也可以直接加上一个秒数。
            
            let three = DispatchTime.now() + 3.0
            因为DispatchTime中自定义了+号。
            
            public func +(time: DispatchTime, seconds: Double) -> DispatchTime
            DispatchGroup
            如果想在dispatch_queue中所有的任务执行完成后再做某种操作可以使用DispatchGroup。原先的dispatch_group_t由现在的DispatchGroup对象代替。
            
            let group = DispatchGroup()
            
            let queueBook = DispatchQueue(label: "book")
            queueBook.async(group: group) {
                // 下载图书
            }
            let queueVideo = DispatchQueue(label: "video")
            queueVideo.async(group: group) {
                // 下载视频
            }
            
            group.notify(queue: DispatchQueue.main) {
                // 下载完成
            }
            DispatchGroup会在组里的操作都完成后执行notify。
            如果有多个并发队列在一个组里，我们想在这些操作执行完了再继续，调用wait
            
            group.wait()
            DispatchWorkItem
            使用DispatchWorkItem代替原来的dispatch_block_t。
            在DispatchQueue执行操作除了直接传了一个() -> Void类型的闭包外，还可以传入一个DispatchWorkItem。
            
            public func sync(execute workItem: DispatchWorkItem)
            
            public func async(execute workItem: DispatchWorkItem)
            DispatchWorkItem的初始化方法可以配置Qos和DispatchWorkItemFlags，但是这两个参数都有默认参数，所以也可以只传入一个闭包。
            
            public init(qos: DispatchQoS = default, flags: DispatchWorkItemFlags = default, block: @escaping @convention(block) () -> ())
            
            let workItem = DispatchWorkItem {
                // TODO:
            }
            DispatchWorkItemFlags枚举中assignCurrentContext表示QoS根据创建时的context决定。
            值得一提的是DispatchWorkItem也有wait方法，使用方式和group一样。调用会等待这个workItem执行完。
            
            let myQueue = DispatchQueue(label: "my.queue", attributes: .concurrent)
            let workItem = DispatchWorkItem {
                sleep(1)
                print("done")
            }
            myQueue.async(execute: workItem)
            print("before waiting")
            workItem.wait()
            print("after waiting")
            barrier
            假设我们有一个并发的队列用来读写一个数据对象。如果这个队列里的操作是读的，那么可以多个同时进行。如果有写的操作，则必须保证在执行写入操作时，不会有读取操作在执行，必须等待写入完成后才能读取，否则就可能会出现读到的数据不对。在之前我们用dipatch_barrier实现。
            现在属性放在了DispatchWorkItemFlags里。
            
            let wirte = DispatchWorkItem(flags: .barrier) {
                // write data}let dataQueue = DispatchQueue(label: "data", attributes: .concurrent)
                dataQueue.async(execute: wirte)
                信号量
                为了线程安全的统计数量，我们会使用信号量作计数。原来的dispatch_semaphore_t现在用DispatchSemaphore对象表示。
                初始化方法只有一个，传入一个Int类型的数。
                
                let semaphore = DispatchSemaphore(value: 5)
                
                // 信号量减一
                semaphore.wait()
                
                //信号量加一
                semaphore.signal()
                dispatch_once被废弃
                在swift 3中已经被废弃了。
                简单的建议就是一些初始化场景就用懒加载吧。
                
                // Examples of dispatch_once replacements with global or static constants and variables.
                // In all three, the initialiser is called only once.
                
                // Static properties (useful for singletons).
                class Object {
                    static let sharedInstance = Object()
                }
                
                // Global constant.
                let constant = Object()
                
                // Global variable.
                var variable: Object = {
                    let variable = Object()
                    variable.doSomething()
                    return variable
                }()


    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
