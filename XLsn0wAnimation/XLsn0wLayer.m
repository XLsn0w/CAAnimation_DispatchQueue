
//
//  XLsn0wLayer.m
//  XLsn0wAnimation
//
//  Created by HL on 2018/7/17.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "XLsn0wLayer.h"

@implementation XLsn0wLayer

+ (Class)layerClass {
    return [XLsn0wLayer class];
}

- (void)setBounds:(CGRect)bounds {
    NSLog(@"----layer setBounds");
    [super setBounds:bounds];
    NSLog(@"----layer setBounds end");
}

/* 以下参考官方api注释 */
/* presentationLayer
 * 返回一个layer的拷贝，如果有任何活动动画时，包含当前状态的所有layer属性
 * 实际上是逼近当前状态的近似值。
 * 尝试以任何方式修改返回的结果都是未定义的。
 * 返回值的sublayers 、mask、superlayer是当前layer的这些属性的presentationLayer
 */
- (nullable instancetype)presentationLayer {
    return [XLsn0wLayer class];
}

/* modelLayer
 * 对presentationLayer调用，返回当前模型值。
 * 对非presentationLayer调用，返回本身。
 * 在生成表示层的事务完成后调用此方法的结果未定义。
 */
- (instancetype)modelLayer {
    return [XLsn0wLayer class];
}
   
//从注释不难看出，这个presentationLayer即是我们看到的屏幕上展示的状态，而modelLayer就是我们设置完立即生效的真实状态，我们动画开始后延迟0.1s分别打印layer，layer.presentationLayer，layer.modelLayer和layer.presentationLayer.modelLayer :
//
//明显，layer.presentationLayer是动画当前状态的值，而layer.modelLayer 和 layer.presentationLayer.modelLayer 都是layer本身。(关于modelLayer注释中两句话的区别还请各位指教~)
//
//到这里，CALayer动画的原理基本清晰了，当有动画加入时，presentationLayer会不断的(从按某种插值或逼近得到的动画路径上)取值来进行展示，当动画结束被移除时则取modelLayer的状态展示。这也是为什么我们用CABasicAnimation时，设定当前值为fromValue时动画执行结束又会回到起点的原因，实际上动画结束并不是回到起点而是到了modelLayer的位置。
//
//虽然我们可以使用fillMode控制它结束时保持状态，但这种方法在动画执行完之后并没有将动画从渲染树中移除(因为我们需要设置animation.removedOnCompletion = NO才能让fillMode生效)。如果我们想让动画停在终点，更合理的办法是一开始就将layer设置成终点状态，其实前文提到的UIView的block动画就是这么做的。


@end
