//
//  WKWebViewController.m
//  XLsn0wAnimation
//
//  Created by HL on 2018/7/19.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface WKWebViewController () <WKNavigationDelegate,UIScrollViewDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation WKWebViewController


//添加KVO监听

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    //加载进度值
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (object == self.webView) {
            
            [self.progressView setAlpha:1.0f];
            
            [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
            
            if(self.webView.estimatedProgress >= 1.0f) {
                
                [UIView animateWithDuration:0.5f
                 
                                      delay:0.3f
                 
                                    options:UIViewAnimationOptionCurveEaseOut
                 
                                 animations:^{
                                     
                                     [self.progressView setAlpha:0.0f];
                                     
                                 }
                 
                                 completion:^(BOOL finished) {
                                     
                                     [self.progressView setProgress:0.0f animated:NO];
                                     
                                 }];
                
            }
            
        }
        
        else
            
        {
            
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
            
        }
        
    }
    
    //网页title
    
    else if ([keyPath isEqualToString:@"title"])
        
    {
        
        if (object == self.webView)
            
        {
            
            self.navigationItem.title = self.webView.title;
            
        }
        
        else
            
        {
            
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
            
        }
        
    }
    
    else
        
    {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        
    }
    
    
    
}



- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation

{
    
    self.progressView.hidden = NO;
    
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    
    [self.view bringSubviewToFront:self.progressView];
    
}



- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    //加载失败同样需要隐藏progressView
    
    self.progressView.hidden = YES;
    
    [self.webView removeFromSuperview];
    
//    [self.view addSubview:self.blankPageView];///添加空白页
    
}

//点击跳转新界面

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler

{
    
    NSString * strRequest =[navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    
    
    
    if([strRequest isEqualToString:@"about:blank"]) {//主页面加载内容
        
        decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
        
    } else {//截获页面里面的链接点击
        
        decisionHandler(WKNavigationActionPolicyAllow);//跳转
        
    }
    
}


- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        
        //初始化偏好设置属性：preferences
        
        config.preferences = [[WKPreferences alloc]init];
        
        //The minimum font size in points default is 0;
        
        config.preferences.minimumFontSize = 0;
        
        //是否支持JavaScript
        
        config.preferences.javaScriptEnabled = YES;
        
        //不通过用户交互，是否可以打开窗口
        
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        
        //适应屏幕
        
        NSString *js_string = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:js_string injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        
        WKUserContentController * wkUController =[[WKUserContentController alloc]init];
        
        [wkUController addUserScript:wkUserScript];
        
        config .userContentController =wkUController;
        
        
        
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width,  UIScreen.mainScreen.bounds.size.height) configuration:config];
        
        _webView.scrollView.delegate = self;
        
        _webView.backgroundColor = [UIColor whiteColor];
        
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        
        [self.view addSubview:_webView];
        
    }
    
    return _webView;
    
}

-(UIProgressView *)progressView

{
    
    if (!_progressView) {
        
        _progressView =[[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 1)];
        
        _progressView.backgroundColor = [UIColor whiteColor];
        
        _progressView.progressTintColor= [UIColor redColor];//设置已过进度部分的颜色
        
        _progressView.trackTintColor= [UIColor lightGrayColor];//设置未过进度部分的颜色
        
        //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        
        [self.view addSubview:_progressView];
        
    }
    
    return _progressView;
    
}



//移除监听者

- (void)dealloc {
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    [self.webView removeObserver:self forKeyPath:@"title"];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view .backgroundColor =[UIColor whiteColor];
    
    
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    config.preferences = [[WKPreferences alloc] init];
    
    config.preferences.minimumFontSize = 10;
    
    config.preferences.javaScriptEnabled = YES;
    
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    config.userContentController = [[WKUserContentController alloc] init];
    
    config.processPool = [[WKProcessPool alloc] init];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                    
                                      configuration:config];
    
    //记得实现对应协议,不然方法不会实现.
    
    self.webView.UIDelegate = self;
    
    self.webView.navigationDelegate =self;
    
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.188/index1.html"]]];
    
    //加载url
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
    //添加kvo监听，获得页面title和加载进度值
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    
    
    // **************** 此处划重点 **************** //
    
    //添加注入js方法, oc与js端对应实现
    
    [config.userContentController addScriptMessageHandler:self name:@"collectSendKey"];
    
    
    [config.userContentController addScriptMessageHandler:self name:@"collectIsLogin"];
    
    
    //js端代码实现实例(此处为js端实现代码给大家粘出来示范的!!!):
    
    //window.webkit.messageHandlers.collectSendKey.postMessage({body: 'goodsId=1212'});
    
    
    
}

#pragma mark - WKScriptMessageHandler

//实现js注入方法的协议方法



//2.浏览web页面,传递值给js界面,js界面通过值判断处理逻辑.

//使用场景: 浏览web页面商品,加入购物车,js通过oc原生传递过去的userId是否为空,来判断当前app是否登录,未登录,跳转原生界面登录,已登录,则直接加入购物车

#pragma mark ---------  WKNavigationDelegate  --------------

// 加载成功,传递值给js

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    //加载完成后隐藏progressView
    
    self.progressView.hidden = YES;
    
    
    
    //修改字体大小 300%
