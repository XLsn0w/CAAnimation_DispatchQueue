//
//  DrawUIImage.m
//  XLsn0wAnimation
//
//  Created by HL on 2018/7/18.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "DrawUIImage.h"

@implementation DrawUIImage

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 
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
