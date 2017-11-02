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

static int page = 1;

- (instancetype)init {
    self = [super init];
    if (self) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)reloadData:(void(^)(BOOL success))complete {
    Patient *user = [LoginManager defaultManager].currentPatient;
    NSDictionary *param = @{
                            @"user_id" : user.user_id,
                            @"reg_id"  : @(page),
                            @"end_pos" : @(10),
                            };
    [self.measurelistAPI downloadRecentData:param completion:^(BOOL success, id result, NSString *msg) {
        if (success) {
            page += 1;
            [self.dataSource insertObjects:result atIndex:self.dataSource.count];
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
