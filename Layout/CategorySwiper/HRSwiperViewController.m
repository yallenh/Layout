//
//  HRSwiperViewController.m
//  Layout
//
//  Created by Allen on 1/10/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRSwiperViewController.h"
#import "HRGradientScrollNavBar.h"
#import "HRVerticalViewController.h"

@interface HRSwiperViewController ()

@end

@implementation HRSwiperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    self.view.clipsToBounds = NO;
    self.collectionView.clipsToBounds = NO;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    self.collectionView.pagingEnabled = YES;
    // Do any additional setup after loading the view.

    self.navigationController.gradientScrollNavBar.scrollView = self.collectionView;
}

#pragma mark -- Private methods

- (UICollectionView *)collectionViewFromCell:(UICollectionViewCell *)cell
{
    return (UICollectionView *)[[[[[cell.subviews firstObject] subviews] firstObject] subviews] firstObject];
}

- (void)resetGradientScrollNavBar
{
    [self.navigationController.gradientScrollNavBar resetToDefaultPositionWithAnimation:NO];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    // add vertical collection view once on every reused cell
    UIView *firstView = [cell.subviews firstObject];
    if (!firstView.subviews.count) {
        HRVerticalViewController *verticalVC = [[HRVerticalViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        [self addChildViewController:verticalVC];
        [firstView addSubview:verticalVC.view];
        [verticalVC didMoveToParentViewController:self];
    }
    // scroll vertical collection view to top
    [((UICollectionView *)[[[firstView.subviews firstObject] subviews] firstObject]) scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"will display %tu, cell = \n%@", indexPath.row, cell);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.frame.size;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self resetGradientScrollNavBar];
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[UICollectionView class]]) {
        return;
    }
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    CGFloat width = CGRectGetWidth(collectionView.frame);
    NSUInteger currentPage = ((collectionView.contentOffset.x - width / 2.f) / width) + 1;

    __weak typeof (self) weakSelf = self;
    [[collectionView visibleCells] enumerateObjectsUsingBlock:^(UICollectionViewCell *cell, NSUInteger idx, BOOL *stop) {
        typeof (weakSelf) strongSelf = weakSelf;
        if (strongSelf && [[collectionView indexPathForCell:cell] row] == currentPage) {
            UICollectionView *verticalCollectionView = [strongSelf collectionViewFromCell:cell];
            strongSelf.navigationController.gradientScrollNavBar.scrollView = verticalCollectionView;
            [strongSelf resetGradientScrollNavBar];
            *stop = YES;
        }
    }];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
