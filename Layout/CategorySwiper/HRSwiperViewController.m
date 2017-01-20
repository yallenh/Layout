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
@property (nonatomic) NSUInteger currentPage;
@end

@implementation HRSwiperViewController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout]) {
        _currentPage = NSUIntegerMax;
    }
    return self;
}

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

    UINavigationController *nav = self.navigationController;
    self.navigationItem.titleView = nav.navigationItem.titleView;
    self.navigationItem.leftBarButtonItem = nav.navigationItem.leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = nav.navigationItem.rightBarButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.currentPage == NSUIntegerMax) {
        self.currentPage = 0;
    }
}

#pragma mark -- Private methods

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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // reset nav bar scroll view
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        CGFloat width = CGRectGetWidth(scrollView.frame);
        self.currentPage = ((scrollView.contentOffset.x - width / 2.f) / width) + 1;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // will change category
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        self.navigationController.gradientScrollNavBar.shuldScrollViewUpdate = NO;
        [self.navigationController.gradientScrollNavBar resetToDefaultPositionWithAnimation:YES];
    }
}

@end
