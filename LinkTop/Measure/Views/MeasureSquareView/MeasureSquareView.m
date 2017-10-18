//
//  MeasureSquareView.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/18.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "MeasureSquareView.h"

@implementation MeasureSquareView

- (instancetype)initWithFrame:(CGRect)frame
                         Icon:(UIImage *)image
                        Title:(NSString *)title
                     Subtitle:(NSString *)subtitle {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *icon = [[UIImageView alloc] init];
        icon.frame = CGRectMake(0, 0, 50, 50);
        [icon setImage:image];
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.frame = CGRectMake(0, 0, 72, 25);
        titleL.text = title;
        titleL.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        titleL.textColor = [UIColor colorWithRed:51/255.0
                                           green:51/255.0
                                            blue:51/255.0
                                           alpha:1/1.0];
        
        UILabel *subtitleL = [[UILabel alloc] init];
        subtitleL.frame = CGRectMake(0, 0, 96, 16);
        subtitleL.text = subtitle;
        subtitleL.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        subtitleL.textColor = [UIColor colorWithRed:153/255.0
                                              green:153/255.0
                                               blue:153/255.0
                                              alpha:1/1.0];
        [self addSubview:icon];
        [self addSubview:titleL];
        [self addSubview:subtitleL];
        
        [icon autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [icon autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:14];
        
        [titleL autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [titleL autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:icon withOffset:11];
        
        [subtitleL autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [subtitleL autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleL withOffset:4];
        
    }
    return self;
}

- (void)setupSubviews {
    
    
    

}
@end
