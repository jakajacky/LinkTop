//
//  RegisterAPI.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/26.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "DCBiz.h"

@interface RegisterAPI : DCBiz

- (void)registerWithPhone:(NSString *)phone pwd:(NSString *)pwd compeletion:(void(^)(BOOL, id))complete;

@end
