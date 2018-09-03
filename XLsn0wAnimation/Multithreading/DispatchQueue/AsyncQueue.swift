//
//  AsyncQueue.swift
//  XLsn0wAnimation
//
//  Created by XLsn0w on 2018/9/3.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

//import UIKit
//
//class AsyncQueue: NSObject {
//
//}


/*
 
 1. async 会开启新的线程
 2. sync  则不会
 3. Serial queue     任务按顺序执行
 4. Concurrent queue 任务同时执行
 
 在iOS开发中,main queue主线程有称为UI线程,用来处理UI事件.
 其他耗时操作通常放在子线程中进行,比如网络请求等.通过网络请求回来的数据通常需要用UI展示,这是就需要从子线程回到主线程,进而就产生了线程间通信.
 
 #pragma mark - 线程间通信
 - (void)GCDCommunication {
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
 // 全局并发队列中异步请求数据
 NSArray *dataArray = @[@"我是第1条数据",@"我是第2条数据",@"我是第3条数据"];
 for (NSString *dataStr in dataArray) {
 NSLog(@"%@---我当前的线程是:%@",dataStr,[NSThread currentThread]);
 }
 // 请求数据完成,回到主线程刷新UI
 dispatch_async(dispatch_get_main_queue(), ^{
 NSLog(@"我当前的线程是:%@",[NSThread currentThread]);
 });
 });
 }
 

 */
