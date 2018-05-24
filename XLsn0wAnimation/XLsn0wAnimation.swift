//  Copyright © 2017年 XLsn0w. All rights reserved.
/*
 CALayer Animatable Properties
 我们可以通过animationWithKeyPath键值对的方式来改变动画
 
 keyPath的值：
 
 anchorPoint
 
 backgroundColor
 
 backgroundFilters
 
 borderColor
 
 borderWidth
 
 bounds
 
 compositingFilter
 
 contents
 
 contentsRect
 
 cornerRadius
 
 doubleSided
 
 filters
 
 frame
 
 hidden
 
 mask
 
 masksToBounds
 
 opacity
 
 position
 
 shadowColor
 
 shadowOffset
 
 shadowOpacity
 
 shadowRadius
 
 sublayers
 
 sublayerTransform
 
 transform
 
 zPosition

 */

import UIKit

class XLsn0wAnimation: UIViewController, CAAnimationDelegate {

    ///objc代码直接在swift代码注释中 双语言动画总结
    let demoView = UIView(frame: CGRect(x: 20, y: 20, width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        demoView.backgroundColor = .blue
        view.addSubview(demoView)
    }

 /* UIView Animation

    CGAffineTransform transform2 = CGAffineTransformScale(transform1, 0.5, 0.5);
    demoView.transform = CGAffineTransformTranslate(transform2, -200, 0);

    demoView.transform = CGAffineTransformInvert(CGAffineTransformMakeScale(11, 11));
 
    
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
            self.demoView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))  ///旋转
        }
    }

//    EaseInOut  //动画由慢变快再变慢
//    EaseIn     //动画由慢变快
//    EaseOut    //动画由快变慢
//    Linear     //匀速动画
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
        demoView.layer.add(valuesAnimation, forKey: nil)
    }
    
    ///基础动画
    @IBAction func xValue(_ sender: Any) {
        let xBasicAnimation = CABasicAnimation(keyPath:"position")
        xBasicAnimation.fromValue = NSValue(cgPoint: CGPoint(x: 100, y: 100))
        xBasicAnimation.toValue =   NSValue(cgPoint: CGPoint(x: 100, y: 330))
        xBasicAnimation.duration = 3.0
        xBasicAnimation.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")///names are `linear', `easeIn', `easeOut' and `easeInEaseOut' and `default'
        
        ///加上如下两行代码，那么在动画执行完毕后，图层会保持显示动画执行后的状态。
        ///但在实质上，图层的属性值还是动画执行前的初始值，并没有真正被改变。
        ///写在layer.add之前生效
        xBasicAnimation.fillMode = kCAFillModeForwards;
        xBasicAnimation.isRemovedOnCompletion = false;
        
        demoView.layer.add(xBasicAnimation, forKey: nil)///key可以不设置 传nil
    }
    
    ///CATransition 翻转动画
    /*
    types include
    * `fade', `moveIn', `push' and `reveal' API包括4中动画类型   私有api不介绍了
     
     kCATransitionFade    //淡入淡出（默认）
     
     kCATransitionMoveIn  //移入
     
     kCATransitionPush    //压入
     
     kCATransitionReveal  //渐变

    */
    @IBAction func TransitionAnimation(_ sender: Any) {
        let transitionAnimation = CATransition()
//        transitionAnimation.type = kCATransitionFade;//设置动画的类型
//        transitionAnimation.type = kCATransitionMoveIn;
        transitionAnimation.type = kCATransitionPush;
//        transitionAnimation.type = kCATransitionReveal;
        transitionAnimation.duration = 5.0;
        transitionAnimation.subtype = kCATransitionFromTop; //设置动画的方向
        demoView.layer.add(transitionAnimation, forKey: nil)
    }
    
    ///CAAnimationGroup
    @IBAction func animationGroup(_ sender: Any) {
//        //缩放动画
//        CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        let scaleAnimation = CABasicAnimation(keyPath: "zPosition")
        scaleAnimation.fromValue = NSValue(cgPoint: CGPoint(x: 2, y:2))
        scaleAnimation.toValue =   NSValue(cgPoint: CGPoint(x: 4, y:8))
//        anima2.fromValue = [NSNumber numberWithFloat:0.8f];
//        anima2.toValue = [NSNumber numberWithFloat:2.0f];

//        //旋转动画
//        CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = NSValue(cgPoint: CGPoint(x: 50, y:50))
//        anima3.toValue = [NSNumber numberWithFloat:M_PI*4];

        ///关键帧动画
//      CAKeyframeAnimation *anima1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        let valuesAnimation = CAKeyframeAnimation(keyPath: "position")
        
//        NSValue *value0 = [NSValue valueWithCGPoint:CGPointMake(0, 100)];
        valuesAnimation.values = [NSValue(cgPoint: CGPoint(x: 100, y:100)),
                                  NSValue(cgPoint: CGPoint(x: 200, y:200)),
                                  NSValue(cgPoint: CGPoint(x: 150, y:400))]
        
//      动画组
//      CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
        let groupAnimation = CAAnimationGroup()
//        groupAnimation.animations = [NSArray arrayWithObjects:anima1,anima2,anima3, nil];
        groupAnimation.animations = [scaleAnimation,
                                     rotationAnimation,
                                     valuesAnimation]
        groupAnimation.duration = 5.0;
//        [_wsView.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
        demoView.layer.add(groupAnimation, forKey: nil)
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } 
}

