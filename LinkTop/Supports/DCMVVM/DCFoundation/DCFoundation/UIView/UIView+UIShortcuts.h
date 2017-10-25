
#import <UIKit/UIKit.h>

@interface UIView (UIShortcuts)

/*!
 *  @brief 实例化指定 frame、背景色的视图
 */
+ (UIView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor;

/*!
 *  @brief  在当前视图中添加视图
 */
- (UIView *)addViewWithFrame:(CGRect)frame;

/*!
 *  @brief  在当前视图中添加视图
 */
- (UIView *)addViewWithFrame:(CGRect)frame
       backgroundColor:(UIColor *)backgroundColor;

/*!
 *  @brief  在当前视图中添加指定类型的视图
 *
 *  @return 指定类型的视图
 */
- (id)addViewWithFrame:(CGRect)frame
                 class:(Class)viewClass;

/*!
 *  @brief  在当前视图中添加指定类型的视图
 *
 *  @return 指定类型的视图
 */
- (id)addViewWithFrame:(CGRect)frame
                 class:(Class)viewClass
       backgroundColor:(UIColor *)backgroundColor;

#pragma mark -

/*!
 *  @brief  在当前视图中添加 UIButton
 */
- (UIButton *)addButtonWithFrame:(CGRect)frame;

/*!
 *  @brief  在当前视图中添加 UIButton
 *
 *  @discussion Target is 'self'
 */
- (UIButton *)addButtonWithFrame:(CGRect)frame action:(SEL)action;

/*!
 *  @brief  在当前视图中添加 UIButton
 */
- (UIButton *)addButtonWithFrame:(CGRect)frame target:(id)target action:(SEL)action;

/*!
 *  @brief  在当前视图中添加 UIButton
 *
 *  @discussion 没有 target 及 action
 */
- (UIButton *)addButtonWithFrame:(CGRect)frame
                           title:(NSString *)title
                 backgroundImage:(UIImage *)backgroundImage;

/*!
 *  @brief  在当前视图中添加 UIButton
 *
 *  @discussion Target is 'self'
 */
- (UIButton *)addButtonWithFrame:(CGRect)frame
                           title:(NSString *)title
                 backgroundImage:(UIImage *)backgroundImage
                          action:(SEL)action;
/*!
 *  @brief  在当前视图中添加 UIButton
 */
- (UIButton *)addButtonWithFrame:(CGRect)frame
                           title:(NSString *)title
                 backgroundImage:(UIImage *)backgroundImage
                          target:(id)target
                          action:(SEL)action;
/*!
 *  @brief  在当前视图中添加 UIButton
 *
 *  @discussion 没有 target 及 action
 */
- (UIButton *)addButtonWithFrame:(CGRect)frame
                           image:(UIImage *)image;
/*!
 *  @brief  在当前视图中添加 UIButton
 */
- (UIButton *)addButtonWithFrame:(CGRect)frame
                           image:(UIImage *)image
                          target:(id)target
                          action:(SEL)action;

#pragma mark -

/*!
 *  @brief  在当前视图中添加 UILabel
 */
- (UILabel *)addLabelWithFrame:(CGRect)frame
                          text:(NSString *)text;
/*!
 *  @brief  在当前视图中添加 UILabel
 */
- (UILabel *)addLabelWithFrame:(CGRect)frame
                          text:(NSString *)text
                     textColor:(UIColor *)textColor;
/*!
 *  @brief  在当前视图中添加 UILabel
 */
- (UILabel *)addLabelWithFrame:(CGRect)frame
                          text:(NSString *)text
                          font:(UIFont *)font;

/*!
 *  @brief  在当前视图中添加 UILabel
 */
- (UILabel *)addLabelWithFrame:(CGRect)frame
                          text:(NSString *)text
                     textColor:(UIColor *)textColor
                          font:(UIFont *)font;

#pragma mark -

/*!
 *  @brief  在当前视图中添加指定 frame 的图片
 *
 *  @param image 图片
 *  @param frame 图片视图 frame
 *
 *  @discussion 图片可能会被缩放
 *
 *  @return 图片视图（UIImageView）
 */
- (UIImageView *)addImage:(UIImage *)image withFrame:(CGRect)frame;

/*!
 *  @brief  在当前视图中指定位置添加图片
 *
 *  @param image  图片
 *  @param origin 图片位置
 *
 *  @discussion 图片视图的大小即为图片本身的尺寸
 *
 *  @return 图片视图（UIImageView）
 */
- (UIImageView *)addImage:(UIImage *)image atOrigin:(CGPoint)origin;

#pragma mark -

/*!
 *  @brief  UIScrollView 的滚动方向
 */
typedef NS_ENUM(NSInteger, UIScrollViewScrollDirection) {
  /*!
   *  @brief  不滚动
   */
  UIScrollViewScrollDirectionNone,
  /*!
   *  @brief  纵向滚动
   */
  UIScrollViewScrollDirectionVertical,
  /*!
   *  @brief  横向滚动
   */
  UIScrollViewScrollDirectionHorizontal
};

/*!
 *  @brief  在当前视图中添加指定条件的 UIScrollView
 */
- (UIScrollView *)addScrollviewWithFrame:(CGRect)frame;

/*!
 *  @brief  在当前视图中添加指定条件的 UIScrollView
 */
- (UIScrollView *)addScrollviewWithFrame:(CGRect)frame
                             contentSize:(CGSize)contentSize;

/*!
 *  @brief  在当前视图中添加分页的 UIScrollView
 *
 *  @param frame           位置及尺寸
 *  @param numberOfPages   页数
 *  @param scrollDirection 滚动方向
 */
- (UIScrollView *)addScrollviewWithFrame:(CGRect)frame
                           numberOfPages:(NSInteger)numberOfPages
                         scrollDirection:(UIScrollViewScrollDirection)scrollDirection;

#pragma mark -

/*!
 *  @brief  在当前视图中添加 UIPageControl
 */
- (UIPageControl *)addPageControlWithNumberOfPages:(NSInteger)numberOfPages;

/*!
 *  @brief  在当前视图中添加 UIPageControl
 *
 *  @param numberOfPages                 页数
 *  @param pageIndicatorTintColor        未选中的页面标记颜色
 *  @param currentPageIndicatorTintColor 以选中的页面标记颜色
 */
- (UIPageControl *)addPageControlWithNumberOfPages:(NSInteger)numberOfPages
                            pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                     currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor;

#pragma mark -
#pragma mark Border

/*!
 *  @brief  为当前视图添加边框
 *
 *  @discussion  颜色：黑色；宽度：1.0
 */
- (void)addBorder;

/*!
 *  @brief  为当前视图添加指定颜色的边框
 *
 *  @discussion  宽度：1.0
 */
- (void)addBorderWithColor:(UIColor *)color;

/*!
 *  @brief  为当前视图添加指定颜色及宽度的边框
 */
- (void)addBorderWithColor:(UIColor *)color width:(CGFloat)width;

@end
