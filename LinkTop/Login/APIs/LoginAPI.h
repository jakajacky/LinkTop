//
//  LoginAPI.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/25.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "DCBiz.h"

@interface LoginAPI : DCBiz

- (void)loginWithUserName:(NSString *)name pwd:(NSString *)password completion:(void(^)(BOOL success, Patient *user, NSString *msg))complete;

- (Patient *)getCurrentPatientFormMainDB;

@end
