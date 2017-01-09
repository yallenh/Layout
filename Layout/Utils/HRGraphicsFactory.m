//
//  HRGraphicsFactory.m
//  Layout
//
//  Created by Allen on 1/9/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRGraphicsFactory.h"

@implementation HRGraphicsFactory

+ (instancetype)sharedFactory
{
    static dispatch_once_t onceToken;
    static HRGraphicsFactory *factory;
    dispatch_once(&onceToken, ^{
        factory = [[HRGraphicsFactory alloc] init];
    });
    return factory;
}

- (CAGradientLayer *)generateGradientLayerWithColors:(NSArray *)colorArray gradientType:(HRGraphicsFactoryGradientType)gradientType points:(NSArray *)points size:(CGSize)size
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);

    // Validate colors.
    NSMutableArray *colors = [NSMutableArray array];
    for (id object in colorArray) {
        if (![object isKindOfClass:[UIColor class]]) {
            return nil;
        }
        [colors addObject:CFBridgingRelease(CGColorCreateCopy([(UIColor *)object CGColor]))];
    }
    gradientLayer.colors = colors;

    // Validate points.
    BOOL usePoints = (points.count == colors.count);
    if (usePoints) {
        CGFloat previousValue = 0.0;
        for (NSInteger i = 0; i < points.count; i++) {
            id object = [points objectAtIndex:i];
            if (![object isKindOfClass:[NSNumber class]]) {
                usePoints = NO;
                break;
            }
            NSNumber *value = object;
            if ([value doubleValue] < 0.0 || [value doubleValue] > 1.0 || [value doubleValue] < previousValue) {
                usePoints = NO;
                break;
            }
            else {
                previousValue = [value doubleValue];
            }
        }
    }
    if (usePoints) {
        gradientLayer.locations = points;
    }
    if (gradientType == kHRGraphicsFactoryGradientTypeVertical) {
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1.f);
    }
    else if (gradientType == kHRGraphicsFactoryGradientTypeHorizontal) {
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.f, 0.5);
    }
    else if (gradientType == kHRGraphicsFactoryGradientTypeBottomLeftToUpperRight) {
        gradientLayer.startPoint = CGPointMake(0, 1.f);
        gradientLayer.endPoint = CGPointMake(1.f, 0);
    }
    return gradientLayer;
}

@end
