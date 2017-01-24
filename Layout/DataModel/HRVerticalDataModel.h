//
//  HRVerticalDataModel.h
//  Layout
//
//  Created by Allen on 1/24/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRVerticalDataProtocol.h"

@interface HRVerticalDataModel : NSObject <HRVerticalDataProtocol>

@property (readonly, nonatomic) NSString *categoryDisplayName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
