//
//  NSString+Pinyin.h
//  WorkingCenter
//
//  Created by Duke on 13-12-26.
//  Copyright (c) 2013年 Duke. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 需要引用的库：
 |- CoreFoundation.framework
 */

@interface NSString (Pinyin)

- (NSString *)pinyin;

@end

@interface NSString (Pinyin_Deprecated)

- (NSString *)pinyin_deprecated DEPRECATED_ATTRIBUTE;

@end
