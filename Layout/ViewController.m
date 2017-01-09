//
//  ViewController.m
//  Layout
//
//  Created by Allen on 1/5/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "ViewController.h"
#import "HRLayoutViewController.h"
#import "UINavigationController+Factory.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    HRLayoutViewController *viewController = [[HRLayoutViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];

    UINavigationController *navController = [UINavigationController homeTabNavigationController];
    [navController setViewControllers:@[viewController] animated:NO];
    [self addChildViewController:navController];
    [self.view addSubview:navController.view];
    [viewController didMoveToParentViewController:self];
}

@end
