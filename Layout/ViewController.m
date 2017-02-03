//
//  ViewController.m
//  Layout
//
//  Created by Allen on 1/5/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "ViewController.h"
#ifdef DEVELOP_HOME
#import "HRVerticalViewController.h"
#endif
#import "HRSwiperViewController.h"
#import "UINavigationController+Factory.h"

#import "HRVerticalDataModel.h"

#import "HRHorizontalSection.h"
#import "HRVerticalStreamSection.h"

#import <WebKit/WebKit.h>

// #define DEVELOP_HOME

@interface ViewController ()

@property (nonatomic) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor brownColor];

//    NSURL *url = [NSURL URLWithString:@"https://tw.video.yahoo.com/embed/%E6%A8%82%E4%BE%86%E8%B6%8A%E6%84%9B%E4%BD%A0-%E6%AD%A3%E5%BC%8F%E9%A0%90%E5%91%8A-134308831.html?format=embed"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
//    [_webView loadRequest:request];
//    _webView.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
//    [self.view addSubview:_webView];
//    return;

#ifdef DEVELOP_HOME
    HRVerticalViewController *viewController = [[HRVerticalViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    UINavigationController *navController = [UINavigationController homeTabNavigationController];
#else
    UICollectionViewFlowLayout *swiperLayout = [[UICollectionViewFlowLayout alloc] init];
    swiperLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    HRSwiperViewController *viewController = [[HRSwiperViewController alloc] initWithCollectionViewLayout:swiperLayout];
    HRVerticalStreamSection *streamSection = [[HRVerticalStreamSection alloc] initWithDataSourceItems:@[@{},@{},@{},@{},@{},@{},@{},@{},@{},@{}]];
    HRHorizontalSection *section = [[HRHorizontalSection alloc] initWithDataSourceItems:
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
      ] verticalSections:@[streamSection]];
    [viewController.collectionController insertCollectionSectionModel:section atIndex:0];
    [viewController.collectionController registerCellReuseIdentifierOfCollectionSectionsInCollectionView:viewController.collectionView];
    UINavigationController *navController = [UINavigationController newsTabNavigationController];
#endif
    [navController setViewControllers:@[viewController] animated:NO];
    [self addChildViewController:navController];
    [self.view addSubview:navController.view];
    [viewController didMoveToParentViewController:self];
}

@end
