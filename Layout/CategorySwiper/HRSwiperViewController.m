//
//  HRSwiperViewController.m
//  Layout
//
//  Created by Allen on 1/10/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRSwiperViewController.h"
#import "HRGradientScrollNavBar.h"

// protocol
#import "HRNavBarCategoryProtocol.h"
#import "HRCollectionSectionModel_private.h"

@interface HRSwiperViewController ()
<
    HRNavBarCategorySwitchDelegate
>
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) id<HRNavBarCategoryProtocol> navBarCategory;
@property (nonatomic) BOOL shouldUpdateCategory;
@property (nonatomic) BOOL shouldHookScrollView;

@end

@implementation HRSwiperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = NSUIntegerMax;
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINavigationController *nav = self.navigationController;
    if (nav.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = nav.navigationItem.leftBarButtonItem;
        self.navigationItem.rightBarButtonItem = nav.navigationItem.rightBarButtonItem;
        self.navigationItem.titleView = nav.navigationItem.titleView;
        if ([self.navigationItem.titleView conformsToProtocol:@protocol(HRNavBarCategoryProtocol)]) {
            self.navBarCategory = (id<HRNavBarCategoryProtocol>)self.navigationItem.titleView;
            self.navBarCategory.switchDelegate = self;
            self.navBarCategory.categories = [[self.collectionController collectionSectionModelAtIndex:0] dataSourceItems];
        }
        self.shouldHookScrollView = YES;
    }
    else {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateCurrentPage];
    self.shouldUpdateCategory = YES;
}

#pragma mark -- Private methods

- (UICollectionView *)collectionViewFromCell:(UICollectionViewCell *)cell
{
    return (UICollectionView *)[[[[[cell.subviews firstObject] subviews] firstObject] subviews] firstObject];
}

- (void)hookScrollViewWithNavigationBar
{
    self.shouldHookScrollView = NO;
    __weak typeof (self) weakSelf = self;
    [[self.collectionView visibleCells] enumerateObjectsUsingBlock:^(UICollectionViewCell *cell, NSUInteger idx, BOOL *stop) {
        typeof (weakSelf) strongSelf = weakSelf;
        if (strongSelf && [[strongSelf.collectionView indexPathForCell:cell] row] == strongSelf.currentPage) {
            UICollectionView *verticalCollectionView = [strongSelf collectionViewFromCell:cell];
            // ASSERT
            // strongSelf.navigationController.gradientScrollNavBar.scrollView != verticalCollectionView
            strongSelf.navigationController.gradientScrollNavBar.scrollView = verticalCollectionView;
            verticalCollectionView.superview.frame = cell.bounds;
            *stop = YES;
        }
    }];
}

- (void)setCurrentPage:(NSUInteger)currentPage
{
    self.navigationController.gradientScrollNavBar.shuldScrollViewUpdate = YES;
    if (_currentPage == currentPage && !self.shouldHookScrollView) {
        [self.navigationController.gradientScrollNavBar resetToDefaultPositionWithAnimation:YES];
    }
    else {
        _currentPage = currentPage;
        [self hookScrollViewWithNavigationBar];
    }
}

- (void)updateCurrentPage
{
    if (self.currentPage == NSUIntegerMax) {
        self.currentPage = 0;
    }
    else {
        CGFloat width = CGRectGetWidth(self.collectionView.frame);
        self.currentPage = ((self.collectionView.contentOffset.x - width / 2.f) / width) + 1;
    }
}


#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self.navigationController.gradientScrollNavBar resetToDefaultPositionWithAnimation:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // will change category
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        self.navigationController.gradientScrollNavBar.shuldScrollViewUpdate = NO;
        [self.navigationController.gradientScrollNavBar resetToDefaultPositionWithAnimation:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((scrollView == self.collectionView) && self.shouldUpdateCategory) {
        CGFloat width = CGRectGetWidth(scrollView.frame);
        CGFloat translationX = ((scrollView.contentOffset.x - width / 2.f) / width) + 1;
        self.navBarCategory.translationX = translationX;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView) {
        [self updateCurrentPage];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView) {
        [self updateCurrentPage];
        self.shouldUpdateCategory = YES;
    }
}

#pragma mark <HRNavBarCategorySwitchDelegate>

- (void)navBarCategory:(id<HRNavBarCategoryProtocol>)navBarCategory didWantToSwitchToIndexPath:(NSIndexPath *)indexPath
{
    if (navBarCategory == self.navBarCategory) {
        self.shouldUpdateCategory = NO;
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

@end
