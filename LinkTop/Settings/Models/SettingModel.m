//
//  settingModel.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/27.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "SettingModel.h"

@implementation SettingModel

- (void)reloadData:(void(^)(BOOL success))complete {
    [[DeviceManger defaultManager] getDeviceIdAndKey:^(NSString *PID, NSString *key) {
        self.deviceID = PID;
        self.deviceName = @"健康监测仪";
        complete(YES);
    }];
    self.deviceID = nil;
    self.deviceName = @"未绑定";
    self.softVersion = [DeviceManger defaultManager].softVersion;
    self.hardVersion = [DeviceManger defaultManager].hardVersion;
    complete(NO);
}

@end
