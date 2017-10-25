//
//  NSFileManager-AES.h
//  Encryption
//
//  Created by Jeff LaMarche on 2/12/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

// Supported keybit values are 128, 192, 256

#define AESEncryptionErrorDescriptionKey	@"description"

@interface NSFileManager(AES)

-(BOOL)AESEncryptFile:(NSString *)inPath
               toFile:(NSString *)outPath
      usingPassphrase:(NSString *)pass
              keybits:(int)keybits
             progress:(void (^)(long long bytesEncrypted))progress
                error:(NSError **)error;

-(BOOL)AESDecryptFile:(NSString *)inPath
               toFile:(NSString *)outPath
      usingPassphrase:(NSString *)pass
              keybits:(int)keybits
             progress:(void (^)(long long bytesDecrypted))progress
                error:(NSError **)error;

@end
