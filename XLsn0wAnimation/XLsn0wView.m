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


- (UIImage*)draw_another_image_on_Image {///在UIImage上绘制另一个图像
    CGFloat width, height;
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
