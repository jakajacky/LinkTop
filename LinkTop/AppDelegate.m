//
//  AppDelegate.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/9.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "AppDelegate.h"
#import "DCMVVMConfiguration.h"
#import "LoginViewController.h"
#import "DCReachability.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "UIAlertController+Element.h"
#import "KeyController.h"
@interface AppDelegate ()<CBCentralManagerDelegate>
@property (nonatomic, strong) CBCentralManager *manager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[DCReachability getInstance] startMonitoring];
//    [[DeviceManger defaultManager] startConnectWithConnect:nil disconnect:nil bleAbnormal:nil];
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:nil];
    [self initializeMVVM];
    [self initializeSVHUD];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)initializeMVVM
{
    DCMVVMConfiguration *config = [DCMVVMConfiguration getInstance];
    
    config.appGroupId                      = kAppGroupIdentifier;
    
    config.httpRquestAllowsLogHeader       = kHttpRequestAllowsLogHeader;
    config.httpRquestAllowsLogMethod       = kHttpRequestAllowsLogMethod;
    config.httpRquestAllowsLogResponseGET  = kHttpRequestAllowsLogResponseGET;
    config.httpRquestAllowsLogResponsePOST = kHttpRequestAllowsLogResponsePOST;
    config.httpRquestAllowsLogRequestError = kHttpRequestAllowsLogRequestError;
    
    config.databaseShouldEncrypt           = kDatabaseShouldEncrypt;
    config.databaseAllowsLogStatement      = kDatabaseAllowsLogStatement;
    config.databaseAllowsLogError          = kDatabaseAllowsLogError;
}

- (void)initializeSVHUD {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMaximumDismissTimeInterval:1.5];
    [SVProgressHUD setMaximumDismissTimeInterval:1.5];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSString *message = nil;
    switch (central.state) {
        case 1:
            message = @"该设备不支持蓝牙功能,请检查系统设置";
            break;
        case 2:
            message = @"该设备蓝牙未授权,请检查系统设置";
            break;
        case 3:
            message = @"该设备蓝牙未授权,请检查系统设置";
            break;
        case 4: {
            message = @"该设备尚未打开蓝牙,请在设置中打开";
            // 提示
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"打开蓝牙来允许“多合一”连接到配件" preferredStyle:UIAlertControllerStyleAlert];
            [alert setMessageColor:UIColorHex(#333333) Font:[UIFont systemFontOfSize:17 weight:UIFontWeightBold]];
            UIAlertAction *action_ok = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *action_go = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                // 去设置
                NSURL *url = [NSURL URLWithString:@"App-Prefs:root=Bluetooth"];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            [alert addAction:action_ok];
            [alert addAction:action_go];
            [[KeyController topViewController] presentViewController:alert animated:YES completion:^{
                
            }];
            break;
        }
        case 5:
            message = @"蓝牙已经成功开启,请稍后再试";
            break;
        default:
            break;
    }
    if(message!=nil&&message.length!=0)
    {
        NSLog(@"message == %@",message);
    }
}



@end
