
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

@end
