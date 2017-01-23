//
//  HRNavBarCategoryCollectionView.m
//  Layout
//
//  Created by Allen on 1/20/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRNavBarCategoryCollectionView.h"

@interface HRNavBarCategoryCollectionView ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

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
    }
    return self;
}

#pragma mark - Private Methods

- (void)setCategories:(NSArray *)categories
{
    _categories = categories;
    [self reloadData];
}

- (void)setText:(NSString *)text onCell:(UIView *)cell
{
    __block UILabel *label;
    if (cell.subviews.count <= 1) {
        label = [[UILabel alloc] initWithFrame:cell.bounds];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        [cell addSubview:label];
    }
    else {
        label = [cell.subviews objectAtIndex:1];
        /*
        [cell.subviews enumerateObjectsUsingBlock:^(id view, NSUInteger idx, BOOL *stop) {
            if ([view isKindOfClass:[UILabel class]]) {
                label = (UILabel *)view;
                *stop = YES;
            }
        }];
        */
    }
    label.text = text;
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
    [self setText:[self.categories objectAtIndex:indexPath.row] onCell:cell];
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = CGRectGetHeight(collectionView.frame);
    NSString *category = [self.categories objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:floor(height * .8f)];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGFloat width = [[[NSAttributedString alloc] initWithString:category attributes:attributes] size].width;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat width = CGRectGetWidth(collectionView.frame);
    CGFloat firstItemWidth = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]].width;
    // handle center deviation
    CGFloat centerDeviation = (screenWidth - width) / 2 - CGRectGetMinX(collectionView.frame);
    return UIEdgeInsetsMake(0, (width - firstItemWidth) / 2 + centerDeviation, 0, 0);
}

@end
