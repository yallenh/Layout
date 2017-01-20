//
//  HRGradientScrollNavBar.m
//  Layout
//
//  Created by Allen on 1/9/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRGradientScrollNavBar.h"
#import <QuartzCore/QuartzCore.h>

#define kNearZero 0.000001f

typedef NS_ENUM(NSInteger, HRScrollNavigationBarState) {
    HRScrollNavigationBarStateNone,
    HRScrollNavigationBarStateScrollingDown,
    HRScrollNavigationBarStateScrollingUp
};

static CGFloat const kInCallStatusBarHeight = 40.f;
static CGFloat const kInCallStatusBarHeightIncreasing = 20.f;

@interface HRGradientScrollNavBar () <UIGestureRecognizerDelegate>

@property (nonatomic) UIPanGestureRecognizer* panGesture;
@property (nonatomic) HRScrollNavigationBarState scrollState;
@property (nonatomic) CGFloat lastContentOffsetY;
@property (nonatomic) CGFloat alpha;
@end

@implementation HRGradientScrollNavBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.panGesture.delegate = self;
    self.panGesture.cancelsTouchesInView = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationDidChange) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

#pragma mark - Properties
- (void)setScrollView:(UIScrollView*)scrollView
{
    if (!scrollView) {
        return;
    }
    _scrollView = scrollView;
    if (self.panGesture.view) {
        [self.panGesture.view removeGestureRecognizer:self.panGesture];
    }
    [scrollView addGestureRecognizer:self.panGesture];
    [self resetToDefaultPositionWithAnimation:NO];
}

#pragma mark - Public methods
- (void)resetToDefaultPositionWithAnimation:(BOOL)animated
{
    self.scrollState = HRScrollNavigationBarStateNone;
    [UIView beginAnimations:@"HRScrollNavigationBarAnimation" context:nil];

    // reset nav bar
    CGRect frame = self.frame;
    frame.origin.y = [self statusBarTopOffset];
    self.frame = frame;

    // reset scroll view
    if (self.scrollView && !self.lock) {
        CGRect parentViewFrame = self.scrollView.superview.frame;
        CGFloat offsetY = parentViewFrame.origin.y;
        parentViewFrame.origin.y -= offsetY;
        parentViewFrame.size.height += offsetY;
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentOffset.y - offsetY);
        self.scrollView.superview.frame = parentViewFrame;
    }
    [UIView commitAnimations];
}

#pragma mark - Notifications
- (void)statusBarOrientationDidChange
{
    [self resetToDefaultPositionWithAnimation:NO];
}

- (void)applicationDidBecomeActive
{
    [self resetToDefaultPositionWithAnimation:NO];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - panGesture handler
- (void)handlePan:(UIPanGestureRecognizer*)gesture
{
    if (!self.scrollView || gesture.view != self.scrollView) {
        return;
    }
    // Don't try to scroll navigation bar if there's not enough room
    if (self.scrollView.frame.size.height + (self.bounds.size.height * 2) >=
        self.scrollView.contentSize.height) {
        return;
    }

    CGFloat contentOffsetY = self.scrollView.contentOffset.y;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.scrollState = HRScrollNavigationBarStateNone;
        self.lastContentOffsetY = contentOffsetY;
        return;
    }
    CGFloat deltaY = contentOffsetY - self.lastContentOffsetY;
    if (deltaY < 0) {
        self.scrollState = HRScrollNavigationBarStateScrollingDown;
    }
    else if (deltaY > 0) {
        self.scrollState = HRScrollNavigationBarStateScrollingUp;
    }

    CGRect frame = self.frame;
    CGFloat alpha = 1.f;
    CGFloat maxY = [self statusBarTopOffset];
    CGFloat minY = maxY - CGRectGetHeight(frame);
    CGFloat contentInsetTop = self.scrollView.contentInset.top;
    BOOL isBouncePastTopEdge = contentOffsetY < -contentInsetTop;
    if (isBouncePastTopEdge && CGRectGetMinY(frame) == maxY) {
        self.lastContentOffsetY = contentOffsetY;
        return;
    }

    bool isScrolling = (self.scrollState == HRScrollNavigationBarStateScrollingUp ||
                        self.scrollState == HRScrollNavigationBarStateScrollingDown);
    bool gestureIsActive = (gesture.state != UIGestureRecognizerStateEnded &&
                            gesture.state != UIGestureRecognizerStateCancelled);
    if (isScrolling && !gestureIsActive) {
        // Animate navigation bar to end position
        if (self.scrollState == HRScrollNavigationBarStateScrollingDown) {
            frame.origin.y = maxY;
            alpha = 1.f;
        }
        else if (self.scrollState == HRScrollNavigationBarStateScrollingUp) {
            frame.origin.y = minY;
            alpha = kNearZero;
        }
        [self setFrame:frame alpha:alpha animated:YES];
    }
    else if (gestureIsActive) {
        // Move navigation bar with the change in contentOffsetY
        frame.origin.y -= deltaY;
        frame.origin.y = MIN(maxY, MAX(frame.origin.y, minY));
        alpha = (frame.origin.y - (minY + maxY)) / (maxY - (minY + maxY));
        alpha = MAX(kNearZero, alpha);
        [self setFrame:frame alpha:alpha animated:NO];
    }

    // When panning down at begining of scrollView and the bar is expanding, do not update lastContentOffsetY
    if (!(isBouncePastTopEdge && CGRectGetMinY(frame) != maxY)) {
        self.lastContentOffsetY = contentOffsetY;
    }
}

#pragma mark - helper methods
- (CGFloat)statusBarTopOffset
{
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    CGFloat topOffset = MIN(CGRectGetMaxX(statusBarFrame), CGRectGetMaxY(statusBarFrame));
    return (topOffset == kInCallStatusBarHeight) ? (topOffset - kInCallStatusBarHeightIncreasing) : topOffset;
}

- (void)setFrame:(CGRect)frame alpha:(CGFloat)alpha animated:(BOOL)animated
{
    // immutable check
    if (self.frame.origin.y == frame.origin.y && self.alpha == alpha) {
        return;
    }

    if (animated) {
        [UIView beginAnimations:@"HRScrollNavigationBarAnimation" context:nil];
    }
    CGFloat offsetY = CGRectGetMinY(frame) - CGRectGetMinY(self.frame);
    [self.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        BOOL isBackgroundView = (idx == 0);
        BOOL isViewHidden = view.hidden || view.alpha == 0;
        if (!isBackgroundView && !isViewHidden) {
            view.alpha = alpha;
        }
    }];

    self.frame = frame;
    self.alpha = alpha;

    if (self.scrollView && !self.lock) {
        CGRect parentViewFrame = self.scrollView.superview.frame;
        parentViewFrame.origin.y += offsetY;
        parentViewFrame.size.height -= offsetY;
        self.scrollView.superview.frame = parentViewFrame;
    }
    if (animated) {
        [UIView commitAnimations];
    }
}

#pragma mark - Gradient Layer
- (void)layoutSubviews
{
    [super layoutSubviews];
    // allow all layout subviews call to adjust the frame
    if (self.gradientLayer) {
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        self.gradientLayer.frame = CGRectMake(0, 0 - statusBarHeight, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + statusBarHeight);
        // make sure the graident layer is at position 1
        [self.layer insertSublayer:self.gradientLayer atIndex:1];
    }
}

@end



@implementation UINavigationController (HRGradientScrollNavBarAdditions)

@dynamic gradientScrollNavBar;

- (HRGradientScrollNavBar *)gradientScrollNavBar
{
    return (HRGradientScrollNavBar *)self.navigationBar;
}

@end
