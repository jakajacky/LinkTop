#import <Foundation/Foundation.h>

@interface NSString (HttpRequestAdditions)

- (NSString*)dchr_urlEncode;

- (NSString *)dchr_urlCombineWithParams:(id)params;

@end
