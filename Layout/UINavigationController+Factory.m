//
//  UINavigationController+Factory.m
//  Layout
//
//  Created by Allen on 1/9/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "UINavigationController+Factory.h"

// utils
#import "UIColor+Utils.h"
#import "HRGraphicsFactory.h"

// Header
#define kHeaderGradientLightPurple @"#A956F8"
#define kHeaderGradientDarkPurple @"#8300FF"

@implementation UINavigationController (Factory)

+ (UINavigationController *)homeTabNavigationController
{
    UINavigationController *navController = [[UINavigationController alloc] initWithNavigationBarClass:[HRGradientScrollNavBar class] toolbarClass:nil];

    // background gradient
    [[HRGradientScrollNavBar appearance] setGradientLayer:[[HRGraphicsFactory sharedFactory] generateGradientLayerWithColors:@[[UIColor colorWithHex:kHeaderGradientLightPurple], [UIColor colorWithHex:kHeaderGradientDarkPurple]] gradientType:kHRGraphicsFactoryGradientTypeHorizontal points:nil size:CGSizeZero]];
    navController.navigationBar.translucent = NO;

    // navigation items
    navController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didTapSideBar)];
    navController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(didTapMsgBox)];
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, navController.navigationBar.frame.size.width, 20.f)];
    textField.backgroundColor = [UIColor blackColor];
    navController.navigationItem.titleView = textField;

    return navController;
}

+ (void)didTapSideBar
{
    NSLog(@"didTapSideBar");
}

+ (void)didTapMsgBox
{
}

@end
