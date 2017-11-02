//
//  CheckBLEPowerOn.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/2.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "CheckBLEPowerOn.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "UIAlertController+Element.h"
#import "KeyController.h"

@interface CheckBLEPowerOn ()<CBCentralManagerDelegate>
@property (nonatomic, strong) CBCentralManager *manager;
@end

@implementation CheckBLEPowerOn

/**
 * note: 创建的对象，应当被当前类持有，类似外设被持有，否则无法开启服务
 */
- (instancetype)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _manager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:nil];
    }
    return self;
}

+ (instancetype)checkItOut {
    return [[self alloc] init];
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
            // 提示去设置打开蓝牙
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"打开蓝牙来允许“多合一”连接到配件" preferredStyle:UIAlertControllerStyleAlert];
            [alert setMessageColor:UIColorHex(#333333) Font:[UIFont systemFontOfSize:17 weight:UIFontWeightBold]];
            UIAlertAction *action_ok = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *action_go = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                // 去设置
                NSURL *url = [NSURL URLWithString:@"App-Prefs:root=Bluetooth"];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@NO} completionHandler:^(BOOL success) {
                            
                        }];
                    } else {
                        // Fallback on earlier versions
                        [[UIApplication sharedApplication] openURL:url];
                    }
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
