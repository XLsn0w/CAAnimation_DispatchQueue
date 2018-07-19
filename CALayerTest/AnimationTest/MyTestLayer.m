//
//  MyTestLayer.m
//  AnimationTest
//
//  Created by zhengqian.shi on 17/1/23.
//  Copyright © 2017年 QITMAC000263. All rights reserved.
//

#import "MyTestLayer.h"

@implementation MyTestLayer

- (instancetype)init
{
    self = [super init];
    return self;
}

- (void)setFrame:(CGRect)frame
{
#ifdef printLog
    NSLog(@"-----layer setFrame");
    [super setFrame:frame];
    NSLog(@"-----layer setFrame end");
#else
    [super setFrame:frame];
#endif
}

- (void)setPosition:(CGPoint)position
{
#ifdef printLog
    NSLog(@"-----layer setPosition");
    [super setPosition:position];
    NSLog(@"-----layer setPosition end");
#else
    [super setPosition:position];
#endif
}

- (void)setBounds:(CGRect)bounds
{
#ifdef printLog
    NSLog(@"-----layer setBounds");
    [super setBounds:bounds];
    NSLog(@"-----layer setBounds end");
#else
    [super setBounds:bounds];
#endif
}

- (CGPoint)position
{
#ifdef printLog
    NSLog(@"----layer getPosition");
    CGPoint position = [super position];
    NSLog(@"----layer getPosition end");
#else
    CGPoint position = [super position];
#endif
    return position;
}

- (CGRect)bounds
{
#ifdef printLog
    NSLog(@"----layer getBounds");
    CGRect bounds = [super bounds];
    NSLog(@"----layer getBounds end");
#else
    CGRect bounds = [super bounds];
#endif
    return bounds;
}

- (CGRect)frame
{
#ifdef printLog
    NSLog(@"----layer getFrame");
    CGRect frame = [super frame];
    NSLog(@"----layer getFrame end");
#else
    CGRect frame = [super frame];
#endif
    return frame;
}

@end
