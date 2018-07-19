//  Copyright © 2017年 XLsn0w. All rights reserved.
import UIKit

///CoreAnimation官方文档
///https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html

/*
 animationWithKeyPath对应有哪些字符串
 [CABasicAnimation animationWithKeyPath:@"position"];

 position = 位置
 transform.scale = 比例缩放
 transform.scale.x = 宽的比例缩放
 transform.scale.y = 高的比例缩放
 transform.rotation.z = 以Z轴为中心旋转
 opacity = 透明度
 margin = 布局
 zPosition = 翻转
 backgroundColor = 背景颜色
 cornerRadius = 圆角
 borderWidth = 边框宽
 bounds = 大小
 contents = 内容
 contentsRect = 内容大小
 cornerRadius = 圆角
 frame = 大小位置
 hidden = 显示隐藏
 mask
 masksToBounds
 shadowColor = 阴影颜色
 shadowOffset = 阴影偏移
 shadowOpacity = 阴影透明度
 shadowRadius = 阴影圆角
 
 常用属性 duration : 动画的持续时间
 beginTime : 动画的开始时间
 repeatCount : 动画的重复次数
 autoreverses : 执行的动画按照原动画返回执行
 
 timingFunction : 控制动画的显示节奏系统提供五种值选择，分别是：
 
 kCAMediaTimingFunctionLinear 线性动画
 kCAMediaTimingFunctionEaseIn 先慢后快（慢进快出）
 kCAMediaTimingFunctionEaseOut 先块后慢（快进慢出）
 kCAMediaTimingFunctionEaseInEaseOut 先慢后快再慢
 kCAMediaTimingFunctionDefault 默认，也属于中间比较快
 delegate ： 动画代理。检测动画的执行和结束。
 
 - (void)animationDidStart:(CAAnimation *)anim;//开始动画
 - (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;//动画结束
 path：关键帧动画中的执行路径
 type ： 过渡动画的动画类型，系统提供了四种过渡动画。
 
 kCATransitionFade 渐变效果
 kCATransitionMoveIn 进入覆盖效果
 kCATransitionPush 推出效果
 kCATransitionReveal 揭露离开效果
 subtype : 过渡动画的动画方向
 
 kCATransitionFromRight 从右侧进入
 kCATransitionFromLeft 从左侧进入
 kCATransitionFromTop 从顶部进入
 kCATransitionFromBottom 从底部进入


 3.1：位移动画（CABaseAnimation）
 
 重要属性
 fromValue ： keyPath对应的初始值
 toValue   ： keyPath对应的结束值
 基础动画主要提供了对于CALayer对象中的可变属性进行简单动画的操作
 注意点: 如果fillMode=kCAFillModeForwards和removedOnComletion=NO
 那么在动画执行完毕后，图层会保持显示动画执行后的状态。但在实质上，图层的属性值还是动画执行前的初始值，并没有真正被改变。
 
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

