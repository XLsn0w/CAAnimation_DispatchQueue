//
//  ViewController.swift
//  XLsn0wAnimation
//
//  Created by golong on 2017/12/6.
//  Copyright © 2017年 XLsn0w. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {

//    var demoView:UIView?
     let demoView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        demoView.backgroundColor = .red
        self.view.addSubview(demoView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func frameAction(_ sender: Any) {
        
        ///CABasicAnimation     就是values 只有2个NSValue值
        ///CAKeyframeAnimation  就是values 至少是3个NSValue值
        
//      CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        let valuesAnimation = CAKeyframeAnimation(keyPath: "position")
        
//      NSValue *value0 = [NSValue valueWithCGPoint:CGPointMake(0, kScreenHeight/2-100)];
        let value0 = NSValue(cgPoint : CGPoint(x: 100, y: 100))
        let value1 = NSValue(cgPoint : CGPoint(x: 300, y: 350))
        let value2 = NSValue(cgPoint : CGPoint(x: 100, y: 650))
        
//      anima.values = [NSArray arrayWithObjects:value0,value1,value2,value3, nil];
        valuesAnimation.values = [value0, value1, value2]
        
        valuesAnimation.duration = 2.0;
        
//      anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];//设置动画的节奏
        valuesAnimation.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")
        
//      anima.delegate = self;//设置代理，可以检测动画的开始和结束
        valuesAnimation.delegate = self as CAAnimationDelegate
        
//      [demoView.layer addAnimation:anima forKey:@"keyFrameAnimation"];
        demoView.layer.add(valuesAnimation, forKey: "keyFrameAnimation")
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

