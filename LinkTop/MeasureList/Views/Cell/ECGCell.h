//
//  ECGCell.h
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/25.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECGCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSString *info;

@property (weak, nonatomic) IBOutlet UIButton *checkECGViewBtn;


@end
