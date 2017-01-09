//
//  HRGraphicsFactory.h
//  Layout
//
//  Created by Allen on 1/9/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HRGraphicsFactoryGradientType)  {
    kHRGraphicsFactoryGradientTypeHorizontal,
    kHRGraphicsFactoryGradientTypeVertical,
    kHRGraphicsFactoryGradientTypeBottomLeftToUpperRight
};

@interface HRGraphicsFactory : NSObject

+ (instancetype)sharedFactory;

- (CAGradientLayer *)generateGradientLayerWithColors:(NSArray *)colorArray gradientType:(HRGraphicsFactoryGradientType)gradientType points:(NSArray *)points size:(CGSize)size;

@end
