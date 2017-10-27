//
//  settingModel.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/27.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingModel : NSObject

@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *softVersion;
@property (nonatomic, strong) NSString *hardVersion;
@property (nonatomic, strong) NSString *deviceName;

- (void)reloadData:(void(^)(BOOL success))complete;
@end
