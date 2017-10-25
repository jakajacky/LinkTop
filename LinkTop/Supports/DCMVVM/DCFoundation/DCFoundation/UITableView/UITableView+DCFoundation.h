
#import <UIKit/UIKit.h>

@interface UITableView (DCFoundation)

/*!
 *  @brief  选中第一个分组中的第一行
 */
- (void)selectFirstRow;

/*!
 *  @brief  选中第一个分组中的指定行
 */
- (void)selectRow:(NSInteger)row;

/*!
 *  @brief  选中指定分组的指定行
 */
- (void)selectRow:(NSInteger)row inSection:(NSInteger)section;

/*!
 *  @brief  选中指定 section 的指定行
 *
 *  @param row            指定行
 *  @param section        指定组
 *  @param animated       是否有选中动画
 *  @param scrollPosition 选中行的滚动位置
 */
- (void)selectRow:(NSInteger)row
        inSection:(NSInteger)section
         animated:(BOOL)animated
   scrollPosition:(UITableViewScrollPosition)scrollPosition;

/*!
 *  @brief  取消选中所有已选中的内容
 */
- (void)deselectRows;

@end
