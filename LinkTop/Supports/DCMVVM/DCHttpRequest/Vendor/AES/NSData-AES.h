//
//  NSData-AES.h
//  Encryption
//
//  Created by Jeff LaMarche on 2/12/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

// Supported keybit values are 128, 192, 256

@interface NSData(AES)

- (NSData *)AESEncryptWithPassphrase:(NSString *)pass
                             keybits:(int)keybits
                            progress:(void (^)(long long bytesEncrypted))progress;
- (NSData *)AESDecryptWithPassphrase:(NSString *)pass
                             keybits:(int)keybits
                            progress:(void (^)(long long bytesDecrypted))progress;

@end
