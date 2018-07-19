//
//  XLsn0wView.m
//  XLsn0wAnimation
//
//  Created by HL on 2018/7/18.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "XLsn0wView.h"

@implementation XLsn0wView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    id<CAAction> action = [super actionForLayer:layer forKey:event];
    return action;
}

- (void)drawUI {
    UIImage * srcImg =[UIImage imageNamed:@"videoHoldbg.png"];
    CGFloat width = srcImg.size.width;
    CGFloat height = srcImg.size.height;
    //开始绘制图片
    UIGraphicsBeginImageContext(srcImg.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    ////绘制Clip区域
    CGContextAddEllipseInRect(gc, CGRectMake(0, 0,100, 75)); //椭圆
    CGContextClosePath(gc);
    CGContextClip(gc);
    //坐标系转换
    //因为CGContextDrawImage会使用Quartz内的以左下角为(0,0)的坐标系
    CGContextTranslateCTM(gc, 0, height);
    CGContextScaleCTM(gc, 1, -1);
    CGContextDrawImage(gc, CGRectMake(0, 0, width, height), [srcImg CGImage]);
    //结束绘画
    UIImage *destImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView * view =[[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [view setImage:destImg];
}

- (UIImage *)draw_rect:(CGRect)rect {
    
    // 1. 开启图像上下文 － 可以异步执行！生成结果之后，在主线程更新UI
    // 输出的图像的 scale == 1，在 iPhone 7+ 上不清楚
    // UIGraphicsBeginImageContext(_imageView.bounds.size);
    // scale 设置为 0，会使用主屏幕的分辨率，一定记住用下面的方法 (240 * 128) => (720 * 384)
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    // 绘制内容
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    path.lineWidth = 2;
    [path stroke];
    
    // 5. 从图像上下文，获取绘制结果
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6. 关闭图像上下文
    UIGraphicsEndImageContext();
    
    return result;
}

// 1. 生成`图像`，设置给 imageView
- (UIImage *)drawDemo1:(CGRect)rect {
    
    // 1. 开启图像上下文 － 可以异步执行！生成结果之后，在主线程更新UI
    UIGraphicsBeginImageContext(rect.size);
    
    // 2. 图形上下文 - 绘图函数都是一样的，如果选择不同的上下文，结果会绘制到不同的目标
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 给上下文添加矩形
    CGContextAddRect(ctx, CGRectMake(0, 0, 100, 100));
    
    // 设置颜色
    [[UIColor blueColor] set];
    
    // 让上下文绘制内容 - 填充 + 边线
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    // 5. 从图像上下文，获取绘制结果
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6. 关闭图像上下文
    UIGraphicsEndImageContext();
    
    return result;
}


- (UIImage*)draw_another_image_on_Image {///在UIImage上绘制另一个图像
    CGFloat width = 0.0, height = 0.0;
    UIImage *inputImage;    // input image to be composited over new image as example
    
    // create a new bitmap image context at the device resolution (retina/non-retina)
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), YES, 0.0);
    
    // get context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // push context to make it current
    // (need to do this manually because we are not drawing in a UIView)
    UIGraphicsPushContext(context);
    
    // drawing code comes here- look at CGContext reference
    // for available operations
    // this example draws the inputImage into the context
    [inputImage drawInRect:CGRectMake(0, 0, width, height)];
    
    // pop context
    UIGraphicsPopContext();
    
    // get a UIImage from the image context- enjoy!!!
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // clean up drawing environment
    UIGraphicsEndImageContext();
    
    return outputImage;

}

//如果你想显示image，作为自定义view的一部分，你必须在view的drawRect:的方法中来绘制view。
//如果你想离屏渲染image（稍后绘制，或者把它保存到文件中），你必须创建一个bitmap image context。






@end
