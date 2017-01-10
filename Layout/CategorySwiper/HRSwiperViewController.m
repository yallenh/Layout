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
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    self.collectionView.pagingEnabled = YES;
    // Do any additional setup after loading the view.

    self.navigationController.gradientScrollNavBar.scrollView = self.collectionView;
    self.navigationItem.titleView = self.navigationController.navigationItem.titleView;
    self.navigationItem.leftBarButtonItem = self.navigationController.navigationItem.leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = self.navigationController.navigationItem.rightBarButtonItem;
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    [self setText:[NSString stringWithFormat:@"%tu - %tu", indexPath.section, indexPath.row] onView:[cell.subviews firstObject]];
    cell.backgroundColor = [@[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor blueColor]] objectAtIndex:indexPath.row % 5];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
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
