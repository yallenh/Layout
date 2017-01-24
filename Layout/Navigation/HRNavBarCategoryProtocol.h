//
//  HRNavBarCategoryProtocol.h
//  Layout
//
//  Created by Allen on 1/24/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HRNavBarCategoryProtocol;

@protocol HRNavBarCategorySwitchDelegate <NSObject>

- (void)navBarCategory:(id<HRNavBarCategoryProtocol>)navBarCategory didWantToSwitchToIndexPath:(NSIndexPath *)indexPath;

@end

@protocol HRNavBarCategoryProtocol <NSObject>

@property (nonatomic) NSArray *categories;
@property (nonatomic) CGFloat translationX;
@property (nonatomic) NSUInteger highlightedIndex;
@property (nonatomic, weak) id<HRNavBarCategorySwitchDelegate> switchDelegate;

@end