//    调用js中的方法，例如我们可以这样使用这个方法?
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'" completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        
        
    }];
    
    //修改字体颜色  #9098b8
    
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#222222'" completionHandler:nil];
    
//    oc调用js方法
//    - (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id,NSError *))completionHandler;
    

    //获取userId
    
    //传递userId给 js端
    
    NSString* userId = @"1";
    
    NSString* jsUserId;
    
    if (!userId) {
        jsUserId =@"";
    }else{
        jsUserId =userId;
    }
    
    //之所以给userId重新赋值,貌似是如果userId为空null 那么传给js端,js说无法判断,只好说,如果userId为null,重新定义为空字符串.如果大家有好的建议,可以在下方留言.
    
    //同时,这个地方需要注意的是,js端并不能查看我们给他传递的是什么值,也无法打印,貌似是语言问题? 还是js骗我文化低,反正,咱们把值传给他,根据双方商量好的逻辑,给出判断,如果正常,那就ok了.
    
    NSString * jsStr  =[NSString stringWithFormat:@"sendKey('%@')",jsUserId];
    
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        //此处可以打印error.
        
    }];
    
    //js端获取传递值代码实现实例(此处为js端实现代码给大家粘出来示范的!!!):
    
//    在js方法中这样给oc发送通知：
//    function postMessage() {
//
//        var body = {'message' :'这是消息'};
//
//        window.webkit.messageHandlers.myName.postMessage(body);
//
//    }
}


//依然是这个协议方法,获取注入方法名对象,获取js返回的状态值.
#pragma mark - WKScriptMessageHandler
//这是js方法中这样给oc发送通知 oc中收到通知后回调的方法：
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    //找到对应js端的方法名,获取messge.body
    NSLog(@"%@", message.name);
    NSLog(@"%@", message.webView);
    NSLog(@"%@", message.frameInfo);
    NSLog(@"%@", message.body);
    if ([message.name isEqualToString:@"function"]) {
        NSLog(@"%@", message.body);
    }
    
    NSDictionary *body = [[NSDictionary alloc] initWithDictionary:message.body];
    
    NSString *messageStr = [body objectForKey:@"message"];
    
    NSLog(@"%@", messageStr);
    

    //js端判断如果userId为空,则返回字符串@"toLogin"  ,或者返回其它值.  js端代码实现实例(此处为js端实现代码给大家粘出来示范的!!!):
    
//    function collectIsLogin(goods_id){
//
//        if (/(iPhone|iPad|iPod|iOS)/i.test(navigator.userAgent)) {
//
//
//            try {
//
//
//                if( $("#input").val()){
//
//                    window.webkit.messageHandlers.collectGzhu.postMessage({body: "'"+goods_id+"'"});
//
//
//                }else {
//                    window.webkit.messageHandlers.collectGzhu.postMessage({body: 'toLogin'});
//
//
//                }
//
//
//            }catch (e){
//                //浏览器
//                alert(e);
//            }
    
            
            //oc原生处理:
            
            
            if ([message.name isEqualToString:@"collectIsLogin"]) {
                
                
                
                
                NSDictionary * messageDict = (NSDictionary *)message.body;
                
                if ([messageDict[@"body"] isEqualToString:@"toLogin"]) {
                    
                    NSLog(@"登录");
                    
                    
                    
                    
                    
                    
                    
                }else{
                    
                    NSLog(@"正常跳转");
                    
                    NSLog(@"mess --- id == %@",message.body);
                    
                    
                    
                }
                
            }
            
}
        
        
//在交互中,关于alert (单对话框)函数、confirm(yes/no对话框)函数、prompt(输入型对话框)函数时,实现代理协议 WKUIDelegate ,
//则系统方法里有三个对应的协议方法.大家可以进入WKUIDelegate 协议类里面查看.下面具体协议方法实现,也给大家粘出来,以供参考.

#pragma mark - JS-OC WKUIDelegate
        
 - (void)webViewDidClose:(WKWebView *)webView {
     NSLog(@"%s", __FUNCTION__);
}
        
        // 在JS端调用alert函数时，会触发此代理方法。
        
        // JS端调用alert时所传的数据可以通过message拿到
        
        // 在原生得到结果后，需要回调JS，是通过completionHandler回调
        
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
            
    NSLog(@"%s", __FUNCTION__);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:@"JS调用alert" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler();
        
    }]];
    
    
    
    [self presentViewController:alert animated:YES completion:NULL];
    
    NSLog(@"%@", message);

}
        
        
        
// JS端调用confirm函数时，会触发此方法
        
// 通过message可以拿到JS端所传的数据
        
// 在iOS端显示原生alert得到YES/NO后

// 通过completionHandler回调给JS端
        
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
            
    NSLog(@"%@", message);
    NSLog(@"%s", __FUNCTION__);

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"confirm" message:@"JS调用confirm" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(YES);
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(NO);
        
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}
        
        
        
// JS端调用prompt函数时，会触发此方法 :要求输入一段文本
// 在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", prompt);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];

    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];

    [self presentViewController:alert animated:YES completion:NULL];
}
        
        
        
        
@end
