
#import "UIView+UIShortcuts.h"

@implementation UIView (UIShortcuts)

+ (UIView *)viewWithFrame:(CGRect)frame
          backgroundColor:(UIColor *)backgroundColor
{
  UIView *view = [[UIView alloc] initWithFrame:frame];
  view.backgroundColor = backgroundColor;
  return view;
}

- (UIView *)addViewWithFrame:(CGRect)frame
{
  return [self addViewWithFrame:frame
                          class:[UIView class]
                backgroundColor:[UIColor clearColor]];
}

- (UIView *)addViewWithFrame:(CGRect)frame
       backgroundColor:(UIColor *)backgroundColor
{
  return [self addViewWithFrame:frame
                          class:[UIView class]
                backgroundColor:backgroundColor];
}

- (id)addViewWithFrame:(CGRect)frame
                 class:(Class)viewClass
{
  return [self addViewWithFrame:frame
                          class:viewClass
                backgroundColor:[UIColor clearColor]];
}

- (id)addViewWithFrame:(CGRect)frame
                 class:(Class)viewClass
       backgroundColor:(UIColor *)backgroundColor
{
  UIView *view = [[viewClass alloc] initWithFrame:frame];
  view.backgroundColor = backgroundColor;
  [self addSubview:view];
  
  return view;
}

#pragma mark -
#pragma mark UIButton Shortcuts

- (UIButton *)addButtonWithFrame:(CGRect)frame
{
  return [self addButtonWithFrame:frame
                            title:nil
                  backgroundImage:nil
                           target:nil
                           action:nil];
}

- (UIButton *)addButtonWithFrame:(CGRect)frame
                          action:(SEL)action
{
  return [self addButtonWithFrame:frame
                            title:nil
                  backgroundImage:nil
                           target:self
                           action:action];
}

- (UIButton *)addButtonWithFrame:(CGRect)frame
                          target:(id)target
                          action:(SEL)action
{
  return [self addButtonWithFrame:frame
                            title:nil
                  backgroundImage:nil
                           target:target
                           action:action];
}

- (UIButton *)addButtonWithFrame:(CGRect)frame
                           title:(NSString *)title
                 backgroundImage:(UIImage *)backgroundImage
{
  return [self addButtonWithFrame:frame
                            title:title
                  backgroundImage:backgroundImage
                           target:nil
                           action:nil];
}

- (UIButton *)addButtonWithFrame:(CGRect)frame
                           title:(NSString *)title
                 backgroundImage:(UIImage *)backgroundImage
                          action:(SEL)action
{
  return [self addButtonWithFrame:frame
                            title:title
                  backgroundImage:backgroundImage
                           target:self
                           action:action];
}

