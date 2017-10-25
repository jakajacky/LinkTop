
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSIndexPath (DCFoundation)

/*!
 *  @brief  获取 section 为 0 且 row 为 0 的 NSIndexPath 对象
 *
 *  @discussion 适用于 UITableView
 */
+ (NSIndexPath *)firstRow;

/*!
 *  @brief  获取 section 为 0 且 item 为 0 的 NSIndexPath 对象
 *
 *  @discussion 适用于 UICollectionView
 */
+ (NSIndexPath *)firstItem;

@end
