
/******************************************************************************
 *  @file   : DCViewModel.m
 *  @author : CUI ZHENSONG
 *  @date   : 2014-12-05
 *  @brief  : 视图模型（ViewModel）基类
 ******************************************************************************/

#import "DCViewModel.h"

@implementation DCViewModel

- (void)loadData:(void (^)())completion
{
  completion();
}

- (void)loadData
{
  
}

@end
