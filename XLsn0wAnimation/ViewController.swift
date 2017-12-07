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


 /* UIView Animation
    _wsView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:1.0f animations:^{
    _wsView.transform = CGAffineTransformMakeTranslation(100, 0);
    }];
    [UIView animateWithDuration:1.0f animations:^{
    CGAffineTransform transform1 = CGAffineTransformMakeRotation(M_PI);
    CGAffineTransform transform2 = CGAffineTransformScale(transform1, 0.5, 0.5);
    _wsView.transform = CGAffineTransformTranslate(transform2, -200, 0);
    }];
    [UIView animateWithDuration:1.0f animations:^{
    //反转
    _wsView.transform = CGAffineTransformInvert(CGAffineTransformMakeScale(11, 11));
    }];
    
    CGAffineTransformIdentity
    CGAffineTransform.identity

    CGAffineTransformMakeScale(2, 2)
    CGAffineTransform(scaleX: 2, y: 2)

    CGAffineTransformMakeTranslation(128, 128)
    CGAffineTransform(translationX: 128, y: 128)

    CGAffineTransformMakeRotation(CGFloat(M_PI))
    CGAffineTransform(rotationAngle: CGFloat(M_PI))
  */
    @IBAction func UIViewAnimation(_ sender: Any) {
        demoView.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 3.0) {
//            self.demoView.transform = CGAffineTransform(translationX: 128, y: 128)          ///平移
//            self.demoView.transform = CGAffineTransform(scaleX: 5, y: 5)                    ///缩放
//            self.demoView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))  ///旋转
            
//            self.demoView.transform = CGAffineTransformInvert(scaleX: 5, y: 5)
//            self.demoView.transform = CGAffineTransformTranslate(CGAffineTransform(scaleX: 5, y: 5), 120.0, 100)

        }
    }

    /// 关键帧动画
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
    
    ///基础动画
    @IBAction func xValue(_ sender: Any) {
        let xBasicAnimation = CABasicAnimation(keyPath:"position")
        xBasicAnimation.fromValue = NSValue(cgPoint: CGPoint(x: 10, y: 0))
        xBasicAnimation.toValue =   NSValue(cgPoint: CGPoint(x: 100, y: 0))
        xBasicAnimation.duration = 3.0
        xBasicAnimation.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")///names are `linear', `easeIn', `easeOut' and `easeInEaseOut' and `default'
        demoView.layer.add(xBasicAnimation, forKey: "positionAnimation")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } 
}

