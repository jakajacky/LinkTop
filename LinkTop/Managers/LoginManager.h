//
//  LoginManager.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/25.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonEntities.h"

@interface LoginManager : NSObject<NSCopying>

@property (nonatomic, strong) Patient *currentPatient;

/**
 * 单例
 */

+ (instancetype)defaultManager;

@end
