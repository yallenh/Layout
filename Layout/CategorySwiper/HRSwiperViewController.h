//
//  HRSwiperViewController.h
//  Layout
//
//  Created by Allen on 1/10/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRVerticalDataProtocol.h"

@interface HRSwiperViewController : UICollectionViewController

@property (nonatomic) NSArray <id<HRVerticalDataProtocol>> *dataSource;

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout verticalClass:(Class)verticalClass dataSource:(NSArray <id<HRVerticalDataProtocol>> *)dataSource;

@end
