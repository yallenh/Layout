//
//  HRCollectionSectionController.h
//  Layout
//
//  Created by Allen on 02/02/2017.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRCollectionSectionModel.h"

@class HRCollectionSectionController;

@protocol HRCollectionSectionControllerDelegate <NSObject>

// Inheritance from HRCollectionSectionModelDelegate
- (void)collectionSection:(HRCollectionSectionModel *)sectionModel didWantToReloadWithCompletion:(void (^)(BOOL finished))completion;

@optional

// Inheritance from HRCollectionSectionModelDelegate
- (void)collectionSection:(HRCollectionSectionModel *)sectionModel didWantToReloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths completion:(void (^)(BOOL finished))completion;
- (void)collectionSection:(HRCollectionSectionModel *)sectionModel didWantToInsertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths completion:(void (^)(BOOL finished))completion;
- (void)collectionSection:(HRCollectionSectionModel *)sectionModel didWantToDeleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths completion:(void (^)(BOOL finished))completion;

- (void)collectionSectionsDidUpdate;

- (NSInteger)collectionSectionController:(HRCollectionSectionController *)collectionSectionController collectionView:(UICollectionView *)collectionView numberOfItemsInSectionModel:(HRCollectionSectionModel *)sectionModel;

- (id)collectionSectionController:(HRCollectionSectionController *)collectionSectionController dataSourceItemAtIndexPath:(NSIndexPath *)indexPath inSectionModel:(HRCollectionSectionModel *)sectionModel;

@end

@interface HRCollectionSectionController : NSObject

@property (nonatomic, weak) id<HRCollectionSectionControllerDelegate> delegate;

- (void)insertCollectionSectionModel:(HRCollectionSectionModel *)sectionModel atIndex:(NSUInteger)index;

- (void)removeCollectionSectionModel:(HRCollectionSectionModel *)sectionModel;

- (void)registerCellReuseIdentifierOfCollectionSectionModel:(HRCollectionSectionModel *)sectionModel inCollectionView:(UICollectionView *)collectionView;

- (void)registerCellReuseIdentifierOfCollectionSectionsInCollectionView:(UICollectionView *)collectionView;

- (HRCollectionSectionModel *)collectionSectionModelAtIndex:(NSUInteger)index;

- (NSUInteger)indexOfCollectionSectionModel:(HRCollectionSectionModel *)sectionModel;

- (id)dataSourceItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)dataSourceItemsAtSection:(NSUInteger)section;

- (NSUInteger)numberOfSections;

- (NSUInteger)numberOfItemsInSection:(NSInteger)section;

@end
