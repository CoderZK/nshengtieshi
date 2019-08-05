//
//  ViewController.m
//  CHLCalendar
//
//  Created by luomin on 16/2/29.
//  Copyright © 2016年 CHL. All rights reserved.
//

#import "ViewController.h"
#define SSSSBarH [UIApplication sharedApplication].statusBarFrame.size.height
#define HHHHHH [UIScreen mainScreen].bounds.size.height
#define WWWWW [UIScreen mainScreen].bounds.size.width
@interface ViewController ()<WKNavigationDelegate>
@property(nonatomic,assign)BOOL isYes;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView * web =[[WKWebView alloc] initWithFrame:CGRectMake(0, 0, WWWWW, HHHHHH)];
    [self.view addSubview: web];
    web.navigationDelegate = self;
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    web.backgroundColor = [UIColor whiteColor];
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    web.scrollView.bounces = NO;
    web.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    self.webView = web;
}


/** 在发送请求之前，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {//跳转别的应用如系统浏览器
        // 对于跨域，需要手动跳转
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{} completionHandler:nil];
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {//应用的web内跳转
        decisionHandler (WKNavigationActionPolicyAllow);
    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request {
    NSURL *url = webView.request.URL;
    [[UIApplication sharedApplication] openURL:url];
    return YES;
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
 
    
 
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"%@",@"455646455");
    self.isYes = YES;
    NSURL *url = webView.request.URL;
    NSString *scheme = [url scheme];
    if (![scheme isEqualToString:@"https"] && ![scheme isEqualToString:@"http"]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
    
    
}

@end
