//
//  DCDatabase+PrivateMethods.h
//  DCDatabase
//
//  Created by Duke on 13-7-29.
//  Copyright (c) 2013年 Duke. All rights reserved.
//

#import "DCDatabase.h"

@interface DCDatabase (PrivateMethods)

- (DCDatabase *)initWithIdentifer:(NSString *)identifier
                        directory:(NSString *)directory;
- (void)close;
- (void)updateTables;

- (NSArray *)tables;

- (BOOL)setKey:(NSString *)key;

@end


@interface DCDatabase (Deprecated_Nonfunctional)

- (id)init DEPRECATED_ATTRIBUTE;

@end
