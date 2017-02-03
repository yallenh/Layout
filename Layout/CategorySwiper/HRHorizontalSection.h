//
//  HRHorizontalSection.h
//  Layout
//
//  Created by Allen on 02/02/2017.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRCollectionSectionModel.h"

@interface HRHorizontalSection : HRCollectionSectionModel

- (instancetype)initWithDataSourceItems:(NSArray *)dataSourceItems verticalSections:(NSArray *)verticalSections;

@end
