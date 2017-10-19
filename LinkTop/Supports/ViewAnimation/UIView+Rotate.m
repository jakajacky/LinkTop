//
//  UIView+Rotate.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/19.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "UIView+Rotate.h"

@implementation UIView (Rotate)

static BOOL stopAnimation = false;

- (void)startRotating {
    stopAnimation = false;
    
    // 方式一
    [self rotateImageView];
    
    // 方式二
    // 优点：随时中断，不会出现方式一情况：中断后，动画也会旋转完最后一次1/4
    /*
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(run)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
     */
}

- (void)stopRotating {
    stopAnimation = true;
}

- (void)run {
    self.transform = CGAffineTransformRotate(self.transform, 0.1);
}

- (void)rotateImageView {
    if (stopAnimation) {
        return;
    }
    
    // 一秒钟旋转几圈
    CGFloat circleByOneSecond = 1.0f;
    
    // 执行动画
    [UIView animateWithDuration:1.f / circleByOneSecond
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformRotate(self.transform, M_PI_2);
                     }
                     completion:^(BOOL finished){
                         [self rotateImageView];
                     }];
}

@end
