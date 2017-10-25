
/******************************************************************************
 *  @file   : DCView.m
 *  @author : CUI ZHENSONG
 *  @date   : 2014-11-10
 *  @brief  : 视图基类
 ******************************************************************************/

#import "DCView.h"

NSString *kDCViewCoverDidTapNotification        = @"kDCViewCoverDidTapNotification";
NSString *kDCViewCoverDidSwipeLeftNotification  = @"kDCViewCoverDidSwipeLeftNotification";
NSString *kDCViewCoverDidSwipeRightNotification = @"kDCViewCoverDidSwipeRightNotification";

@interface DCView ()
{
  UIView                  *_cover;
  UIActivityIndicatorView *_indicator;
}

@property (nonatomic,readonly) UIView *cover;

@end

@implementation DCView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.clipsToBounds   = YES;
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)fadeInCover
{
  [self fadeInCoverCompletion:nil];
}

- (void)fadeOutCover
{
  [self fadeOutCoverCompletion:nil];
}

- (void)fadeInCoverCompletion:(void (^)())completion
{
  [self addSubview:self.cover];
  
  [UIView animateWithDuration:0.4
                   animations:^{
                     self.cover.alpha = 1.0;
                   }
                   completion:^(BOOL finished) {
                     if (completion) {
                       completion();
                     }
                   }];
}

- (void)fadeOutCoverCompletion:(void (^)())completion
{
  [UIView animateWithDuration:0.4
                   animations:^{
                     self.cover.alpha = 0.0;
                   }
                   completion:^(BOOL finished) {
                     [self.cover removeFromSuperview];
                     if (completion) {
                       completion();
                     }
                   }];
}

- (void)showLoadingIndicator
{
  [self hideLoadingIndicator];
  self.userInteractionEnabled = NO;
  
  _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  
#ifdef kMainColor
  _indicator.color = kMainColor;
#else
  _indicator.color = [UIColor colorWithRed:64 / 255.0 green:169 / 255.0 blue:224 / 255.0 alpha:1.0];
#endif
  
  [self addSubview:_indicator];
  [self bringSubviewToFront:_indicator];
  
  CGFloat centerX = CGRectGetMidX(self.bounds);
  CGFloat centerY = CGRectGetMidY(self.bounds);
  CGPoint center  = CGPointMake(centerX, centerY);
  _indicator.center = center;
  
  [_indicator startAnimating];
}

- (void)hideLoadingIndicator
{
  self.userInteractionEnabled = YES;
  if (_indicator) {
    [_indicator stopAnimating];
    [_indicator removeFromSuperview];
    _indicator = nil;
  }
}

#pragma mark -
#pragma mark Properties

- (UIView *)cover
{
  if (!_cover) {
    _cover = [[UIView alloc] initWithFrame:self.bounds];
    _cover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _cover.alpha = 0.0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired    = 1;
    tap.numberOfTouchesRequired = 1;
    [tap addTarget:self action:@selector(handleTap:)];
    [_cover addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] init];
    leftSwipe.direction                 = UISwipeGestureRecognizerDirectionLeft;
    leftSwipe.numberOfTouchesRequired   = 1;
    [leftSwipe addTarget:self action:@selector(handleSwipe:)];
    [_cover addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] init];
    rightSwipe.direction                 = UISwipeGestureRecognizerDirectionRight;
    rightSwipe.numberOfTouchesRequired   = 1;
    [rightSwipe addTarget:self action:@selector(handleSwipe:)];
    [_cover addGestureRecognizer:rightSwipe];
  }
  
  return _cover;
}

#pragma mark -
#pragma mark Gestures Hanlder

- (void)handleTap:(UITapGestureRecognizer *)tap
{
  NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
  [notiCenter postNotificationName:kDCViewCoverDidTapNotification object:nil];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe
{
  NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
  if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
    [notiCenter postNotificationName:kDCViewCoverDidSwipeLeftNotification object:nil];
  }
  else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
    [notiCenter postNotificationName:kDCViewCoverDidSwipeRightNotification object:nil];
  }
}

@end
