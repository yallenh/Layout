//
//  HRStickyHeaderFlowLayout.h
//  Layout
//
//  Created by Allen on 1/5/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HRStickyHeaderFlowLayoutType) {
    HRStickyHeaderFlowLayoutTypeReplace,
    HRStickyHeaderFlowLayoutTypeStack
};


@interface HRStickyHeaderFlowLayout : UICollectionViewFlowLayout

@property (nonatomic) HRStickyHeaderFlowLayoutType type;
@property (nonatomic) NSIndexSet *stickySections;

@end
