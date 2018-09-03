//
//  JSObjCModel.h
//  XLsn0wAnimation
//
//  Created by XLsn0w on 2018/9/3.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

//通过注入模型的方式交互
//首先，我们需要先定义一个协议，而且这个协议必须要遵守JSExport协议。

@protocol JavaScriptObjectiveCDelegate <JSExport>

// JS调用此方法来调用OC的系统相册方法
- (void)callSystemCamera;
// 在JS中调用时，函数名应该为showAlertMsg(arg1, arg2)
// 这里是只两个参数的。
- (void)showAlert:(NSString *)title msg:(NSString *)msg;
// 通过JSON传过来
- (void)callWithDict:(NSDictionary *)params;
// JS调用Oc，然后在OC中通过调用JS方法来传值给JS。
- (void)jsCallObjcAndObjcCallJsWithDict:(NSDictionary *)params;

@end

@interface JSObjCModel : NSObject <JavaScriptObjectiveCDelegate>

@property (nonatomic, weak) JSContext *jsContext;
@property (nonatomic, strong) WKWebView *webView;

@end
