//
//  HRHorizontalSection.m
//  Layout
//
//  Created by Allen on 02/02/2017.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRHorizontalSection.h"
#import "HRVerticalViewController.h"

@interface HRHorizontalSection ()

@property (nonatomic) NSArray *verticalSections;

@end

@implementation HRHorizontalSection

- (instancetype)initWithDataSourceItems:(NSArray *)dataSourceItems verticalSections:(NSArray *)verticalSections
{
    if (self = [super initWithDataSourceItems:dataSourceItems]) {
        self.verticalSections = verticalSections;
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    __weak typeof (self) weakSekf = self;
    self.registerForCellReuseIdentifierBlock = ^(UICollectionView *collectionView) {
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    };
    self.cellForItemAtIndexPathBlock = ^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath, NSDictionary *dataSourceItemAtIndexPath) {
        typeof (weakSekf) strongSelf = weakSekf;
        if (!strongSelf) {
            return nil;
        }
        UICollectionViewController *selfViewController;
        if ([collectionView.delegate isKindOfClass:[UICollectionViewController class]]) {
            selfViewController = (UICollectionViewController *)collectionView.delegate;
        }
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
        // add vertical collection view once on every reused cell
        UIView *firstView = [cell.subviews firstObject];
        if (!firstView.subviews.count) {
            HRVerticalViewController *verticalViewController = [[HRVerticalViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
            verticalViewController.collectionView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(selfViewController.navigationController.navigationBar.frame), 0, 0, 0);
            [selfViewController addChildViewController:verticalViewController];
            [firstView addSubview:verticalViewController.view];
            [verticalViewController didMoveToParentViewController:selfViewController];
            // setup vertical sections
            [strongSelf.verticalSections enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id sectionModel, NSUInteger idx, BOOL *stop) {
                [verticalViewController.collectionController insertCollectionSectionModel:sectionModel atIndex:0];
                if ([sectionModel respondsToSelector:@selector(setUp)]) {
                    [sectionModel setUp];
                }
            }];
            [verticalViewController.collectionController registerCellReuseIdentifierOfCollectionSectionsInCollectionView:verticalViewController.collectionView];
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
