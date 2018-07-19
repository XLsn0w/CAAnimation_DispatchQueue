//
//  AppBetter.swift
//  XLsn0wAnimation
//
//  Created by ginlong on 2018/5/24.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

import UIKit

class AppBetter: NSObject {

}

/*
 
 1、tableView的优化
 iOS平台因为UIKit本身的特性，需要将所有的UI操作都放在主线程执行，所以有时候就习惯将一些线程安全性不确定的逻辑，以及它线程结束后的汇总工作等等放到了主线程，所以主线程包含大量计算、IO、绘制都有可能造成卡顿。
 
 · 可以通过监控runLoop监控监控卡顿，调用方法主要就是在kCFRunLoopBeforeSources和kCFRunLoopBeforeWaiting之间,还有kCFRunLoopAfterWaiting之后,也就是如果我们发现这两个时间内耗时太长,那么就可以判定出此时主线程卡顿.
 
 · 使用到CFRunLoopObserverRef,通过它可以实时获得这些状态值的变化
 
 · 监控后另外再开启一个线程,实时计算这两个状态区域之间的耗时是否到达某个阀值,便能揪出这些性能杀手.
 
 · 监控到了卡顿现场,当然下一步便是记录此时的函数调用信息,此处可以使用一个第三方Crash收集组件PLCrashReporter,它不仅可以收集Crash信息也可用于实时获取各线程的调用堆栈
 
 · 当检测到卡顿时,抓取堆栈信息,然后在客户端做一些过滤处理,便可以上报到服务器,通过收集一定量的卡顿数据后经过分析便能准确定位需要优化的逻辑
 
 · 设置正确的 reuseidentifer 以重用 cell
 
 · 尽量将 View 设置为不透明,包括 cell 本身（backgroundcolor默认是透明的），图层混合靠GPU去渲染,如果透明度设置为100%，那么GPU就会忽略下面所有的layer，节约了很多不必要的运算。模拟器上点击“Debug”菜单，然后选择“color Blended Layers”，会把所有区域分成绿色和红色,绿色的好,红色的性能差（经过混合渲染的），当然也有一些图片虽然是不透明的，但是也会显示红色，如果检查代码没错的话，一般就是图片自身的性质问题了，直接联系美工或后台解决就好了。除非必须要用GPU加载的，其他最好要用CPU加载，因为CPU一般不会百分百加载，可以通过CoreGraphics画出圆角
 
 · 有时候美工失误，图片大小给错了，引起不必要的图片缩放（可以找美工去改，当然也可以异步去裁剪图片然后缓存下来），还是使用Instrument的Color Misaligned Images，黄色表示图片需要缩放，紫色表示没有像素对齐。当然一般情况下图片格式不会给错，有些图片格式是GPU不支持的，就还要劳烦CPU去进行格式转换。还有可以通过Color Offscreen-Rendered Yellow来检测离屏渲染（就是把渲染结果临时保存，等到用的时候再取出，这样相对于普通渲染更消耗内存，使用maskToBounds、设置shadow，重写drawRect方法都会导致离屏渲染）
 避免渐变，cornerRadius在默认情况下，这个属性只会影响视图的背景颜色和 border，但是不会离屏绘制，不影响性能。不用clipsToBounds（过多调用GPU去离屏渲染），而是让后台加载图片并处理圆角，并将处理过的图片赋值给UIImageView。UIImageView 的圆角通过直接截取图片实现，圆角路径直接用贝塞尔曲线UIBezierPath绘制（人为指定路径之后就不会触发离屏渲染），UIGraphicsBeginImageContextWithOptions。UIView的圆角可以使用CoreGraphics画出圆角矩形，核心是CGContextAddArcToPoint 函数。它中间的四个参数表示曲线的起点和终点坐标，最后一个参数表示半径。调用了四次函数后，就可以画出圆角矩形。最后再从当前的绘图上下文中获取图片并返回，最后把这个图片插入到视图层级的底部。
 “Flash updated Regions”用于标记发生重绘的区域
 
 · 如果 row 的高度不相同,那么将其缓存下来
 
 · 如果 cell 显示的内容来自网络,那么确保这些内容是通过异步下载
 
 · 使用 shadowPath 来设置阴影，图层最好不要使用阴影,阴影会导致离屏渲染(在进入屏幕渲染之前,还看不到的时候会再渲染一次,尽量不要产生离屏渲染)
 
 · 减少 subview 的数量，不要去添加或移除view，要就显示，不要就隐藏
 
 · 在 cellForRowAtIndexPath 中尽量做更少的操作,最好是在别的地方算好，这个方法里只做数据的显示，如果需要做一些处理,那么最好做一次之后将结果储存起来.
 
 · 使用适当的数据结构来保存需要的信息,不同的结构会带来不同的操作代价
 使用,rowHeight , sectionFooterHeight 和 sectionHeaderHeight 来设置一个恒定高度 , 而不是从代理(delegate)中获取
 
 · cell做数据绑定的时候，最好在willDisPlayCell里面进行，其他操作在cellForRowAtIndexPath，因为前者是第一页有多少条就执行多少次，后者是第一次加载有多少个cell就执行多少次，而且调用后者的时候cell还没显示
 
 · 读取文件,写入文件,最好是放到子线程,或先读取好,在让tableView去显示
 
 · tableView滚动的时候,不要去做动画(微信的聊天界面做的就很好,在滚动的时候,动态图就不让他动,滚动停止的时候才动,不然可能会有点影响流畅度)。在滚动的时候加载图片，停止拖拽后在减速过程中不加载图片，减速停止后加载可见范围内图片
 
 2、优化tableViewCell高度
 · 一种是针对所有 Cell 具有固定高度的情况，通过：self.tableView.rowHeight = 88;
 指定了一个所有 cell 都是 88 高度的 UITableView，对于定高需求的表格，强烈建议使用这种（而非下面的）方式保证不必要的高度计算和调用。
 
 · 另一种方式就是实现 UITableViewDelegate 中的：heightForRowAtIndexPath:需要注意的是，实现了这个方法后，rowHeight 的设置将无效。所以，这个方法适用于具有多种 cell 高度的 UITableView。
 
 · iOS7之后出了了estimatedRowHeight，面对不同高度的cell，只要给一个预估的值就可以了，先给一个预估值，然后边滑动边计算，但是缺点就是
 
 ·· 设置估算高度以后，tableView的contentSize.height是根据cell高度预估值和cell的个数来计算的，导致导航条处于很不稳定的状态，因为contentSize.height会逐渐由预估高度变为实际高度，很多情况下肉眼是可以看到导航条跳跃的
 ·· 如果是设计不好的上拉加载或下拉刷新，有可能使表格滑动跳跃
 ·· 估算高度设计初衷是好的，让加载速度更快，但是损失了流畅性，与其损失流畅性，我宁愿让用户加载界面的时候多等那零点几秒
 
 · iOS8 WWDC 中推出了 self-sizing cell 的概念，旨在让 cell 自己负责自己的高度计算，使用 frame layout 和 auto layout 都可以享受到：
 
 ·· self.tableView.estimatedRowHeight = 213;
 self.tableView.rowHeight = UITableViewAutomaticDimension;
 如果不加上估算高度的设置，自动算高就失效了
 ·· 这个自动算高在 push 到下一个页面或者转屏时会出现高度特别诡异的情况，不过现在的版本修复了。
 
 · 相同的代码在 iOS7 和 iOS8 上滑动顺畅程度完全不同，iOS8 莫名奇妙的卡。很大一部分原因是 iOS8 上的算高机制大不相同,从 WWDC 也倒是能找到点解释，cell 被认为随时都可能改变高度（如从设置中调整动态字体大小），所以每次滑动出来后都要重新计算高度。
 
 ·· dequeueReusableCellWithIdentifier:forIndexPath: 相比不带 “forIndexPath” 的版本会多调用一次高度计算
 ·· iOS7 计算高度后有”缓存“机制，不会重复计算；而 iOS8 不论何时都会重新计算 cell 高度
 
 · 使用 UITableView+FDTemplateLayoutCell（百度知道负责人孙源） 无疑是解决算高问题的最佳实践之一，既有 iOS8 self-sizing 功能简单的 API，又可以达到 iOS7 流畅的滑动效果，还保持了最低支持 iOS6
 
 · FDTemplateLayoutCell 的高度预缓存是一个优化功能，利用RunLoop空闲时间执行预缓存任务计算，当用户正在滑动列表时显然不应该执行计算任务影响滑动体验。
 
 ·· 当用户正在滑动 UIScrollView 时，RunLoop 将切换到 UITrackingRunLoopMode 接受滑动手势和处理滑动事件（包括减速和弹簧效果），此时，其他 Mode （除 NSRunLoopCommonModes 这个组合 Mode）下的事件将全部暂停执行，来保证滑动事件的优先处理，这也是 iOS 滑动顺畅的重要原因
 ·· 注册 RunLoopObserver 可以观测当前 RunLoop 的运行状态，并在状态机切换时收到通知：
 
 RunLoop开始
 RunLoop即将处理Timer
 RunLoop即将处理Source
 RunLoop即将进入休眠状态
 RunLoop即将从休眠状态被事件唤醒
 RunLoop退出
 
 ·· 分解成多个RunLoop Source任务，假设列表有 20 个 cell，加载后展示了前 5 个，那么开启估算后 table view 只计算了这 5 个的高度，此时剩下 15 个就是“预缓存”的任务，而我们并不希望这 15 个计算任务在同一个 RunLoop 迭代中同步执行，这样会卡顿 UI，所以应该把它们分别分解到 15 个 RunLoop 迭代中执行，这时就需要手动向 RunLoop 中添加 Source 任务（由应用发起和处理的是 Source 0 任务）
 
 3、谈谈内存的优化和注意事项（使用Instrument工具的CoreAnimation、GPU Driver、I/O操作，检查fps数值）
 · 重用问题：比如UITableViewCell、UICollectionViewCell、UITableViewHeaderFooterViews等设置正确的reuseIdentifier，充分重用
 
 · 懒加载控件、页面：对于不是立刻使用的数据，都应该使用延迟加载的方式，比如网络连接失败的提示界面，可能一直都用不到
 
 · 使用Autorelease Pool：在某些循环创建临时变量处理数据时，自动释放池以保证能及时释放内存
 
 · 不要使用太多的xib/storyboard：载入时会将其内部的图片在内的所有资源载入内存，即使未来很久才会需要使用，相对于纯代码写的延迟加载，在性能和内存上就差了很多
 
 · 数据缓存：对于cell的行高要缓存起来，使用reloadData效率也极高，对于网络数据，不需要每次都请求的，应该缓存起来，可以写入数据库，也可以通过plist文件存储
 
 · 选择正确的数据结构：针对不同的业务场景选择最合适的数据结构是写出高效代码的基础
 
 数组：有序的一组值，使用索引查询起来很快，使用值查询的很慢，插入/删除 很慢
 字典：存储键值对对，用键查找比较快
 集合：无序的一组值，用值来查找很快，插入/删除很快
 
 · gzip/zip压缩：当从服务器下载相关附件时，可以通过 zip压缩后再下载，使得内存更小，下载速度也更快
 
 · 重大开销对象：一些objects的初始化很慢，比如NSDateFormatter和 NSCalendar，但是又无可避免的需要使用，通常作为属性存储起来，避免反复使用
 
 · 避免反复处理数据：需要应用需要从服务器加载数据，常为JSON或者XML格式的数据，在服务器端或者客户端使用相同的数据结构很重要
 
 · 选择图片时，要对图片进行压缩处理，根据不同的情况选择不同的图片加载方式，-imageNamed:读取到内存后会缓存下来，适合图片资源较小，使用很频繁的图片；-initWithContentsOfFiles:仅加载图片而不缓存，适合较大的图片。若是collectionView中使用大量图片的时候，可以用UIVIew.layer.contents=(__bridge id _Nullable)(model.clipedImage.CGImage)；这样就更轻量级一些
 
 · 当然有时候也会用到一些第三方，比如在使用UICollectionView和UITableView的时候，Facebook有一个框架叫AsyncDisplayKit，这个库就可以很好地提升滚动时流畅性以及图片异步下载功能（不支持sb和autoLayout，需要手动进行约束设置），AsyncDisplayKit用相关node类，替换了UIView和它的子类,而且是线程安全的。它可以异步解码图片，调整图片大小以及对图片和文本进行渲染，把这些操作都放到子线程，滑动的时候就流畅许多。我认为这个库最方便的就是实现图片异步解码。UIImage显示之前必须要先解码完成，而且解码还是同步的。尤其是在UICollectionView/UITableView 中使用 prototype cell显示大图，UIImage的同步解码在滚动的时候会有明显的卡顿。另外一个很吸引人的点是AsyncDisplayKit可以把view层次结构转成layer。因为复杂的view层次结构开销很大，如果不需要view特有的功能（例如点击事件），就可以使用AsyncDisplayKit 的layer backing特性从而获得一些额外的提升。当然这个库还处于开发阶段，还有一些地方地方有待完善，比如不支持缓存，我要使用这个库的时候一般是结合Alamofire和AlamofireImage实现图片的缓存
 
 */
