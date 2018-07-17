
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

@end
