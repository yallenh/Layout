//
//  ViewController.m
//  Layout
//
//  Created by Allen on 1/5/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "ViewController.h"
#import "HRLayoutViewController.h"
#import "GTScrollNavigationBar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    HRLayoutViewController *viewController = [[HRLayoutViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    UINavigationController *navController = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class] toolbarClass:nil];
    // UINavigationController *navController = [[UINavigationController alloc] initWithNavigationBarClass:[UINavigationBar class] toolbarClass:nil];
    [navController setViewControllers:@[viewController] animated:NO];

    [self addChildViewController:navController];
    [self.view addSubview:navController.view];
    [viewController didMoveToParentViewController:self];
}

@end
