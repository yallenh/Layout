//
//  ViewController.m
//  Layout
//
//  Created by Allen on 1/5/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "ViewController.h"
#import "HRVerticalViewController.h"
#import "HRSwiperViewController.h"
#import "UINavigationController+Factory.h"

#import "HRVerticalDataModel.h"


// #define DEVELOP_HOME

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor brownColor];

#ifdef DEVELOP_HOME
    HRVerticalViewController *viewController = [[HRVerticalViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
#else
    UICollectionViewFlowLayout *swiperLayout = [[UICollectionViewFlowLayout alloc] init];
    swiperLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    HRSwiperViewController *viewController = [[HRSwiperViewController alloc] initWithCollectionViewLayout:swiperLayout verticalClass:[HRVerticalViewController class] dataSource:
    @[
      [[HRVerticalDataModel alloc] initWithDictionary:@{@"display_name":@"每日情報"}],
      [[HRVerticalDataModel alloc] initWithDictionary:@{@"display_name":@"焦點"}],
      [[HRVerticalDataModel alloc] initWithDictionary:@{@"display_name":@"娛樂"}],
      [[HRVerticalDataModel alloc] initWithDictionary:@{@"display_name":@"運動"}],
      [[HRVerticalDataModel alloc] initWithDictionary:@{@"display_name":@"政治"}],
      [[HRVerticalDataModel alloc] initWithDictionary:@{@"display_name":@"財經"}],
      [[HRVerticalDataModel alloc] initWithDictionary:@{@"display_name":@"社會"}],
      [[HRVerticalDataModel alloc] initWithDictionary:@{@"display_name":@"國際"}],
      [[HRVerticalDataModel alloc] initWithDictionary:@{@"display_name":@"科技"}],
      [[HRVerticalDataModel alloc] initWithDictionary:@{@"display_name":@"健康"}],
      [[HRVerticalDataModel alloc] initWithDictionary:@{@"display_name":@"電影"}],
      [[HRVerticalDataModel alloc] initWithDictionary:@{@"display_name":@"汽機車"}]
    ]];
#endif
    UINavigationController *navController = [UINavigationController newsTabNavigationController];
    [navController setViewControllers:@[viewController] animated:NO];
    [self addChildViewController:navController];
    [self.view addSubview:navController.view];
    [viewController didMoveToParentViewController:self];
}

@end
