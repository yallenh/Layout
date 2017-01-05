//
//  HRStickyHeaderFlowLayout.m
//  Layout
//
//  Created by Allen on 1/5/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRStickyHeaderFlowLayout.h"

@interface HRStickyHeaderFlowLayout ()

@property (nonatomic) CGFloat lastOffset;
@property (nonatomic) CGFloat offsetUpdate;

@end

@implementation HRStickyHeaderFlowLayout

- (instancetype)init
{
    if (self = [super init]) {
        self.offsetUpdate = self.lastOffset = 0;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.offsetUpdate = self.lastOffset = 0;
    }
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    NSMutableIndexSet *stickySections = [[NSMutableIndexSet alloc] initWithIndexSet:self.stickySections];
    for (NSUInteger idx = 0; idx < answer.count; idx++) {
        UICollectionViewLayoutAttributes *layoutAttributes = [answer objectAtIndex:idx];
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            [stickySections addIndex:layoutAttributes.indexPath.section];
        }
        else if (layoutAttributes.representedElementKind == UICollectionElementKindSectionHeader) {
            [answer removeObjectAtIndex:idx];
            idx--;
        }
    }
    
    // layout all headers needed for the rect using self code
    [stickySections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        if (layoutAttributes) {
            [answer addObject:layoutAttributes];
        }
    }];

    return answer;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    if (kind == UICollectionElementKindSectionHeader && [self.stickySections containsIndex:indexPath.section]) {
        UICollectionView * const cv = self.collectionView;
        CGPoint const contentOffset = cv.contentOffset;
        CGPoint nextHeaderOrigin = CGPointMake(INFINITY, INFINITY);
        
        if (indexPath.section + 1 < [cv numberOfSections]) {
            UICollectionViewLayoutAttributes *nextHeaderAttributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section+1]];
            nextHeaderOrigin = nextHeaderAttributes.frame.origin;
        }
        
        CGRect frame = attributes.frame;
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            if (self.type == HRStickyHeaderFlowLayoutTypeReplace) {
                frame.origin.y = MIN(MAX(contentOffset.y, frame.origin.y), nextHeaderOrigin.y - CGRectGetHeight(frame));
            }
            else if (self.type == HRStickyHeaderFlowLayoutTypeStack) {
                frame.origin.y = MAX(contentOffset.y + indexPath.section * CGRectGetHeight(frame), frame.origin.y);
            }
            else if (self.type == HRStickyHeaderFlowLayoutTypeShowOnBrowsMore) {
                CGFloat shift = contentOffset.y - self.lastOffset;
                if (shift && contentOffset.y > 0) {
                    self.offsetUpdate = MAX(MIN(self.offsetUpdate - shift, 0), -CGRectGetHeight(frame));
                    self.lastOffset = contentOffset.y;
                }
                frame.origin.y = contentOffset.y + self.offsetUpdate;
            }
        }
        else {
            if (self.type == HRStickyHeaderFlowLayoutTypeReplace) {
                frame.origin.x = MIN(MAX(contentOffset.x, frame.origin.x), nextHeaderOrigin.x - CGRectGetWidth(frame));
            }
            else if (self.type == HRStickyHeaderFlowLayoutTypeStack) {
                frame.origin.y = MAX(contentOffset.x + indexPath.section * CGRectGetWidth(frame), frame.origin.x);
            }
            else if (self.type == HRStickyHeaderFlowLayoutTypeShowOnBrowsMore) {
                CGFloat shift = contentOffset.x - self.lastOffset;
                if (shift && contentOffset.x > 0) {
                    self.offsetUpdate = MAX(MIN(self.offsetUpdate - shift, 0), -CGRectGetWidth(frame));
                    self.lastOffset = contentOffset.x;
                }
                frame.origin.x = contentOffset.x + self.offsetUpdate;
            }
        }
        attributes.zIndex = 1024;
        attributes.frame = frame;
    }
    return attributes;
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    return YES;
}

@end
