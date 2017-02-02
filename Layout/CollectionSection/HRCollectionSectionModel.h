//
//  HRCollectionSectionModel.h
//  Layout
//
//  Created by Allen on 02/02/2017.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRCollectionSectionModel : NSObject

// UICollectionView methods
typedef void(^HRCollectionSectionRegisterForCellReuseIdentifierBlock)(UICollectionView *collectionView);
typedef UICollectionViewCell *(^HRCollectionSectionCellForItemAtIndexPathBlock)(UICollectionView *collectionView, NSIndexPath *indexPath, id dataSourceItemAtIndexPath);
typedef UICollectionReusableView *(^HRCollectionSectionSupplementaryViewForElementKindAtIndexPathBlock)(UICollectionView *collectionView, NSString *elementKind, NSIndexPath *indexPath, id dataSourceItemAtIndexPath);

// UICollectionViewDelegate methods
typedef BOOL(^HRCollectionSectionShouldHighlightItemAtIndexPathBlock)(UICollectionView *collectionView, NSIndexPath *indexPath, id dataSourceItemAtIndexPath);
typedef void(^HRCollectionSectionDidSelectItemAtIndexPathBlock)(UICollectionView *collectionView, NSIndexPath *indexPath, id dataSourceItemAtIndexPath);
typedef void(^HRCollectionSectionWillDisplayCellForItemAtIndexPathBlock)(UICollectionView *collectionView, UICollectionViewCell *cell, NSIndexPath *indexPath, id dataSourceItemAtIndexPath);
typedef void(^HRCollectionSectionDidEndDisplayingCellForItemAtIndexPathBlock)(UICollectionView *collectionView, UICollectionViewCell *cell, NSIndexPath *indexPath, id dataSourceItemAtIndexPath);
typedef void(^HRCollectionSectionWillDisplaySupplementaryViewForElementKindAtIndexPathBlock)(UICollectionView *collectionView, UICollectionReusableView *view, NSString *elementKind, NSIndexPath *indexPath, id dataSourceItemAtIndexPath);
typedef void(^HRCollectionSectionDidEndDisplaySupplementaryViewForElementKindAtIndexPathBlock)(UICollectionView *collectionView, UICollectionReusableView *view, NSString *elementKind, NSIndexPath *indexPath, id dataSourceItemAtIndexPath);

// UICollectionViewDelegateFlowLayout methods
typedef CGSize(^HRCollectionSectionLayoutSizeForItemAtIndexPathBlock)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSIndexPath *indexPath, id dataSourceItemAtIndexPath);
typedef CGSize(^HRCollectionSectionLayoutReferenceSizeForHeaderInSectionBlock)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSUInteger section, NSArray *dataSourceItems);
typedef CGSize(^HRCollectionSectionLayoutReferenceSizeForFooterInSectionBlock)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSUInteger section, NSArray *dataSourceItems);
typedef UIEdgeInsets(^HRCollectionSectionLayoutInsectForSectionAtIndexBlock)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSUInteger section, NSArray *dataSourceItems);
typedef CGFloat(^HRCollectionSectionLayoutMinimumInteritemSpacingAtIndexBlock)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSUInteger section, NSArray *dataSourceItems);
typedef CGFloat(^HRCollectionSectionLayoutMinimumLineSpacingAtIndexBlock)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSUInteger section, NSArray *dataSourceItems);



@property (nonatomic, copy) HRCollectionSectionRegisterForCellReuseIdentifierBlock registerForCellReuseIdentifierBlock;
@property (nonatomic, copy) HRCollectionSectionCellForItemAtIndexPathBlock cellForItemAtIndexPathBlock;
@property (nonatomic, copy) HRCollectionSectionSupplementaryViewForElementKindAtIndexPathBlock supplementaryViewForElementKindAtIndexPathBlock;

@property (nonatomic, copy) HRCollectionSectionShouldHighlightItemAtIndexPathBlock shouldHighlightItemAtIndexPathBlock;
@property (nonatomic, copy) HRCollectionSectionDidSelectItemAtIndexPathBlock sectionDidSelectItemAtIndexPathBlock;
@property (nonatomic, copy) HRCollectionSectionWillDisplayCellForItemAtIndexPathBlock willDisplayCellForItemAtIndexPathBlock;
@property (nonatomic, copy) HRCollectionSectionDidEndDisplayingCellForItemAtIndexPathBlock didEndDisplayingCellForItemAtIndexPathBlock;
@property (nonatomic, copy) HRCollectionSectionWillDisplaySupplementaryViewForElementKindAtIndexPathBlock willDisplaySupplementaryViewForElementKindAtIndexPathBlock;
@property (nonatomic, copy) HRCollectionSectionDidEndDisplaySupplementaryViewForElementKindAtIndexPathBlock didEndDisplaySupplementaryViewForElementKindAtIndexPathBlock;

@property (nonatomic, copy) HRCollectionSectionLayoutSizeForItemAtIndexPathBlock layoutSizeForItemAtIndexPathBlock;
@property (nonatomic, copy) HRCollectionSectionLayoutReferenceSizeForHeaderInSectionBlock layoutReferenceSizeForHeaderInSectionBlock;
@property (nonatomic, copy) HRCollectionSectionLayoutReferenceSizeForFooterInSectionBlock layoutReferenceSizeForFooterInSectionBlock;
@property (nonatomic, copy) HRCollectionSectionLayoutInsectForSectionAtIndexBlock layoutInsectForSectionAtIndexBlock;
@property (nonatomic, copy) HRCollectionSectionLayoutMinimumInteritemSpacingAtIndexBlock layoutMinimumInteritemSpacingAtIndexBlock;
@property (nonatomic, copy) HRCollectionSectionLayoutMinimumLineSpacingAtIndexBlock layoutMinimumLineSpacingAtIndexBlock;


- (instancetype)initWithDataSourceItems:(NSArray *)dataSourceItems;

- (void)updateWithDataSourceItems:(NSArray *)dataSourceItems completion:(void (^)(BOOL finished))completion;
- (void)reloadSectionWithCompletion:(void (^)(BOOL finished))completion;
- (void)reloadItemsAtIndexes:(NSIndexSet *)indexes completion:(void (^)(BOOL finished))completion;
- (void)insertItemsAtIndexes:(NSIndexSet *)indexes withDataSourceItems:(NSArray *)items completion:(void (^)(BOOL finished))completion;
- (void)deleteItemsAtIndexes:(NSIndexSet *)indexes completion:(void (^)(BOOL finished))completion;

@end
