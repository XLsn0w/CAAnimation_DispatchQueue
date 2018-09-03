//
//  WebViewDelegateViewController.m
//  XLsn0wAnimation
//
//  Created by XLsn0w on 2018/9/3.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "WebViewDelegateViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSObjCModel.h"

@interface WebViewDelegateViewController ()

@end

//JSContext, JSContext是代表JS的执行环境，通过-evaluateScript:方法就可以执行一JS代码
//JSValue, JSValue封装了JS与ObjC中的对应的类型，以及调用JS的API等
//JSExport, JSExport是一个协议，遵守此协议，就可以定义我们自己的协议，在协议中声明的API都会在JS中暴露出来，才能调用

@implementation WebViewDelegateViewController

//ObjC与JS交互方式
//通过JSContext，我们有两种调用JS代码的方法：

//1、直接调用JS代码
//2、在ObjC中通过JSContext注入模型，然后调用模型的方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 通过模型调用方法，这种方式更好些。
    JSObjCModel *model  = [[JSObjCModel alloc] init];
    self.jsContext[@"OCModel"] = model;
    model.jsContext = self.jsContext;
    model.webView = self.webView;
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
