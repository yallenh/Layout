//
//  NSString+HRSSSize.h
//  HRSlideShowDemo
//
//  Created by William  Lu on 3/7/14.
//  Copyright (c) 2014 Yahoo!. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (HRSSSize)


- (CGSize)hrss_sizeWithFont:(UIFont *)font;
- (CGSize)hrss_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;


@end
