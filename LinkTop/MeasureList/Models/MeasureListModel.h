//
//  MeasureListModel.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/11/2.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeasureListModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)reloadData:(void(^)(BOOL success, NSString *msg))complete;
- (void)clearDatasource;
@end
