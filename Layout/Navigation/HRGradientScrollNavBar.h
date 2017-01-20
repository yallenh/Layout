//
//  HRGradientScrollNavBar.h
//  Layout
//
//  Created by Allen on 1/9/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRGradientScrollNavBar : UINavigationBar

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) CAGradientLayer *gradientLayer;

@property (nonatomic) BOOL lock;

- (void)resetToDefaultPositionWithAnimation:(BOOL)animated;

@end

@interface UINavigationController (HRGradientScrollNavBarAdditions)

@property (nonatomic, readonly) HRGradientScrollNavBar *gradientScrollNavBar;

@end
