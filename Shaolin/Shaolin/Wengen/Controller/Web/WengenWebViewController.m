//
//  WengenWebViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/5/12.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "WengenWebViewController.h"

#import "WengenNavgationView.h"

#import <WebKit/WebKit.h>
#import <SDWebImageManager.h>

@interface WengenWebViewController ()<WengenNavgationViewDelegate, WKUIDelegate,WKNavigationDelegate, WKScriptMessageHandler>

@property(nonatomic, strong)NSString *titleStr;

@property(nonatomic, strong)NSString *urlStr;;

@property(nonatomic, strong)WengenNavgationView *navgationView;

@property(nonatomic, strong)WKWebView *webView;

@property(nonatomic, strong)UIProgressView *progressView;

@property(nonatomic, strong)MBProgressHUD *hud;

@end

@implementation WengenWebViewController



-(instancetype)initWithUrl:(NSString*)url title:(NSString*)title{
    self = [super init];
    if (self) {
        self.urlStr = url;
        self.titleStr = title;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setHidden:YES];
    
    
}

#pragma mark - methods
-(void)initUI{
//    [self.view addSubview:self.navgationView];
    
    [self.titleLabe setText:self.titleStr];
    
    [self.view addSubview:self.webView];
    
//    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.webView.frame), ScreenWidth, 2)];
    
//    [self.view addSubview:self.progressView];
}

-(void)initData{
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [self.webView loadRequest:request];
    
    [self.navgationView setTitleStr:self.titleStr];
}

#pragma mark - WengenNavgationViewDelegate
-(void)tapBack{
    [self.navigationController popViewControllerAnimated:YES];
}

//kvo 监听进度 必须实现此方法
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
//    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
//        && object == _webView) {
//        self.progressView.progress = self.webView.estimatedProgress;
//        if (_webView.estimatedProgress >= 1.0f) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.progressView.progress = 0;
//            });
//        }
//    }else{
//        [super observeValueForKeyPath:keyPath
//                             ofObject:object
//                               change:change
//                              context:context];
//    }
}

#pragma mark - WKUIDelegate & WKNavigationDelegate
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
    [self.hud hideAnimated:YES];
}

//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
    [self.hud hideAnimated:YES];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.progressView setProgress:0.0f animated:NO];
    [self.hud hideAnimated:YES];
}

// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"1");
}

-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    self.hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSDictionary * jsonDic = [message.body mj_JSONObject];
    if (IsNilOrNull(jsonDic)) {
        NSLog(@"IsNilOrNull(jsonDic)");
        return;
    }
    NSString * flagStr = jsonDic[@"flag"];
    NSString * subJsonStr = jsonDic[@"json"];

    NSDictionary * subJsonDic = [subJsonStr mj_JSONObject];
    
    if ([flagStr isEqualToString:@"invitation"]) {
        NSString *imageUrl = subJsonDic[@"codeSrc"];
        NSLog(@"imageUrl : %@", imageUrl);
        if (imageUrl) {
            
            NSLog(@"[NSThread currentThread].name : %@", [NSThread currentThread].name);
            
            self.hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            
           
            
            [manager loadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                
                if (image) {
                    
                        
                        [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
                            [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                            
                        } completionHandler:^(BOOL success, NSError * _Nullable error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.hud hideAnimated:YES];
                                NSString *successStr = success == YES ? SLLocalizedString(@"保存成功"):SLLocalizedString(@"保存失败");
                                [ShaolinProgressHUD singleTextAutoHideHud:successStr];
                            });
                        }];
                        
                   
                }
                
            }];
            
        }
    }
}

#pragma mark - getter / setter

//-(WengenNavgationView *)navgationView{
//    if (_navgationView == nil) {
//        //状态栏高度
//        CGFloat barHeight ;
//        /** 判断版本
//         获取状态栏高度
//         */
//        if (@available(iOS 13.0, *)) {
//            barHeight = [[[[[UIApplication sharedApplication] keyWindow] windowScene] statusBarManager] statusBarFrame].size.height;
//        } else {
//            barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
//        }
//        _navgationView = [[WengenNavgationView alloc]initWithFrame:CGRectMake(0, barHeight, ScreenWidth, 44)];
//        [_navgationView setDelegate:self];
//    }
//    return _navgationView;
//}

-(WKWebView *)webView{
    
    if (_webView == nil) {
        CGFloat y = 0;//CGRectGetMaxY(self.navgationView.frame);
       
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        //初始化偏好设置属性：preferences
        config.preferences = [WKPreferences new];
        //The minimum font size in points default is 0;
        config.preferences.minimumFontSize = 10;
        //是否支持JavaScript
        config.preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        // 创建UserContentController（提供JavaScript向webView发送消息的方法）
        WKUserContentController* userContent = [[WKUserContentController alloc] init];
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        [userContent addScriptMessageHandler:self name:@"H5inFormLocal"];
        // 将UserConttentController设置到配置文件
        config.userContentController = userContent;
        
         _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, ScreenHeight - NavBar_Height) configuration:config];
        [_webView setAllowsLinkPreview:NO];
        [_webView setUIDelegate:self];
        [_webView setAllowsLinkPreview:NO];
        _webView.navigationDelegate = self;
        
        //添加监测网页加载进度的观察者
        [_webView addObserver:self
                       forKeyPath:@"estimatedProgress"
                          options:0
                          context:nil];
        
        
    }
    return _webView;

}


- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"H5inFormLocal"];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
