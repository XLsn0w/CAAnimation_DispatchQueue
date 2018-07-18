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

@end
