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
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    // add vertical collection view once on every reused cell
    UIView *firstView = [cell.subviews firstObject];
    if (!firstView.subviews.count) {
        UICollectionViewController *verticalVC = [[self.verticalClass alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        verticalVC.collectionView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.gradientScrollNavBar.frame), 0, 0, 0);
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
    // NSLog(@"will display %tu, cell = \n%@", indexPath.row, cell);
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
    [self.navigationController.gradientScrollNavBar resetToDefaultPositionWithAnimation:NO];
}

#pragma mark <UIScrollViewDelegate>

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
