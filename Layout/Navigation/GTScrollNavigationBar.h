//
//  GTScrollNavigationBar.h
//  Layout
//
//  Created by Allen on 1/6/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GTScrollNavigationBarState) {
    GTScrollNavigationBarStateNone,
    GTScrollNavigationBarStateScrollingDown,
    GTScrollNavigationBarStateScrollingUp
};

@interface GTScrollNavigationBar : UINavigationBar

@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) GTScrollNavigationBarState scrollState;

- (void)resetToDefaultPositionWithAnimation:(BOOL)animated;

@end

@interface UINavigationController (GTScrollNavigationBarAdditions)

@property(strong, nonatomic, readonly) GTScrollNavigationBar *scrollNavigationBar;

@end
