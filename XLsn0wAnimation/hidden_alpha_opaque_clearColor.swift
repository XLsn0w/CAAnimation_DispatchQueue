//
//  hidden_alpha_opaque_clearColor.swift
//  XLsn0wAnimation
//
//  Created by HL on 2018/7/16.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

import UIKit

class hidden_alpha_opaque_clearColor: UIView {

    
    let view = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))

    override func draw(_ rect: CGRect) {

        view.backgroundColor = UIColor.clear// 父视图还存在，只是颜色消失了，它仍有事件响应，子视图并没有受到影响
        view.alpha = 0///// 小于0.01,透明度就视为0了，也没有了响应事件，说明这个视图已经不存在了，子视图什么(显示与响应事件)的也都不存在了，类似第一种情况
        
        view.isHidden = true// 设置为true时 ，也没有了响应事件，说明这个视图已经不存在了，子视图什么(显示与响应事件)的也不存在了
        view.isOpaque = true///  opaque 不透明的、无光泽的 设置YES or NO 对子视图父视图并没有什么影响
        
//        [UIColor clearColor] --是将颜色设为透明.如果将控件backgroundColor设为[UIColor clearColor] ,则不会盖住其下面的控件视图.
//        控件的属性:alpha--表示控件的透明度.将其设为0,表示该控件自身透明了.与背景色的透明是两个概念,注意区分.
    }
    
}
