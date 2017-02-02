//
//  HRVerticalViewController.m
//  Layout
//
//  Created by Allen on 1/6/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRVerticalViewController.h"
#import "HRGradientScrollNavBar.h"

#import "HRVerticalStreamSection.h"


// #define DEVELOP_HOME

@interface HRVerticalViewController ()

@end

@implementation HRVerticalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin)];
    [refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
    self.collectionView.refreshControl = refreshControl;

    NSArray *mockStreamDataSource = @[@{}, @{}, @{}, @{}, @{}, @{}, @{}, @{}, @{}, @{}];
    HRVerticalStreamSection *streamSection = [[HRVerticalStreamSection alloc] initWithDataSourceItems:mockStreamDataSource];
    [streamSection setUp];
    [self.collectionController insertCollectionSectionModel:streamSection atIndex:0];
    [self.collectionController registerCellReuseIdentifierOfCollectionSectionsInCollectionView:self.collectionView];

#ifdef DEVELOP_HOME
    self.navigationController.gradientScrollNavBar.scrollView = self.collectionView;
    UINavigationController *nav = self.navigationController;
    self.navigationItem.leftBarButtonItem = nav.navigationItem.leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = nav.navigationItem.rightBarButtonItem;
#endif
}

- (void)startRefresh
{
    __weak typeof (self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.collectionView.refreshControl endRefreshing];
    });
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
#ifdef DEVELOP_HOME
    [self.navigationController.gradientScrollNavBar resetToDefaultPositionWithAnimation:NO];
#endif
}

@end
