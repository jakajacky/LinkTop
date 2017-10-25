//
//  NSData-AES.m
//  Encryption
//
//  Created by Jeff LaMarche on 2/12/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import "NSData-AES.h"
#import "rijndael.h"

@implementation NSData(AES)

- (NSData *)AESEncryptWithPassphrase:(NSString *)pass
                             keybits:(int)keybits
                            progress:(void (^)(long long))progress
{
  NSMutableData *ret = [NSMutableData dataWithCapacity:[self length]];
  unsigned long rk[RKLENGTH(keybits)];
  unsigned char key[KEYLENGTH(keybits)];
  const char *password = [pass UTF8String];
  long long bytesEncrypted = 0;
  
  for (int i = 0; i < sizeof(key); i++)
    key[i] = password != 0 ? *password++ : 0;
  
  int nrounds = rijndaelSetupEncrypt(rk, key, keybits);
  
  unsigned char *srcBytes = (unsigned char *)[self bytes];
  int index = 0;
  
  while (1)
  {
    unsigned char plaintext[16];
    unsigned char ciphertext[16];
    int j, k;
    for (j = 0, k = 0; j < sizeof(plaintext); j++, k++)
    {
      if (index >= [self length])
        break;
      
      plaintext[j] = srcBytes[index++];
    }
    if (j == 0)
      break;
    for (; j < sizeof(plaintext); j++)
      plaintext[j] = ' ';
    
    rijndaelEncrypt(rk, nrounds, plaintext, ciphertext);
    [ret appendBytes:ciphertext length:sizeof(ciphertext)];
    
    if (progress) {
      bytesEncrypted += k;
      progress(bytesEncrypted);
    }
  }
  return ret;
}

- (NSData *)AESDecryptWithPassphrase:(NSString *)pass
                             keybits:(int)keybits
                            progress:(void (^)(long long))progress
{
  NSMutableData *ret = [NSMutableData dataWithCapacity:[self length]];
  unsigned long rk[RKLENGTH(keybits)];
  unsigned char key[KEYLENGTH(keybits)];
  const char *password = [pass UTF8String];
  long long bytesDecrypted = 0;
  
  for (int i = 0; i < sizeof(key); i++)
    key[i] = password != 0 ? *password++ : 0;
  
  int nrounds = rijndaelSetupDecrypt(rk, key, keybits);
  unsigned char *srcBytes = (unsigned char *)[self bytes];
  int index = 0;
  while (index < [self length])
  {
    unsigned char plaintext[16];
    unsigned char ciphertext[16];
    int j;
    for (j = 0; j < sizeof(ciphertext); j++)
    {
      if (index >= [self length])
        break;
      
      ciphertext[j] = srcBytes[index++];
    }
    rijndaelDecrypt(rk, nrounds, ciphertext, plaintext);
    [ret appendBytes:plaintext length:sizeof(plaintext)];
    
    if (progress) {
      bytesDecrypted += j;
      progress(bytesDecrypted);
    }
  }
  return ret;
}

@end
