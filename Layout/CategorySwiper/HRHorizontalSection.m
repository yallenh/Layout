//
//  HRHorizontalSection.m
//  Layout
//
//  Created by Allen on 02/02/2017.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRHorizontalSection.h"
#import "HRVerticalViewController.h"
#import "HRGradientScrollNavBar.h"

@implementation HRHorizontalSection

- (void)setUp
{
    self.registerForCellReuseIdentifierBlock = ^(UICollectionView *collectionView) {
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    };
    self.cellForItemAtIndexPathBlock = ^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath, NSDictionary *dataSourceItemAtIndexPath) {
        UICollectionViewController *selfViewController;
        if ([collectionView.delegate isKindOfClass:[UICollectionViewController class]]) {
            selfViewController = (UICollectionViewController *)collectionView.delegate;
        }
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
        // add vertical collection view once on every reused cell
        UIView *firstView = [cell.subviews firstObject];
        if (!firstView.subviews.count) {
            HRVerticalViewController *verticalViewController = [[HRVerticalViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
            verticalViewController.collectionView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(selfViewController.navigationController.gradientScrollNavBar.frame), 0, 0, 0);
            [selfViewController addChildViewController:verticalViewController];
            [firstView addSubview:verticalViewController.view];
            [verticalViewController didMoveToParentViewController:selfViewController];
        }
        // scroll vertical collection view to top
        [((UICollectionView *)[[[firstView.subviews firstObject] subviews] firstObject]) scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        return cell;
    };
    self.layoutSizeForItemAtIndexPathBlock = ^CGSize(UICollectionView *collectionView, UICollectionViewLayout *layout, NSIndexPath *indexPath, id dataSourceItemAtIndexPath) {
        return collectionView.frame.size;
    };
}

@end
