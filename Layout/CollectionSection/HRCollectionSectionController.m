//
//  HRCollectionSectionController.m
//  Layout
//
//  Created by Allen on 02/02/2017.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRCollectionSectionController.h"
#import "HRCollectionSectionModel_private.h"

@interface HRCollectionSectionController () <HRCollectionSectionModelDelegate>

@property (nonatomic) NSMutableArray *collectionSectionModels;

@end

@implementation HRCollectionSectionController

- (NSMutableArray *)collectionSectionModels
{
    if (!_collectionSectionModels) {
        _collectionSectionModels = [[NSMutableArray alloc] init];
    }
    return _collectionSectionModels;
}

- (void)insertCollectionSectionModel:(HRCollectionSectionModel *)sectionModel atIndex:(NSUInteger)index
{
    if (index > [self.collectionSectionModels count]) {
        [self.collectionSectionModels addObject:sectionModel];
    }
    else {
        [self.collectionSectionModels insertObject:sectionModel atIndex:index];
    }
    sectionModel.delegate = self;
    if ([self.delegate respondsToSelector:@selector(collectionSectionsDidUpdate)]) {
        [self.delegate collectionSectionsDidUpdate];
    }
}

- (void)removeCollectionSectionModel:(HRCollectionSectionModel *)sectionModel
{
    if ([self.collectionSectionModels indexOfObject:sectionModel] != NSNotFound) {
        [self.collectionSectionModels removeObject:sectionModel];
        if ([self.delegate respondsToSelector:@selector(collectionSectionsDidUpdate)]) {
            [self.delegate collectionSectionsDidUpdate];
        }
    }
}

- (void)registerCellReuseIdentifierOfCollectionSectionModel:(HRCollectionSectionModel *)sectionModel inCollectionView:(UICollectionView *)collectionView
{
    if (collectionView && sectionModel.registerForCellReuseIdentifierBlock) {
        sectionModel.registerForCellReuseIdentifierBlock(collectionView);
    }
}

- (void)registerCellReuseIdentifierOfCollectionSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (!collectionView) {
        return;
    }
    [self.collectionSectionModels enumerateObjectsUsingBlock:^(HRCollectionSectionModel *sectionModel, NSUInteger idx, BOOL *stop) {
        if (sectionModel.registerForCellReuseIdentifierBlock) {
            sectionModel.registerForCellReuseIdentifierBlock(collectionView);
        }
    }];
}

- (HRCollectionSectionModel *)collectionSectionModelAtIndex:(NSUInteger)index
{
    if (index < [self.collectionSectionModels count]) {
        return [self.collectionSectionModels objectAtIndex:index];
    }
    return nil;
}

- (NSUInteger)indexOfCollectionSectionModel:(HRCollectionSectionModel *)sectionModel
{
    return [self.collectionSectionModels indexOfObject:sectionModel];
}

- (id)dataSourceItemAtIndexPath:(NSIndexPath *)indexPath
{
    HRCollectionSectionModel *sectionModel = [self collectionSectionModelAtIndex:indexPath.section];
    if (sectionModel && (indexPath.row < [sectionModel.dataSourceItems count])) {
        return [sectionModel.dataSourceItems objectAtIndex:indexPath.row];
    }
    return nil;
}

- (NSArray *)dataSourceItemsAtSection:(NSUInteger)section
{
    HRCollectionSectionModel *sectionModel = [self collectionSectionModelAtIndex:section];
    if (sectionModel) {
        return sectionModel.dataSourceItems;
    }
    return nil;
}

- (NSUInteger)numberOfSections
{
    return [self.collectionSectionModels count];
}

- (NSUInteger)numberOfItemsInSection:(NSInteger)section
{
    return [[self collectionSectionModelAtIndex:section].dataSourceItems count];
}



#pragma mark HRCollectionSectionModelDelegate
- (void)collectionSection:(HRCollectionSectionModel *)sectionModel didWantToReloadWithCompletion:(void (^)(BOOL finished))completion
{
    [self.delegate collectionSection:sectionModel didWantToReloadWithCompletion:completion];
}

- (void)collectionSection:(HRCollectionSectionModel *)sectionModel didWantToReloadItemsAtIndexes:(NSIndexSet *)indexes completion:(void (^)(BOOL finished))completion
{
    if (![self.delegate respondsToSelector:@selector(collectionSection:didWantToReloadItemsAtIndexPaths:completion:)]) {
        NSAssert(NO, @"delegate method collectionSection:didWantToReloadItemsAtIndexPaths:completion: was not implemented in delegate: %@", [self.delegate class]);
        return;
    }
    NSArray *indexPaths = [self indexPathsOfCollectionSectionModel:sectionModel withIndexes:indexes];
    [self.delegate collectionSection:sectionModel didWantToReloadItemsAtIndexPaths:indexPaths completion:completion];
}

- (void)collectionSection:(HRCollectionSectionModel *)sectionModel didWantToInsertItemsAtIndexes:(NSIndexSet *)indexes completion:(void (^)(BOOL finished))completion
{
    if (![self.delegate respondsToSelector:@selector(collectionSection:didWantToInsertItemsAtIndexPaths:completion:)]) {
        NSAssert(NO, @"delegate method collectionSection:didWantToInsertItemsAtIndexPaths:completion: was not implemented in delegate: %@", [self.delegate class]);
        return;
    }
    NSArray *indexPaths = [self indexPathsOfCollectionSectionModel:sectionModel withIndexes:indexes];
    [self.delegate collectionSection:sectionModel didWantToInsertItemsAtIndexPaths:indexPaths completion:completion];
}

- (void)collectionSection:(HRCollectionSectionModel *)sectionModel didWantToDeleteItemsAtIndexes:(NSIndexSet *)indexes completion:(void (^)(BOOL finished))completion
{
    if (![self.delegate respondsToSelector:@selector(collectionSection:didWantToDeleteItemsAtIndexPaths:completion:)]) {
        NSAssert(NO, @"delegate method collectionSection:didWantToDeleteItemsAtIndexPaths:completion: was not implemented in delegate: %@", [self.delegate class]);
        return;
    }
    NSArray *indexPaths = [self indexPathsOfCollectionSectionModel:sectionModel withIndexes:indexes];
    [self.delegate collectionSection:sectionModel didWantToDeleteItemsAtIndexPaths:indexPaths completion:completion];
}




#pragma mark Private Methods
- (NSArray <NSIndexPath *>*)indexPathsOfCollectionSectionModel:(HRCollectionSectionModel *)sectionModel withIndexes:(NSIndexSet *)indexes
{
    NSUInteger section = [self indexOfCollectionSectionModel:sectionModel];
    NSMutableArray *indexPaths = [NSMutableArray array];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
    }];
    return indexPaths;
}

@end
