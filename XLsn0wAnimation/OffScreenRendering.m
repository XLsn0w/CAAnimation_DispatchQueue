//
//  OffScreenRendering.m
//  XLsn0wAnimation
//
//  Created by HL on 2018/7/18.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "OffScreenRendering.h"

@implementation OffScreenRendering

/*
 1. 检测工具：Core Animation工具检测离屏渲染
 
 可以在Xcode->Open Develeper Tools->Instruments中找到(或者直接  cmd + i ),如下图
 
 Core Animation
 Core Animation 调试面板
 
 
 我们需要了解两个区域：
 
 1. 这里记录了实时的fps数值，有些地方是0是因为屏幕没有滑动
 
 2. 这是重中之重
 
 有过游戏经验的人也许对fps这个概念比较熟悉。我们知道任何屏幕总是有一个刷新率，比如iphone推荐的刷新率是60Hz，也就是说GPU每秒钟刷新屏幕60次，因此两次刷新之间的间隔为16.67ms。这段时间内屏幕内容保持不变，称为一帧(frame)，fps表示frames per second，也就是每秒钟显示多少帧画面。对于静止不变的内容，我们不需要考虑它的刷新率，但在执行动画或滑动时，fps的值直接反映出滑动的流畅程度。
 
 
 
 Color Blended Layers：正是用于检测哪里发生了图层混合，并用红色标记出来。因此我们需要尽可能减少看到的红色区域。一旦发现应该想法设法消除它。
 
 Color Hits Green and Misses Red：如果勾选这个选项，且当我们代码中有设置xxx.layer.shouldRasterize为YES，那么红色代表没有复用离屏渲染的缓存，绿色则表示复用了缓存。显然绿色越多越好，红色越少越好。我们当然希望能够复用。
 
 Color Copied Images：按照官方的说法，当图片的颜色格式GPU不支持的时候，Core Animation会拷贝一份数据让CPU进行转化。
 
 Color Immediately：默认情况下Core Animation工具以每毫秒10次的频率更新图层调试颜色，如果勾选这个选项则移除10ms的延迟。对某些情况需要这样，但是有可能影响正常帧数的测试。
 
 Color Misaligned Images：勾选此项，如果图片需要缩放则标记为黄色，如果没有像素对齐则标记为紫色。像素对齐我们已经在上面有所介绍。
 
 Color Offscreen-Rendered Yellow：用来检测离屏渲染的，如果显示黄色，表示有离屏渲染。当然还要结合Color Hits Green and Misses Red来看，是否复用了缓存。大部分情况下我们需要尽可能避免黄色的出现。离屏渲染可能会自动触发，也可以手动触发。以下情况可能会导致触发离屏渲染：
 
 1. 重写drawRect方法
 
 2. 有mask或者是阴影(layer.masksToBounds, layer.shadow*)，模糊效果也是一种mask
 
 3. layer.shouldRasterize = true
 
 前两者会自动触发离屏渲染，第三种方法是手动开启离屏渲染。
 
 
 
 Color Compositing Fast-Path Blue：用于标记由硬件绘制的路径，蓝色越多越好。如果不显示蓝色则表示使用了CPU渲染，绘制在了屏幕外，显示蓝色表示正常。
 
 Flash Updated Regions：用于标记发生重绘的区域, 当对图层重绘的时候回显示黄色，如果频繁发生则会影响性能。一个典型的例子是系统的时钟应用，绝大多数时候只有显示秒针的区域需要重绘。
 
 
 
 
 
 2. 为什么会有离屏渲染：
 
 高中物理应该学过显示器是如何显示图像的：需要显示的图像经过CRT电子枪以极快的速度一行一行的扫描，扫描出来就呈现了一帧画面，随后电子枪又会回到初始位置循环扫描，形成了我们看到的图片或视频。
 
 为了让显示器的显示跟视频控制器同步，当电子枪新扫描一行的时候，准备扫描的时发送一个水平同步信号(HSync信号)，显示器的刷新频率就是HSync信号产生的频率。然后CPU计算好frame等属性，将计算好的内容交给GPU去渲染，GPU渲染好之后就会放入帧缓冲区。然后视频控制器会按照HSync信号逐行读取帧缓冲区的数据，经过可能的数模转换传递给显示器，就显示出来了。具体的大家自行查找资料或询问相关专业人士，这里只参考网上资料做一个简单的描述。
 
 离屏渲染的代价很高，想要进行离屏渲染，首选要创建一个新的缓冲区，屏幕渲染会有一个上下文环境的一个概念，离屏渲染的整个过程需要切换上下文环境，先从当前屏幕切换到离屏，等结束后，又要将上下文环境切换回来。这也是为什么会消耗性能的原因了。
 
 由于垂直同步的机制，如果在一个 HSync 时间内，CPU 或者 GPU 没有完成内容提交，则那一帧就会被丢弃，等待下一次机会再显示，而这时显示屏会保留之前的内容不变。这就是界面卡顿的原因。
 
 
 
 3. 屏幕渲染的方式：
 
 OpenGL中，GPU屏幕渲染有两种方式:
 
 （1）On-Screen Rendering (当前屏幕渲染)
 
 指的是GPU的渲染操作是在当前用于显示的屏幕缓冲区进行。
 
 （2）Off-Screen Rendering (离屏渲染)
 
 指的是在GPU在当前屏幕缓冲区以外开辟一个缓冲区进行渲染操作。
 
 相比于当前屏幕渲染，离屏渲染的代价是很高的，主要体现在两个方面：
 
 （1）创建新缓冲区
 
 要想进行离屏渲染，首先要创建一个新的缓冲区。
 
 （2）上下文切换
 
 离屏渲染的整个过程，需要多次切换上下文环境：先是从当前屏幕（On-Screen）切换到离屏（Off-Screen），等到离屏渲染结束以后，将离屏缓冲区的渲染结果显示到屏幕上有需要将上下文环境从离屏切换到当前屏幕。而上下文环境的切换是要付出很大代价的。
 
 
 
 特殊的“离屏渲染”：CPU渲染
 
 如果我们重写了drawRect方法，并且使用任何Core Graphics的技术进行了绘制操作，就涉及到了CPU渲染。整个渲染过程由CPU在App内同步地完成，渲染得到的bitmap(位图)最后再交由GPU用于显示。
 
 
 
 4. 下面的情况或操作会引发离屏渲染：
 
 为图层设置遮罩（layer.mask）
 
 将图层的layer.masksToBounds / view.clipsToBounds属性设置为true
 
 将图层layer.allowsGroupOpacity属性设置为YES和layer.opacity小于1.0
 
 为图层设置阴影（layer.shadow *）。
 
 为图层设置layer.shouldRasterize=true
 
 具有layer.cornerRadius，layer.edgeAntialiasingMask，layer.allowsEdgeAntialiasing的图层
 
 文本（任何种类，包括UILabel，CATextLayer，Core Text等）。
 
 使用CGContext在drawRect :方法中绘制大部分情况下会导致离屏渲染，甚至仅仅是一个空的实现。
 
 
 
 5. 优化方案：
 
 苹果官方：
 
 iOS 9.0 之前UIimageView跟UIButton设置圆角都会触发离屏渲染。
 
 iOS 9.0 之后UIButton设置圆角会触发离屏渲染，而UIImageView里png图片设置圆角不会触发离屏渲染了，如果设置其他阴影效果之类的还是会触发离屏渲染的。
 
 圆角优化：
 
 方案1. 使用贝塞尔曲线UIBezierPath和Core Graphics框架画出一个圆角
 
 UIImageView *imageView=[[UIImageViewalloc]initWithFrame:CGRectMake(100,100,100,100)];
 
 imageView.image=[UIImageimageNamed:@"myImg"];
 
 //开始对imageView进行画图
 
 UIGraphicsBeginImageContextWithOptions(imageView.bounds.size,NO,1.0);
 
 //使用贝塞尔曲线画出一个圆形图
 
 [[UIBezierPathbezierPathWithRoundedRect:imageView.boundscornerRadius:imageView.frame.size.width]addClip];
 
 [imageViewdrawRect:imageView.bounds];
 
 imageView.image=UIGraphicsGetImageFromCurrentImageContext();
 
 //结束画图
 
 UIGraphicsEndImageContext();
 
 [self.viewaddSubview:imageView];
 
 
 
 方案2：使用CAShapeLayer和UIBezierPath设置圆角
 
 UIImageView *imageView=[[UIImageViewalloc]initWithFrame:CGRectMake(100,100,100,100)];
 
 imageView.image=[UIImageimageNamed:@"myImg"];
 
 UIBezierPath *maskPath=[UIBezierPathbezierPathWithRoundedRect:imageView.boundsbyRoundingCorners:UIRectCornerAllCornerscornerRadii:imageView.bounds.size];
 
 CAShapeLayer *maskLayer=[[CAShapeLayeralloc]init];
 
 //设置大小
 
 maskLayer.frame=imageView.bounds;
 
 //设置图形样子
 
 maskLayer.path=maskPath.CGPath;
 
 imageView.layer.mask=maskLayer;
 
 [self.viewaddSubview:imageView];
 
 ［说明］：
 
 CAShapeLayer继承于CALayer,可以使用CALayer的所有属性值；
 
 CAShapeLayer需要贝塞尔曲线配合使用才有意义（也就是说才有效果）
 
 使用CAShapeLayer(属于CoreAnimation)与贝塞尔曲线可以实现不在view的drawRect（继承于CoreGraphics走的是CPU,消耗的性能较大）方法中画出一些想要的图形
 
 CAShapeLayer动画渲染直接提交到手机的GPU当中，相较于view的drawRect方法使用CPU渲染而言，其效率极高，能大大优化内存使用情况。
 
 
 
 总的来说就是用CAShapeLayer的内存消耗少，渲染速度快，建议使用方案2。
 
 
 
 总结：
 
 避免图层混合
 
 1. 确保控件的opaque属性设置为true，确保backgroundColor和父视图颜色一致且不透明
 
 2. 如无特殊需要，不要设置低于1的alpha值
 
 3. 确保UIImage没有alpha通道
 
 避免临时转换
 
 1. 确保图片大小和frame一致，不要在滑动时缩放图片
 
 2. 确保图片颜色格式被GPU支持，避免劳烦CPU转换
*/

@end
