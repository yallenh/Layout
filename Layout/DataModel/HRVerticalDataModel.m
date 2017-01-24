//
//  HRVerticalDataModel.m
//  Layout
//
//  Created by Allen on 1/24/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRVerticalDataModel.h"

@interface HRVerticalDataModel ()

@property (nonatomic) NSString *categoryDisplayName;

@end

@implementation HRVerticalDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.categoryDisplayName = [dictionary objectForKey:@"display_name"];
    }
    return self;
}

@end