- (UIButton *)addButtonWithFrame:(CGRect)frame
                           title:(NSString *)title
                 backgroundImage:(UIImage *)backgroundImage
                          target:(id)target
                          action:(SEL)action
{
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
  [btn setFrame:frame];
  [btn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
  [btn setTitle:title forState:UIControlStateNormal];
#ifdef kMainColor
  [btn setTitleColor:kMainColor forState:UIControlStateNormal];
#else
  [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
#endif
  [[btn titleLabel] setFont:[UIFont systemFontOfSize:14]];
  [btn setAdjustsImageWhenHighlighted:NO];
  
  if (target != nil && action != nil) {
    [btn addTarget:target
            action:action
  forControlEvents:UIControlEventTouchUpInside];
  }
  
  [self addSubview:btn];
  
  return btn;
}

- (UIButton *)addButtonWithFrame:(CGRect)frame
                           image:(UIImage *)image
{
  return [self addButtonWithFrame:frame
                            image:image
                           target:nil
                           action:nil];
}

- (UIButton *)addButtonWithFrame:(CGRect)frame
                           image:(UIImage *)image
                          target:(id)target
                          action:(SEL)action
{
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
  [btn setFrame:frame];
  [btn setImage:image forState:UIControlStateNormal];
  [btn setAdjustsImageWhenHighlighted:NO];
  
  if (target != nil && action != nil) {
    [btn addTarget:target
            action:action
  forControlEvents:UIControlEventTouchUpInside];
  }
  
  [self addSubview:btn];
  
  return btn;
}

#pragma mark -
#pragma mark UILabel Shortcuts

- (UILabel *)addLabelWithFrame:(CGRect)frame
                          text:(NSString *)text
{
  return [self addLabelWithFrame:frame
                            text:text
                       textColor:nil
                            font:nil];
}

- (UILabel *)addLabelWithFrame:(CGRect)frame
                          text:(NSString *)text
                     textColor:(UIColor *)textColor
{
  return [self addLabelWithFrame:frame
                            text:text
                       textColor:textColor
                            font:nil];
}

- (UILabel *)addLabelWithFrame:(CGRect)frame
                          text:(NSString *)text
                          font:(UIFont *)font
{
  return [self addLabelWithFrame:frame
                            text:text
                       textColor:nil
                            font:font];
}

- (UILabel *)addLabelWithFrame:(CGRect)frame
                          text:(NSString *)text
                     textColor:(UIColor *)textColor
                          font:(UIFont *)font
{
  UILabel *label = [[UILabel alloc] initWithFrame:frame];
  label.backgroundColor = [UIColor clearColor];
  label.text            = text;
  label.textColor       = textColor;
  label.font            = font;
  [self addSubview:label];
  
  return label;
}

#pragma mark -
#pragma mark UIImageView Shortcuts

- (UIImageView *)addImage:(UIImage *)image withFrame:(CGRect)frame
{
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
  imageView.image = image;
  [self addSubview:imageView];
  
  return imageView;
}

- (UIImageView *)addImage:(UIImage *)image atOrigin:(CGPoint)origin
{
  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
  
  CGRect frame = imageView.frame;
  frame.origin = origin;
  
  imageView.frame = frame;
  
  [self addSubview:imageView];
  
  return imageView;
}

#pragma mark -
#pragma mark UIScrollView Shortcuts

- (UIScrollView *)addScrollviewWithFrame:(CGRect)frame
{
  return [self addScrollviewWithFrame:frame
                          contentSize:CGSizeMake(frame.size.width, frame.size.height)];
}

- (UIScrollView *)addScrollviewWithFrame:(CGRect)frame
                             contentSize:(CGSize)contentSize
{
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
  scrollView.contentSize = contentSize;
  scrollView.showsHorizontalScrollIndicator = NO;
  scrollView.showsVerticalScrollIndicator = NO;
  [self addSubview:scrollView];
  
  return scrollView;
}

- (UIScrollView *)addScrollviewWithFrame:(CGRect)frame
                           numberOfPages:(NSInteger)numberOfPages
                         scrollDirection:(UIScrollViewScrollDirection)scrollDirection
{
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
  scrollView.pagingEnabled = YES;
  
  CGSize contentSize = CGSizeZero;
  switch (scrollDirection) {
    case UIScrollViewScrollDirectionNone:
      scrollView.scrollEnabled = NO;
      break;
    case UIScrollViewScrollDirectionHorizontal:
      contentSize = CGSizeMake(frame.size.width * numberOfPages, 0);
      break;
    case UIScrollViewScrollDirectionVertical:
      contentSize = CGSizeMake(0, frame.size.height * numberOfPages);
      break;
    default:
      break;
  }
  
  scrollView.contentSize = contentSize;
  scrollView.showsHorizontalScrollIndicator = NO;
  scrollView.showsVerticalScrollIndicator = NO;
  [self addSubview:scrollView];
  
  return scrollView;
}

#pragma mark -
#pragma mark UIPageControl Shortcuts

- (UIPageControl *)addPageControlWithNumberOfPages:(NSInteger)numberOfPages
{
  return [self addPageControlWithNumberOfPages:numberOfPages
                        pageIndicatorTintColor:nil
                 currentPageIndicatorTintColor:nil];
}

- (UIPageControl *)addPageControlWithNumberOfPages:(NSInteger)numberOfPages
                            pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                     currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
  UIPageControl *pageControl = [[UIPageControl alloc] init];
  pageControl.currentPage = 0;
  pageControl.numberOfPages = numberOfPages;
  pageControl.defersCurrentPageDisplay = YES;
  pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
  pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
  
  CGRect frame = CGRectZero;
  frame.size = [pageControl sizeForNumberOfPages:numberOfPages];
  pageControl.frame = frame;
  
  [self addSubview:pageControl];
  
  return pageControl;
}


#pragma mark -
#pragma mark Border Shortcuts

- (void)addBorder
{
  [self addBorderWithColor:[UIColor blackColor] width:1.0];
}

- (void)addBorderWithColor:(UIColor *)color
{
  [self addBorderWithColor:color width:1.0];
}

- (void)addBorderWithColor:(UIColor *)color width:(CGFloat)width
{
  self.layer.borderWidth = width;
  self.layer.borderColor = color.CGColor;
}

@end

