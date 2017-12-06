//
//  CABasicAnimationDemo.swift
//  XLsn0wAnimation
//
//  Created by golong on 2017/12/6.
//  Copyright © 2017年 XLsn0w. All rights reserved.
//

import UIKit
import Foundation

class CABasicAnimationDemo: NSObject {
    
    let demoView:UIView = UIView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
    
    func xyValueAnimation() -> Void {
        
//        CABasicAnimation *xBasicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        let xBasicAnimation = CABasicAnimation(keyPath:"position")
        
        xBasicAnimation.fromValue = NSValue(cgPoint: CGPoint(x: 10, y: 10))
        xBasicAnimation.toValue =   NSValue(cgPoint: CGPoint(x: 100, y: 10))
        xBasicAnimation.duration = 3.0
        xBasicAnimation.timingFunction = CAMediaTimingFunction(name: "kCAMediaTimingFunctionEaseIn")
        demoView.layer.add(xBasicAnimation, forKey: "positionAnimation")
    
        
//        anima.fromValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth/2-80+_wsView.frame.size.width/2, kScreenHeight/2-80+_wsView.frame.size.height/2)];
//
//        anima.toValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth/2-80+_wsView.frame.size.width/2-200, kScreenHeight/2+_wsView.frame.size.height/2-80)];
//        anima.duration = 1.0f;
//
//        anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//        [_wsView.layer addAnimation:anima forKey:@"positionAnimation"];
    }
    
    
    

}
