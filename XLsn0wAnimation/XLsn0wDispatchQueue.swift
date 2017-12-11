//
//  XLsn0wDispatchQueue.swift
//  XLsn0wAnimation
//
//  Created by golong on 2017/12/11.
//  Copyright © 2017年 XLsn0w. All rights reserved.
//

import UIKit

class XLsn0wDispatchQueue: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let queue = DispatchQueue(label: "xlsn0w")

//        QoS是个基于具体场景的枚举类型，在初始队列时，可以提供合适的QoS参数来得到相应的权限，如果没有指定QoS，那么初始方法会使用队列提供的默认的QoS值
//        QoS等级(QoS classes)，从前到后，优先级从高到低:
//        userInteractive
//        userInitiated
//        default
//        utility
//        background
//        unspecified
        
        let queue = DispatchQueue(label: "xlsn0w",
                                  qos: DispatchQoS.unspecified,
                                  attributes:.concurrent)
        
        queue.async {
            ///code
        }
        
        
        print("DispatchQueue.main.sync: befor", Thread.current)
        DispatchQueue.global().async {
            print("DispatchQueue.global().async: Time task", Thread.current, "\n --: 耗时操作在后台线程中执行！")
            
            DispatchQueue.main.async {
                print("DispatchQueue.main.async: update UI", Thread.current, "\n --: 耗时操作执行完毕后在主线程更新 UI 界面！")
            }
        }
        print("DispatchQueue.main.sync: after", Thread.current)
        

        
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
