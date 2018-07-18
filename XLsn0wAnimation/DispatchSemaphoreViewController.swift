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
