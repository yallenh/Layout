//
//  HRSwiperViewController.m
//  Layout
//
//  Created by Allen on 1/10/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRSwiperViewController.h"
#import "HRGradientScrollNavBar.h"

#import "HRHorizontalSection.h"

// protocol
#import "HRNavBarCategoryProtocol.h"

@interface HRSwiperViewController ()
<
    HRNavBarCategorySwitchDelegate
>
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) id<HRNavBarCategoryProtocol> navBarCategory;
@property (nonatomic) BOOL shouldUpdateCategory;
@property (nonatomic) Class verticalClass;

@end

@implementation HRSwiperViewController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout verticalClass:(Class)verticalClass dataSource:(NSArray <id<HRVerticalDataProtocol>> *)dataSource
{
    if (self = [super initWithCollectionViewLayout:layout]) {
        _currentPage = NSUIntegerMax;
        _dataSource = dataSource;
        _verticalClass = verticalClass;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;

    HRHorizontalSection *section = [[HRHorizontalSection alloc] initWithDataSourceItems:self.dataSource];
    [section setUp];
    [self.collectionController insertCollectionSectionModel:section atIndex:0];
    [self.collectionController registerCellReuseIdentifierOfCollectionSectionsInCollectionView:self.collectionView];

    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;

    // update navigation
    UINavigationController *nav = self.navigationController;
    self.navigationItem.titleView = nav.navigationItem.titleView;
    self.navigationItem.leftBarButtonItem = nav.navigationItem.leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = nav.navigationItem.rightBarButtonItem;

    // set delegate
    if ([self.navigationItem.titleView conformsToProtocol:@protocol(HRNavBarCategoryProtocol)]) {
        self.navBarCategory = (id<HRNavBarCategoryProtocol>)self.navigationItem.titleView;
        self.navBarCategory.switchDelegate = self;
        self.navBarCategory.categories = self.dataSource;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateCurrentPage];
    self.shouldUpdateCategory = YES;
}

#pragma mark -- Private methods

- (void)setDataSource:(NSArray<id<HRVerticalDataProtocol>> *)dataSource
{
    _dataSource = dataSource;
    self.navBarCategory.categories = dataSource;
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionViewFromCell:(UICollectionViewCell *)cell
{
    return (UICollectionView *)[[[[[cell.subviews firstObject] subviews] firstObject] subviews] firstObject];
}

- (void)setCurrentPage:(NSUInteger)currentPage
{
    self.navigationController.gradientScrollNavBar.shuldScrollViewUpdate = YES;
    if (_currentPage == currentPage) {
        [self.navigationController.gradientScrollNavBar resetToDefaultPositionWithAnimation:YES];
    }
    else {
        __weak typeof (self) weakSelf = self;
        [[self.collectionView visibleCells] enumerateObjectsUsingBlock:^(UICollectionViewCell *cell, NSUInteger idx, BOOL *stop) {
            typeof (weakSelf) strongSelf = weakSelf;
            if (strongSelf && [[strongSelf.collectionView indexPathForCell:cell] row] == currentPage) {
                UICollectionView *verticalCollectionView = [strongSelf collectionViewFromCell:cell];
                // ASSERT
                // strongSelf.navigationController.gradientScrollNavBar.scrollView != verticalCollectionView
                strongSelf.navigationController.gradientScrollNavBar.scrollView = verticalCollectionView;
                verticalCollectionView.superview.frame = cell.bounds;
                *stop = YES;
            }
        }];
    }
    _currentPage = currentPage;
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
