//
//  VegaScrollFlowLayout.m
//  LinkTop
//
//  Created by XiaoQiang on 2017/10/24.
//  Copyright © 2017年 XiaoQiang. All rights reserved.
//

#import "VegaScrollFlowLayout.h"
#import "ShareCell.h"
#import "ECGCell.h"

@interface VegaScrollFlowLayout ()
{
    CGFloat springHardness;
    BOOL isPagingEnabled;

    NSMutableSet *visibleIndexPaths;
    CGFloat latestDelta;
    
    CATransform3D transformIdentity;
}

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;

@end

@implementation VegaScrollFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        springHardness = 15;
        isPagingEnabled = NO;
        visibleIndexPaths = [NSMutableSet set];
        latestDelta = 0;
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        
        transformIdentity = CATransform3DMakeTranslation(0, 0, 0);
    }
    return self;
}

- (void)resetLayout {
    [self.dynamicAnimator removeAllBehaviors];
    [self prepareLayout];
}

- (void)prepareLayout {
    [super prepareLayout];
    if (!self.collectionView) {
        return;
    }
    
    CGFloat expandBy = -100;
    CGRect visibleRect = CGRectInset(CGRectMake(self.collectionView.bounds.origin.x, self.collectionView.bounds.origin.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height), 0, expandBy);
    
    NSArray *visibleItems = [super layoutAttributesForElementsInRect:visibleRect];
    if (!visibleItems) {
        return;
    }
    NSMutableSet *indexPathsInVisibleRect = [NSMutableSet set];
    for (UICollectionViewLayoutAttributes *attr in visibleItems) {
        [indexPathsInVisibleRect addObject:attr.indexPath];
    }
    
    [self removeNoLongerVisibleBehaviorsIndexPathsInVisibleRect:indexPathsInVisibleRect];
    
    NSMutableArray *newlyVisibleItems = [NSMutableArray array];
    for (int i = 0; i<visibleItems.count; i++) {
        UICollectionViewLayoutAttributes *at = visibleItems[i];
        
        if (![visibleIndexPaths containsObject:at.indexPath]) {
            [newlyVisibleItems addObject:at];
        }
    }
    
    [self addBehaviorsforItems:newlyVisibleItems];
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGPoint latestOffset = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    if (!isPagingEnabled) {
        return latestOffset;
    }
    
    int row = ceil((proposedContentOffset.y) / (self.itemSize.height + self.minimumLineSpacing));
    
    CGFloat calculatedOffset = row * 87 + row * self.minimumLineSpacing;
    CGPoint targetOffset = CGPointMake(latestOffset.x, calculatedOffset);
    return targetOffset;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    if (!self.collectionView) {
        return nil;
    }
    NSArray *dynamicItems = [self.dynamicAnimator itemsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *item in dynamicItems) {
        CGFloat convertedY = item.center.y - self.collectionView.contentOffset.y - self.sectionInset.top;
        item.zIndex = item.indexPath.row;
        [self transformItemIfNeededY:convertedY Item:item];
    }
    return dynamicItems;
}

- (void)transformItemIfNeededY:(CGFloat)y Item:(UICollectionViewLayoutAttributes *)item {
    if (self.itemSize.height<=0 || y>=self.itemSize.height*0.5) {
        return;
    }
    
    CGFloat scaleFactor = [self scaleDistributorX:y];
    
    CGFloat yDelta = [self getYDeltaY:y];
    
    item.transform3D = CATransform3DTranslate((transformIdentity), 0, yDelta, 0);
    item.transform3D = CATransform3DScale(item.transform3D, scaleFactor, scaleFactor, scaleFactor);
    item.alpha = [self alphaDistributorX:y];
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    UICollectionView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    latestDelta = delta;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    for (UIAttachmentBehavior *behavior in self.dynamicAnimator.behaviors) {
        UICollectionViewLayoutAttributes *attrs = (UICollectionViewLayoutAttributes *)behavior.items.firstObject;
        attrs.center = [self getUpdatedBehaviorItemCenterBehavior:behavior touchLocation:touchLocation];
        [self.dynamicAnimator updateItemUsingCurrentState:attrs];
    }
    return NO;
}

- (void)removeNoLongerVisibleBehaviorsIndexPathsInVisibleRect:(NSSet *)indexPaths {
    //get no longer visible behaviors
    NSMutableArray *noLongerVisibleBehaviours = [NSMutableArray array];
    for (UIAttachmentBehavior *behaviour in self.dynamicAnimator.behaviors) {
        if (behaviour) {
            UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes *)behaviour.items.firstObject;
            if (![indexPaths containsObject:item.indexPath]) {
                [noLongerVisibleBehaviours addObject:behaviour];
            }
        }
        else {
            
        }
    }
    for (UIAttachmentBehavior *behaviour in noLongerVisibleBehaviours) {
        UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes *)behaviour.items.firstObject;
        [self.dynamicAnimator removeBehavior:behaviour];
        [visibleIndexPaths removeObject:item.indexPath];
    }
}

- (void)addBehaviorsforItems:(NSMutableArray *)items {
    if (!self.collectionView) {
        return;
    }
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    for (UICollectionViewLayoutAttributes *item in items) {
        UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:item.center];
        springBehaviour.length = 0.0;
        springBehaviour.damping = 0.8;
        springBehaviour.frequency = 1.0;
        
        if (touchLocation.x!=0 || touchLocation.y!=0) {
            item.center = [self getUpdatedBehaviorItemCenterBehavior:springBehaviour touchLocation:touchLocation];
        }
        [self.dynamicAnimator addBehavior:springBehaviour];
        [visibleIndexPaths addObject:item.indexPath];
    }
}

- (CGPoint)getUpdatedBehaviorItemCenterBehavior:(UIAttachmentBehavior *)behavior touchLocation:(CGPoint)touchLocation {
    
    double yDistanceFromTouch = fabs(touchLocation.y - behavior.anchorPoint.y);
    double xDistanceFromTouch = fabs(touchLocation.x - behavior.anchorPoint.x);
    CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / (springHardness * 100);
    
    UICollectionViewLayoutAttributes *attrs = (UICollectionViewLayoutAttributes *)behavior.items.firstObject;
    CGPoint center = attrs.center;
    if (latestDelta < 0) {
        center.y += MAX(latestDelta, latestDelta * scrollResistance);
    } else {
        center.y += MIN(latestDelta, latestDelta * scrollResistance);
    }
    return center;
}


- (CGFloat)distributorX:(CGFloat)x Threshold:(CGFloat)threshold XOrigin:(CGFloat)xOrigin {
    if (threshold<=xOrigin) {
        return 1;
    }
    CGFloat arg = (x - xOrigin)/(threshold - xOrigin);
    arg = arg <= 0 ? 0 : arg;
    CGFloat y = sqrt(arg);
    return y > 1 ? 1 : y;
}

- (CGFloat)scaleDistributorX:(CGFloat)x {
    return [self distributorX:x Threshold:self.itemSize.height * 0.5 XOrigin:-self.itemSize.height * 5];
}

- (CGFloat)alphaDistributorX:(CGFloat)x {
    return [self distributorX:x Threshold:self.itemSize.height * 0.5 XOrigin:-self.itemSize.height];
}

- (CGFloat)getYDeltaY:(CGFloat)y {
    return self.itemSize.height * 0.5 - y;
}

@end
