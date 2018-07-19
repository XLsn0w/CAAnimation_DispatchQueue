//
//  DrawUIImage.m
//  XLsn0wAnimation
//
//  Created by HL on 2018/7/18.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "DrawUIImage.h"

@implementation DrawUIImage

// UIGraphicsGetCurrentContext - 视图绘制，必须在 drawRect 方法中！
- (void)drawRect:(CGRect)rect {
    
    // 1. 图形上下文 - 绘图函数都是一样的，如果选择不同的上下文，结果会绘制到不同的目标
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 给上下文添加矩形
    CGContextAddRect(ctx, CGRectMake(0, 0, 100, 100));
    
    // 设置颜色
    [[UIColor blueColor] set];
    
    // 让上下文绘制内容 - 填充 + 边线
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
}

 /*
 UIGraphicsBeginImageContext
 创建一个基于位图的上下文（context）,并将其设置为当前上下文(context)。方法声明如下：
 void UIGraphicsBeginImageContext(CGSizeMake(240，240));
 
 参数CGSizeMake(240，240)为新创建的位图上下文的大小。它同时是由UIGraphicsGetImageFromCurrentImageContext函数返回的图形大小。
 
 该函数的功能同UIGraphicsBeginImageContextWithOptions的功能相同，相当与UIGraphicsBeginImageContextWithOptions的opaque参数为NO,scale因子为1.0。
 方法申明如下：
 void UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale);
 size——同UIGraphicsBeginImageContext的CGSizeMake(240，240)
 opaque—透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
 scale—–缩放的比例
*/

-(UIImage *)imageFromColor:(UIColor*)color rect:(CGRect)rect{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(currentContext, [color CGColor]);
    CGContextFillRect(currentContext, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}




@end
