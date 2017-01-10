//
//  UINavigationController+Factory.h
//  Layout
//
//  Created by Allen on 1/9/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRGradientScrollNavBar.h"

@interface UINavigationController (Factory)

+ (UINavigationController *)homeTabNavigationController;
+ (UINavigationController *)newsTabNavigationController;

@end
