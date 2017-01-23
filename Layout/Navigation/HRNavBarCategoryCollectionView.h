//
//  HRNavBarCategoryCollectionView.h
//  Layout
//
//  Created by Allen on 1/20/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HRNavBarCategoryType) {
    HRNavBarCategoryTypeNews,
    HRNavBarCategoryTypeMy
};

@interface HRNavBarCategoryCollectionView : UICollectionView

@property (nonatomic) NSArray *categories;
@property (nonatomic) CGFloat translationX;

- (instancetype)initWithFrame:(CGRect)frame;

@end
