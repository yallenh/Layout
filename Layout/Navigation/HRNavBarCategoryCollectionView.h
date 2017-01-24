//
//  HRNavBarCategoryCollectionView.h
//  Layout
//
//  Created by Allen on 1/20/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRNavBarCategoryProtocol.h"

typedef NS_ENUM(NSUInteger, HRNavBarCategoryType) {
    HRNavBarCategoryTypeNews,
    HRNavBarCategoryTypeMy
};

@interface HRNavBarCategoryCollectionView : UICollectionView
<
    HRNavBarCategoryProtocol
>

@property (nonatomic) NSArray *categories;
@property (nonatomic) CGFloat translationX;
@property (nonatomic) NSUInteger highlightedIndex;
@property (nonatomic, weak) id<HRNavBarCategorySwitchDelegate> switchDelegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end
