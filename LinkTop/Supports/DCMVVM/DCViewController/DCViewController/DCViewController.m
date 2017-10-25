
/******************************************************************************
 *  @file   : DCViewController.m
 *  @author : CUI ZHENSONG
 *  @date   : 2014-11-10
 *  @brief  : 视图控制器基类
 ******************************************************************************/

#import "DCViewController.h"

@interface DCViewController ()
{
  UIActivityIndicatorView *_indicator;
  UIAlertView             *_alert;
}

@property (nonatomic,readonly) DCViewController *parentViewController;



@end

@implementation DCViewController

@dynamic view, parentViewController;

- (void)loadView
{
  Class viewClass = [self viewClass];
  if (![viewClass isSubclassOfClass:[DCView class]]) {
    NSLog(@"*** Cannot load view which is not subclass of or identical to DCView in %@.", [self class]);
    return;
  }
  
  CGRect frame = CGRectZero;
  
  if (self.parentViewController) {
    frame = [self.parentViewController viewFrameForChildViewController:self];
  }
  else {
    frame = [self viewFrame];
  }
  
  self.view = [[[self viewClass] alloc] initWithFrame:frame];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

#pragma mark -
#pragma mark View Layout

- (Class)viewClass
{
  return [DCView class];
}

- (CGRect)viewFrame
{
  return CGRectMake(0, 0, 1024, 768);
}

- (CGRect)viewFrameForChildViewController:(DCViewController *)child
{
  return CGRectMake(0, 0, 1024, 768);
}

#pragma mark -

- (void)addChildViewController:(UIViewController *)child
{
  [super addChildViewController:child];
  [self.view addSubview:child.view];
}

- (void)removeFromParentViewController
{
  [self.view removeFromSuperview];
  [super removeFromParentViewController];
}

@end

@implementation DCViewController (BaseViewGestureAdditions)

- (BOOL)allowsPop
{
  return YES;
}

@end

@implementation DCViewController (LoadingIndicator)

- (void)showLoadingIndicator
{
  [self hideLoadingIndicator];
  self.view.userInteractionEnabled = NO;
  
  _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

#ifdef kMainColor
  _indicator.color = kMainColor;
#else
  _indicator.color = [UIColor colorWithRed:64 / 255.0 green:169 / 255.0 blue:224 / 255.0 alpha:1.0];
#endif
  
  [self.view addSubview:_indicator];
  [self.view bringSubviewToFront:_indicator];
  
  CGFloat centerX = CGRectGetMidX(self.view.bounds);
  CGFloat centerY = CGRectGetMidY(self.view.bounds) - 50;
  CGPoint center  = CGPointMake(centerX, centerY);
  _indicator.center = center;
  
  [_indicator startAnimating];
}

- (void)hideLoadingIndicator
{
  self.view.userInteractionEnabled = YES;
  if (_indicator) {
    [_indicator stopAnimating];
    [_indicator removeFromSuperview];
    _indicator = nil;
  }
}

@end

@implementation DCViewController (PushAdditions)

- (void)didPopBack
{
  
}

@end

@implementation DCViewController (PresentAdditions)

- (void)didDismissBack
{
  
}

@end
