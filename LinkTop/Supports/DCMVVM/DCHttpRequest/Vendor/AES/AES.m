//
//  AES.m
//  AES
//
//  Created by Duke on 14-9-10.
//  Copyright (c) 2014年 Duke. All rights reserved.
//

#import "AES.h"

#import "Base64.h"
#import "NSData-AES.h"
#import "NSFileManager-AES.h"

typedef NS_ENUM(NSInteger, KEYBITS) {
  KEYBITS128 = 128,
  KEYBITS192 = 192,
  KEYBITS256 = 256,
};

@interface AES ()

@property (nonatomic) KEYBITS keybits;

@end

@implementation AES

+ (AES *)AES128
{
  AES *aes = [[AES alloc] init];
  aes.keybits = KEYBITS128;
  return aes;
}

+ (AES *)AES192
{
  AES *aes = [[AES alloc] init];
  aes.keybits = KEYBITS192;
  return aes;
}

+ (AES *)AES256
{
  AES *aes = [[AES alloc] init];
  aes.keybits = KEYBITS256;
  return aes;
}

- (NSString *)encryptString:(NSString *)string withKey:(NSString *)key progress:(void (^)(double))progress
{
//  [Base64 initialize];
  
  NSData *data          = [string dataUsingEncoding:NSUTF8StringEncoding];
  NSData *encryptedData = [self encrypteData:data withKey:key progress:progress];
  
  return [Base64 encode:encryptedData];
}

- (NSString *)decryptString:(NSString *)string withKey:(NSString *)key progress:(void (^)(double))progress
{
//  [Base64 initialize];
  
  NSData *encryptedData = [Base64 decode:string];
  NSData *decryptedData = [self decrypteData:encryptedData withKey:key progress:progress];
  
  NSString *decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
  return decryptedString;
}

- (NSData *)encrypteData:(NSData *)data withKey:(NSString *)key progress:(void (^)(double))progress
{
  return [data AESEncryptWithPassphrase:key keybits:self.keybits progress:^(long long bytesEncrypted) {
    if (progress) {
      double p = (double)bytesEncrypted / data.length;
      progress(p);
    }
  }];
}

- (NSData *)decrypteData:(NSData *)data withKey:(NSString *)key progress:(void (^)(double))progress
{
  return [data AESDecryptWithPassphrase:key keybits:self.keybits progress:^(long long bytesDecrypted) {
    if (progress) {
      double p = (double)bytesDecrypted / data.length;
      progress(p);
    }
  }];
}

- (BOOL)encryptFile:(NSString *)inPath
             toFile:(NSString *)outPath
            withKey:(NSString *)key
           progress:(void (^)(double))progress
              error:(NSError *__autoreleasing *)error
{
  NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:inPath];
  [fileHandle seekToEndOfFile];
  double totalBytes = fileHandle.offsetInFile;
  
  NSFileManager *fileMgr = [NSFileManager defaultManager];
  return [fileMgr AESEncryptFile:inPath
                          toFile:outPath
                 usingPassphrase:key
                         keybits:self.keybits
                        progress:^(long long bytesEncrypted) {
                          if (progress) {
                            double p = (double)bytesEncrypted / totalBytes;
                            progress(p);
                          }
                        }
                           error:error];
}

- (BOOL)decryptFile:(NSString *)inPath
             toFile:(NSString *)outPath
            withKey:(NSString *)key
           progress:(void (^)(double))progress
              error:(NSError **)error
{
  NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:inPath];
  [fileHandle seekToEndOfFile];
  double totalBytes = fileHandle.offsetInFile;
  
  NSFileManager *fileMgr = [NSFileManager defaultManager];
  return [fileMgr AESDecryptFile:inPath
                          toFile:outPath
                 usingPassphrase:key
                         keybits:self.keybits
                        progress:^(long long bytesDecrypted) {
                          if (progress) {
                            double p = (double)bytesDecrypted / totalBytes;
                            progress(p);
                          }
                        }
                           error:error];
}

@end
