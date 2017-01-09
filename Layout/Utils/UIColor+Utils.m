//
//  UIColor+Utils.m
//  Layout
//
//  Created by Allen on 1/9/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "UIColor+Utils.h"
#import <objc/message.h>

@implementation UIColor (Utils)

+ (UIColor *)colorWithHex:(NSString *)hex
{
    if (hex.length) {
        SEL sel = NSSelectorFromString(hex);
        if ([[UIColor class] respondsToSelector:sel]) {
            id (*messageSend)(id, SEL) = (void *)objc_msgSend;
            return messageSend([UIColor class], sel);
        }
    }
    if ([hex hasPrefix:@"#"]) {
        hex = [hex stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
    }
    
    if ([hex isEqualToString:@"0x0"] || [hex isEqualToString:@"0"]) {
        return [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }
    NSUInteger rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:(unsigned int *)&rgbValue];
    
    NSUInteger prefix = [hex hasPrefix:@"0x"] ? 2 : 0;
    switch (hex.length - prefix) {
        case 6: // without alpha, e.g 123456
            return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0 green:((rgbValue & 0xFF00) >> 8) / 255.0 blue:(rgbValue & 0xFF) / 255.0 alpha:1.0f];
            break;
        case 8: // with alpha, e.g 12345601
        {
            return [UIColor colorWithRed:((rgbValue & 0xFF000000) >> 24) / 255.0 green:((rgbValue & 0xFF0000) >> 16) / 255.0 blue:((rgbValue & 0xFF00) >> 8) / 255.0 alpha:(rgbValue & 0xFF) / 255.0];
            break;
        }
        default:
            NSAssert(NO, @"Wrong color hex format.  Use rrggbb or rrggbbaa.");
            return nil;
    }
}

@end
