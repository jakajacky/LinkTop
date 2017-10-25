
#import <UIKit/UIKit.h>

#ifndef DCFoundation_DCInlines_h
#define DCFoundation_DCInlines_h

/*!
 *  @brief  应用程序版本号
 */
NS_INLINE NSString * AppVersion() {
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

/*!
 *  @brief  应用程序 BundleIdentifier
 */
NS_INLINE NSString * AppIdentifier() {
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

/*!
 *  @brief  创建随机UUID
 */
NS_INLINE NSString * UUID() {
  CFUUIDRef uuidObj = CFUUIDCreate(nil);
  NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
  CFRelease(uuidObj);
  return [uuidString lowercaseString];
}

/*!
 *  @brief  [[UIDevice currentDevice] model]
 */
NS_INLINE NSString * DeviceType() {
  return [[UIDevice currentDevice] model];
}

/*!
 *  @brief  [[UIDevice currentDevice] systemName]
 */
NS_INLINE NSString * DeviceOS() {
  return [[UIDevice currentDevice] systemName];
}

/*!
 *  @brief  [[UIDevice currentDevice] systemVersion]
 */
NS_INLINE NSString * DeviceOSVersion() {
  return [[UIDevice currentDevice] systemVersion];
}

/*!
 *  @brief  Cache 目录
 */
NS_INLINE NSString * CachesDirectory() {
  return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}

/*!
 *  @brief  Documents 目录
 */
NS_INLINE NSString * DocumentsDirectory() {
  return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

/*!
 *  @brief  获取指定文件在 Documents 目录中的路径
 *
 *  @param file 文件名
 */
NS_INLINE NSString * DocumentsPathOfFile(NSString *file) {
  return [DocumentsDirectory() stringByAppendingPathComponent:file];
}

#define kAry 1000
/*!
 *  @brief  格式化字节数为字符串
 *
 *  @param bytes 字节数
 *
 *  @discussion 进位：1000（即 1K = 1000bytes, 1M = 1000K...），最大单位：G
 */
NS_INLINE NSString *SizeStringForBytes(double bytes)
{
  NSString *s[] = {@"B", @"K", @"M", @"G"};
  int i = 0;
  while (bytes > kAry) {
    bytes /= kAry;
    i++;
  }
  
  return [NSString stringWithFormat:@"%.2f %@", bytes, s[i]];
}

/*!
 *  @brief 使用最小值和最大值创建NSRange
 *
 *  @param min 最小值
 *  @param max 最大值
 */
NS_INLINE NSRange NSMakeRangeV2(NSInteger min, NSInteger max)
{
  return NSMakeRange(min, max - min);
}



/*!
 *  @brief  获取 NSRange 中最小值
 */
NS_INLINE NSInteger NSRangeMin(NSRange range)
{
  return range.location;
}

/*!
 *  @brief  获取 NSRange 中最大值
 */
NS_INLINE NSInteger NSRangeMax(NSRange range)
{
  return range.location + range.length;
}

/*!
 *  @brief  判断数字是否在指定范围内
 *
 *  @param n     数字
 *  @param range 范围
 */
NS_INLINE BOOL NSIntegerIsInRange(NSInteger n, NSRange range)
{
  return n >= NSRangeMin(range) && n <= NSRangeMax(range);
}

#endif
