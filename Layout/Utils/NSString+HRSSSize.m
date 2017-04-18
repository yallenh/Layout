//
//  NSString+HRSSSize.m
//  HRSlideShowDemo
//
//  Created by William  Lu on 3/7/14.
//  Copyright (c) 2014 Yahoo!. All rights reserved.
//

#import "NSString+HRSSSize.h"

@implementation NSString (HRSSSize)


/***************************************************************************************************
 * sizeWithFont is deprecated in iOS 7.0.  if iOS >= 7.0, use sizeWithAttributes
 *
 * @param font    - font to size with
 * @return CGSize - size with font
 **************************************************************************************************/
- (CGSize)hrss_sizeWithFont:(UIFont *)font
{
    CGSize size;
    
    // if minimum deployment version is 7.0, just use new method.  If minimum deployment version is
    // < 7.0, check with os version and use appropriate method.  conditional compilation is used to
    // eliminate compiler warning for deprecated method when deployment version is 7.0
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
    size = [self sizeWithAttributes:@{ NSFontAttributeName: font }];
#else
    if ([self respondsToSelector:@selector(sizeWithAttributes:)]) {
        size = [self sizeWithAttributes:@{ NSFontAttributeName: font }];
    }
    else {
        size = [self sizeWithFont:font];
    }
#endif
    
    return size;
}


/***************************************************************************************************
 * sizeWithFont:contrainedToSize is deprecated in iOS 7.0.  if iOS >= 7.0, use
 * boundingRectWithSize:options:attributes:context:
 *
 * @param font              - font to size with
 * @param maxSize           - maximum size
 * @return CGSize           - size with font
 **************************************************************************************************/
- (CGSize)hrss_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)maxSize
{
    // initialize size but one of the following two conditions must be true so size will be updated
    CGSize size = CGSizeZero;
    
    // if minimum deployment version is 7.0, just use new method.  If minimum deployment version is
    // < 7.0, check with os version and use appropriate method.  conditional compilation is used to
    // eliminate compiler warning for deprecated method when deployment version is 7.0
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        size = [self boundingRectWithSize:maxSize
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{ NSFontAttributeName: font }
                                  context:nil].size;
    }
    // iOS 6
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    else {
        size = [self sizeWithFont:font constrainedToSize:maxSize];
    }
#endif
    
    return size;
}


@end
