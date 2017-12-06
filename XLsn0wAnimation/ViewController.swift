//
//  ViewController.swift
//  XLsn0wAnimation
//
//  Created by golong on 2017/12/6.
//  Copyright © 2017年 XLsn0w. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//    var demoView:UIView?
     let demoView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        demoView.backgroundColor = .red
        self.view.addSubview(demoView)
        

        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func xValue(_ sender: Any) {
        let xBasicAnimation = CABasicAnimation(keyPath:"position")
        xBasicAnimation.fromValue = NSValue(cgPoint: CGPoint(x: 10, y: 0))
        xBasicAnimation.toValue =   NSValue(cgPoint: CGPoint(x: 100, y: 0))
        xBasicAnimation.duration = 3.0
        xBasicAnimation.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")///names are `linear', `easeIn', `easeOut' and `easeInEaseOut' and `default'
        demoView.layer.add(xBasicAnimation, forKey: "positionAnimation")
    }
    
}

