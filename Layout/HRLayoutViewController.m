//
//  HRLayoutViewController.m
//  Layout
//
//  Created by Allen on 1/6/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRLayoutViewController.h"
#import "HRStickyHeaderFlowLayout.h"
#import "GTScrollNavigationBar.h"


@interface HRLayoutViewController ()

@end

@implementation HRLayoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin)];
    [refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
    self.collectionView.refreshControl = refreshControl;
//    HRStickyHeaderFlowLayout *layout = [[HRStickyHeaderFlowLayout alloc] init];
//    layout.minimumLineSpacing = 0;
//    layout.minimumInteritemSpacing = 0;
//    layout.type = HRStickyHeaderFlowLayoutTypeShowOnBrowsMore;
//    layout.stickySections = [NSIndexSet indexSetWithIndex:0];

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    
    self.navigationItem.title = @"DemoScrollNavigationBar";
    self.navigationController.scrollNavigationBar.scrollView = self.collectionView;
}

- (void)setText:(NSString *)text onView:(UIView *)view
{
    UILabel *label;
    if (!view.subviews.count) {
        label = [[UILabel alloc] initWithFrame:view.bounds];
        [view addSubview:label];
    } else {
        label = [view.subviews firstObject];
    }
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
}

- (void)startRefresh
{
    __weak typeof (self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.collectionView.refreshControl endRefreshing];
    });
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    [self setText:[NSString stringWithFormat:@"%tu - %tu", indexPath.section, indexPath.row] onView:[cell.subviews firstObject]];
    cell.backgroundColor = [@[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor blueColor]] objectAtIndex:indexPath.row % 5];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *cell;
    if (kind == UICollectionElementKindSectionHeader) {
        cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
        [self setText:[NSString stringWithFormat:@"section %tu", indexPath.section] onView:cell];
        cell.backgroundColor = [UIColor purpleColor];
    } else {
        cell = [[UICollectionReusableView alloc] init];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(self.view.frame), 100.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(self.view.frame), 50.f);
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:NO];
}

@end
