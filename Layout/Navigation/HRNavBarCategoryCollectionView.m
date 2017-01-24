//
//  HRNavBarCategoryCollectionView.m
//  Layout
//
//  Created by Allen on 1/20/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRNavBarCategoryCollectionView.h"
#import "HRGradientScrollNavBar.h"

@interface HRNavBarCategoryCollectionView ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic) NSMutableArray *categoryWidthCache;
@property (nonatomic) NSMutableArray *categoryCenterOffset;
@property (nonatomic) UIFont *categoryFont;

@end

@implementation HRNavBarCategoryCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];

        self.categoryFont = [UIFont systemFontOfSize:24.f];
        self.categoryWidthCache = [NSMutableArray array];
        self.categoryCenterOffset = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setCategories:(NSArray *)categories
{
    _categories = categories;
    [self.categoryWidthCache removeAllObjects];
    [self.categoryCenterOffset removeAllObjects];
    __block CGFloat offsetXBase = 0;
    __block CGFloat offsetX = 0;
    __weak typeof (self) weakSelf = self;
    NSDictionary *attributes = @{NSFontAttributeName:self.categoryFont};
    [categories enumerateObjectsUsingBlock:^(NSString *category, NSUInteger idx, BOOL *stop) {
        typeof (weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        CGFloat width = floor([[[NSAttributedString alloc] initWithString:category attributes:attributes] size].width);
        if (!idx) {
            offsetXBase = width / 2;
        }
        offsetX += width;
        [strongSelf.categoryWidthCache addObject:[NSNumber numberWithFloat:width]];
        [strongSelf.categoryCenterOffset addObject:[NSNumber numberWithFloat:(offsetX - width / 2 - offsetXBase)]];
    }];
    [self reloadData];
}

- (void)setTranslationX:(CGFloat)translationX
{
    // translationX = ((contentOffset.x - width / 2.f) / width) + 1;
    CGFloat x = ((translationX - 1.f) + .5f);
    if (x < 0) {
        return;
    }
    NSInteger lowerBoundIndex = (NSInteger)floor(x);
    NSInteger upperBoundIndex = (NSInteger)ceil(x);
    if (upperBoundIndex >= self.categoryCenterOffset.count) {
        return;
    }

    // update content offset
    CGFloat lowerBoundOffsetX =  [[self.categoryCenterOffset objectAtIndex:lowerBoundIndex] floatValue];
    CGFloat upperBoundOffsetX =  [[self.categoryCenterOffset objectAtIndex:upperBoundIndex] floatValue];
    CGFloat tx = (x - floor(x)) * (upperBoundOffsetX - lowerBoundOffsetX);
    [self setContentOffset:CGPointMake(lowerBoundOffsetX + tx, 0)];

    // update highlight index
    self.highlightedIndex = (x - lowerBoundIndex > .5f) ? upperBoundIndex : lowerBoundIndex;
}

- (void)setHighlightedIndex:(NSUInteger)highlightedIndex
{
    if (highlightedIndex == _highlightedIndex) {
        return;
    }
    NSUInteger lowlightedIndex = _highlightedIndex;
    _highlightedIndex = highlightedIndex;
    [self reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:lowlightedIndex inSection:0], [NSIndexPath indexPathForRow:highlightedIndex inSection:0]]];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    UILabel *label;
    if (cell.subviews.count <= 1) {
        label = [[UILabel alloc] initWithFrame:cell.bounds];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        [cell addSubview:label];
    }
    else {
        // assume no other views add to cell
        label = [cell.subviews objectAtIndex:1];
    }
    label.text = [self.categories objectAtIndex:indexPath.row];
    label.textColor = (indexPath.row == self.highlightedIndex) ? [UIColor whiteColor] : [UIColor lightGrayColor];
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([[self.categoryWidthCache objectAtIndex:indexPath.row] floatValue], CGRectGetHeight(collectionView.frame));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat width = CGRectGetWidth(collectionView.frame);
    CGFloat firstItemWidth = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]].width;
    CGFloat lastItemWidth = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:(self.categories.count - 1) inSection:section]].width;
    CGFloat centerDeviation = (screenWidth - width) / 2 - CGRectGetMinX(collectionView.frame);
    return UIEdgeInsetsMake(0, (width - firstItemWidth) / 2 + centerDeviation, 0, (width - lastItemWidth) / 2 - centerDeviation);
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.switchDelegate) {
        [self.switchDelegate navBarCategory:self didWantToSwitchToIndexPath:indexPath];
        [self setContentOffset:CGPointMake([[self.categoryCenterOffset objectAtIndex:indexPath.row] floatValue], 0) animated:YES];
        self.highlightedIndex = indexPath.row;
    }
}

@end
