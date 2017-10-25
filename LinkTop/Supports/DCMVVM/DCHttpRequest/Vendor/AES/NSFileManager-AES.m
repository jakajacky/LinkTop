//
//  NSFileManager-AES.m
//  Encryption
//
//  Created by Jeff LaMarche on 2/12/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import "NSFileManager-AES.h"
#import "rijndael.h"

@implementation NSFileManager(AES)

- (BOOL)AESEncryptFile:(NSString *)inPath
                toFile:(NSString *)outPath
       usingPassphrase:(NSString *)pass
               keybits:(int)keybits
              progress:(void (^)(long long))progress
                 error:(NSError *__autoreleasing *)error
{
  unsigned long rk[RKLENGTH(keybits)];
  unsigned char key[KEYLENGTH(keybits)];
  const char *password = [pass UTF8String];
  long long bytesEncrypted = 0;
  
  for (int i = 0; i < sizeof(key); i++)
    key[i] = password != 0 ? *password++ : 0;
  
  int nrounds = rijndaelSetupEncrypt(rk, key, keybits);
  FILE *fp = fopen([inPath UTF8String], "r");
  FILE *output = fopen([outPath UTF8String], "wb");
  if (output == NULL)
  {
    *error = [NSError errorWithDomain:@"AES Encryption" code:1000 userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"File Open Error", @"File Open Error") forKey:AESEncryptionErrorDescriptionKey]];
    return NO;
  }
  while (1)
  {
    unsigned char plaintext[16];
    unsigned char ciphertext[16];
    int j, k;
    for (j = 0, k = 0; j < sizeof(plaintext); j++, k++)
    {
      int c = getc(fp);
      if (c == EOF)
        break;
      plaintext[j] = c;
    }
    if (j == 0)
      break;
    for (; j < sizeof(plaintext); j++)
      plaintext[j] = ' ';
    rijndaelEncrypt(rk, nrounds, plaintext, ciphertext);
    if (fwrite(ciphertext, sizeof(ciphertext), 1, output) != 1)
    {
      fclose(output);
      *error = [NSError errorWithDomain:@"AES Encryption" code:1000 userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"File write error", @"File write error") forKey:AESEncryptionErrorDescriptionKey]];
      return NO;
    }
    
    if (progress) {
      bytesEncrypted += k;
      progress(bytesEncrypted);
    }
  }
  fclose(output);
  fclose(fp);
  return YES;
}
- (BOOL)AESDecryptFile:(NSString *)inPath
                toFile:(NSString *)outPath
       usingPassphrase:(NSString *)pass
               keybits:(int)keybits
              progress:(void (^)(long long))progress
                 error:(NSError *__autoreleasing *)error
{
  unsigned long rk[RKLENGTH(keybits)];
  unsigned char key[KEYLENGTH(keybits)];
  const char *password = [pass UTF8String];
  long long bytesDecrypted = 0;
  
  for (int i = 0; i < sizeof(key); i++)
    key[i] = password != 0 ? *password++ : 0;
  
  FILE *fp = fopen([inPath UTF8String], "r");
  FILE *output = fopen([outPath UTF8String], "wb");
  if (output == NULL)
  {
    *error = [NSError errorWithDomain:@"AES Encryption" code:1000 userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"File Open Error", @"File Open Error") forKey:AESEncryptionErrorDescriptionKey]];
    return NO;
  }
  int nrounds = rijndaelSetupDecrypt(rk, key, keybits);
  while (1)
  {
    unsigned char plaintext[16];
    unsigned char ciphertext[16];
    
    if (fread(ciphertext, sizeof(ciphertext), 1, fp) != 1)
      break;
    rijndaelDecrypt(rk, nrounds, ciphertext, plaintext);
    if (fwrite(plaintext, sizeof(plaintext), 1, output) != 1)
    {
      fclose(output);
      *error = [NSError errorWithDomain:@"AES Encryption" code:1000 userInfo:[NSDictionary dictionaryWithObject:NSLocalizedString(@"File write error", @"File write error") forKey:AESEncryptionErrorDescriptionKey]];
      return NO;
    }
    
    if (progress) {
      bytesDecrypted += 16;
      progress(bytesDecrypted);
    }
  }
  fclose(output);
  fclose(fp);
  return YES;
}
@end
