//
//  MyTestView.m
//  AnimationTest
//
//  Created by zhengqian.shi on 17/1/23.
//  Copyright © 2017年 QITMAC000263. All rights reserved.
//

#import "MyTestView.h"

@implementation MyTestView

- (instancetype)init
{
    self = [super init];
    return self;
}

- (void)setFrame:(CGRect)frame
{
#ifdef printLog
    NSLog(@"-----view setFrame");
    [super setFrame:frame];
    NSLog(@"-----view setFrame end");
#else
    [super setFrame:frame];
#endif
}

- (void)setCenter:(CGPoint)center
{
#ifdef printLog
    NSLog(@"-----view setCenter");
    [super setCenter:center];
    NSLog(@"-----view setCenter end");
#else
    [super setCenter:center];
#endif
}

- (void)setBounds:(CGRect)bounds
{
#ifdef printLog
    NSLog(@"-----view setBounds");
    [super setBounds:bounds];
    NSLog(@"-----view setBounds end");
#else
    [super setBounds:bounds];
#endif
}

- (CGPoint)center
{
#ifdef printLog
    NSLog(@"----view getCenter");
    CGPoint center = [super center];
    NSLog(@"----view getCenter end");
#else
    CGPoint center = [super center];
#endif
    return center;
}

- (CGRect)bounds
{
#ifdef printLog
    NSLog(@"----view getBounds");
    CGRect bounds = [super bounds];
    NSLog(@"----view getBounds end");
#else
    CGRect bounds = [super bounds];
#endif
    return bounds;
}

- (CGRect)frame
{
#ifdef printLog
    NSLog(@"----view getFrame");
    CGRect frame = [super frame];
    NSLog(@"----view getFrame end");
#else
    CGRect frame = [super frame];
#endif
    return frame;
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    /*
     * 三种返回值： null--无动画
     *            nil--隐式动画，默认0.25s
     *            实现了CAAction的动画对象，按其中内容执行动画
     *
     * 当_showAnimation为true时，若本身无动画，强制返回nil使其执行默认的隐式动画
     */
    
    id<CAAction> action = [super actionForLayer:layer forKey:event];
    
    if (_showAnimation && action == [NSNull null])
    {
        action = nil;
    }
    
    if (!_showAnimation && action == nil)
    {
        action = [NSNull null];
    }
    
    NSLog(@"%@",action);
    return action;
}

+(Class)layerClass
{
    return [MyTestLayer class];
}

@end
