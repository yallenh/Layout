//
//  UINavigationController+Factory.m
//  Layout
//
//  Created by Allen on 1/9/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "UINavigationController+Factory.h"

#import "HRNavBarCategoryCollectionView.h"

// utils
#import "UIColor+Utils.h"
#import "HRGraphicsFactory.h"

#define HRHomeHeaderSeachOpenBrowser


static NSString *kHeaderGradientLightPurple = @"#A956F8";
static NSString *kHeaderGradientDarkPurple = @"#8300FF";
static NSString *kHeaderSideBarIcon = @"icon_menu";
static NSString *kHeaderSearchIcon = @"icon_tinySearch";
static CGFloat const kHeaderSearchTextFieldHeight = 30.f;
static CGFloat const kHeaderSearchFontSize = 18.f;

@implementation UINavigationController (Factory)

#pragma mark -- Public methods

+ (UINavigationController *)homeTabNavigationController
{
    [HRGradientScrollNavBar appearance].gradientLayer = [UINavigationController horizontalGradientLayer];
    UINavigationController *navController = [[UINavigationController alloc] initWithNavigationBarClass:[HRGradientScrollNavBar class] toolbarClass:nil];
    navController.navigationBar.translucent = NO;
    navController.navigationItem.leftBarButtonItem = [UINavigationController hamburgerBarButtonItem];
    navController.navigationItem.rightBarButtonItem = [UINavigationController msgBarButtonItem];

    // search input
#ifdef HRHomeHeaderSeachOpenBrowser
    UIButton *inputBox = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, navController.navigationBar.frame.size.width, kHeaderSearchTextFieldHeight)];
    [inputBox addTarget:self action:@selector(didWantOpenBrowser) forControlEvents:UIControlEventTouchUpInside];
#else
    UITextField *inputBox = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, navController.navigationBar.frame.size.width, kHeaderSearchTextFieldHeight)];
    inputBox.font = [UIFont systemFontOfSize:kHeaderSearchFontSize];
#endif
    inputBox.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    inputBox.layer.cornerRadius = 2.f;
    NSTextAttachment *placeholderImageTextAttachment = [[NSTextAttachment alloc] init];
    placeholderImageTextAttachment.image = [UIImage imageNamed:kHeaderSearchIcon];
    // use 'bound' to adjust position and size
    placeholderImageTextAttachment.bounds = CGRectMake(-2.f, -2.f, kHeaderSearchFontSize, kHeaderSearchFontSize);
    NSMutableAttributedString *placeholderImageString = [[NSAttributedString attributedStringWithAttachment:placeholderImageTextAttachment] mutableCopy];
    // append the placeholder text
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"網頁搜尋"];
    [placeholderImageString appendAttributedString:placeholderString];
    // set as (attributed) placeholder
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [placeholderImageString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [placeholderString length] + 1)];
#ifdef HRHomeHeaderSeachOpenBrowser
    [inputBox setAttributedTitle:placeholderImageString forState:UIControlStateNormal];
#else
    inputBox.attributedPlaceholder = placeholderImageString;
#endif
    navController.navigationItem.titleView = inputBox;

    return navController;
}

+ (UINavigationController *)newsTabNavigationController
{
    [HRGradientScrollNavBar appearance].gradientLayer = [UINavigationController horizontalGradientLayer];
    UINavigationController *navController = [[UINavigationController alloc] initWithNavigationBarClass:[HRGradientScrollNavBar class] toolbarClass:nil];
    navController.navigationItem.titleView = [[HRNavBarCategoryCollectionView alloc] initWithFrame:CGRectMake(0, 0, navController.navigationBar.frame.size.width, kHeaderSearchTextFieldHeight)];
    navController.navigationBar.translucent = NO;
    navController.navigationItem.leftBarButtonItem = [UINavigationController hamburgerBarButtonItem];
    navController.navigationItem.rightBarButtonItem = [UINavigationController searchBarButtonItem];
    return navController;
}

#pragma mark -- Private methods

+ (CAGradientLayer *)horizontalGradientLayer
{
    return [[HRGraphicsFactory sharedFactory] generateGradientLayerWithColors:@[[UIColor colorWithHex:kHeaderGradientLightPurple], [UIColor colorWithHex:kHeaderGradientDarkPurple]] gradientType:kHRGraphicsFactoryGradientTypeHorizontal points:nil size:CGSizeZero];
}

+ (UIBarButtonItem *)hamburgerBarButtonItem
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kHeaderSideBarIcon] style:UIBarButtonItemStylePlain target:self action:@selector(didWantOpenSideBar)];
    button.tintColor = [UIColor whiteColor];
    return button;
}

+ (UIBarButtonItem *)msgBarButtonItem
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(didWantOpenMsgBox)];
    button.tintColor = [UIColor clearColor];
    return button;
}

+ (UIBarButtonItem *)searchBarButtonItem
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(didWantOpenBrowser)];
    button.tintColor = [UIColor whiteColor];
    return button;
}

#pragma mark -- Handlers

+ (void)didWantOpenSideBar
{
    NSLog(@"didWantOpenSideBar");
}

+ (void)didWantOpenMsgBox
{
    NSLog(@"didWantOpenMsgBox");
}

+ (void)didWantOpenBrowser
{
    NSLog(@"didTapSearchInput");
}

@end
