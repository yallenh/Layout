//
//  ViewController.m
//  Layout
//
//  Created by Allen on 1/5/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "ViewController.h"
#import "HRLayoutViewController.h"
#import "HRSwiperViewController.h"
#import "UINavigationController+Factory.h"

// #define DEVELOP_HOME

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
#ifdef DEVELOP_HOME
    HRLayoutViewController *viewController = [[HRLayoutViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
#else
    UICollectionViewFlowLayout *swiperLayout = [[UICollectionViewFlowLayout alloc] init];
    swiperLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    HRSwiperViewController *viewController = [[HRSwiperViewController alloc] initWithCollectionViewLayout:swiperLayout];
#endif
    UINavigationController *navController = [UINavigationController newsTabNavigationController];
    [navController setViewControllers:@[viewController] animated:NO];
    [self addChildViewController:navController];
    [self.view addSubview:navController.view];
    [viewController didMoveToParentViewController:self];
}

@end
