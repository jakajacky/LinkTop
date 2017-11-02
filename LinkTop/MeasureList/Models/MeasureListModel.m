//
//  MeasureListModel.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/2.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "MeasureListModel.h"
#import "MeasureListAPI.h"
@interface MeasureListModel ()

@property (nonatomic, strong) MeasureListAPI *measurelistAPI;

@end

@implementation MeasureListModel

- (void)reloadData:(void(^)(BOOL success))complete {
    Patient *user = [LoginManager defaultManager].currentPatient;
    NSDictionary *param = @{
                            @"user_id" : user.user_id,
                            @"reg_id"  : @(1),
                            @"end_pos" : @(10),
                            };
    [self.measurelistAPI downloadRecentData:param completion:^(BOOL success, id result, NSString *msg) {
        if (success) {
            self.dataSource = result;
        }
        else {
            
        }
        complete(success);
    }];
}

- (MeasureListAPI *)measurelistAPI {
    if (!_measurelistAPI) {
        _measurelistAPI = [MeasureListAPI biz];
    }
    return _measurelistAPI;
}

@end
