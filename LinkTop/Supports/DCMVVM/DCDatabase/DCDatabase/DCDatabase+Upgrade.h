//
//  DCDatabase+Upgrade.h
//  DCDatabase
//
//  Created by Duke on 13-5-27.
//  Copyright (c) 2013年 Duke. All rights reserved.
//

#import "DCDatabase.h"

@interface DCDatabase (Upgrade)

- (NSArray *)tablesCouldDrop;
- (NSArray *)tablesNeedUpgrade;

- (void)upgradeTable:(NSString *)table;

@end
