//
//  DRSegmentControl.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/19.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ValueChanged)(NSInteger currentIndex);

@interface DRSegmentControl : UIView

@property (nonatomic, strong) NSString *segOneTitle;
@property (nonatomic, strong) NSString *segTwoTitle;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy)   ValueChanged valueChangedBlock;

@end
