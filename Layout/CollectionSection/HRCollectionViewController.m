//
//  HRCollectionViewController.m
//  Layout
//
//  Created by Allen on 02/02/2017.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRCollectionViewController.h"

@implementation HRCollectionViewController

- (instancetype)init
{
    if (self = [super init]) {
        [self setUpSectionController];
    }
    return self;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout]) {
        [self setUpSectionController];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUpSectionController];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setUpSectionController];
    }
    return self;
}

- (void)setUpSectionController
{
    self.collectionController = [[HRCollectionSectionController alloc] init];
    self.collectionController.delegate = self;
}

#pragma mark -- HRCollectionSectionControllerDelegate
- (void)collectionSection:(HRCollectionSectionModel *)sectionModel didWantToReloadWithCompletion:(void (^)(BOOL finished))completion
{
    NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:[self.collectionController indexOfCollectionSectionModel:sectionModel]];
    [self.collectionView reloadSections:set];
}

- (void)collectionSection:(HRCollectionSectionModel *)sectionModel didWantToReloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths completion:(void (^)(BOOL finished))completion
{
    __weak typeof (self) weakSelf = self;
    [self.collectionView performBatchUpdates:^{
        [weakSelf.collectionView reloadItemsAtIndexPaths:indexPaths];
    } completion:completion];
}
//- (void)collectionSection:(HRCollectionSectionModel *)sectionModel didWantToInsertItemsAtIndexPaths:(NSArray <NSIndexPath *>*)indexPaths completion:(void (^)(BOOL finished))completion
//{
//}
//- (void)collectionSection:(HRCollectionSectionModel *)sectionModel didWantToDeleteItemsAtIndexPaths:(NSArray <NSIndexPath *>*)indexPaths completion:(void (^)(BOOL finished))completion
//{
//}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HRCollectionSectionModel *sectionModel = [self.collectionController collectionSectionModelAtIndex:indexPath.section];
    id dataSourceItem = [self.collectionController dataSourceItemAtIndexPath:indexPath];
    if (sectionModel.sectionDidSelectItemAtIndexPathBlock) {
        sectionModel.sectionDidSelectItemAtIndexPathBlock(collectionView, indexPath, dataSourceItem);
    }
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.collectionController numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.collectionController numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HRCollectionSectionModel *sectionModel = [self.collectionController collectionSectionModelAtIndex:indexPath.section];
    id dataSourceItem = [self.collectionController dataSourceItemAtIndexPath:indexPath];
    if (sectionModel.cellForItemAtIndexPathBlock) {
        UICollectionViewCell *cell = sectionModel.cellForItemAtIndexPathBlock(collectionView, indexPath, dataSourceItem);
        return cell;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HRCollectionSectionModel *sectionModel = [self.collectionController collectionSectionModelAtIndex:indexPath.section];
    if (sectionModel.supplementaryViewForElementKindAtIndexPathBlock) {
        UICollectionReusableView *cell = sectionModel.supplementaryViewForElementKindAtIndexPathBlock(collectionView, kind, indexPath, nil);
        return cell;
    }
    return nil;
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HRCollectionSectionModel *sectionModel = [self.collectionController collectionSectionModelAtIndex:indexPath.section];
    id dataSourceItem = [self.collectionController dataSourceItemAtIndexPath:indexPath];
    if (sectionModel.layoutSizeForItemAtIndexPathBlock) {
        return sectionModel.layoutSizeForItemAtIndexPathBlock(collectionView, collectionViewLayout, indexPath, dataSourceItem);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    HRCollectionSectionModel *sectionModel = [self.collectionController collectionSectionModelAtIndex:section];
    NSArray *dataSourceItems = [self.collectionController dataSourceItemsAtSection:section];
    if (sectionModel.layoutReferenceSizeForHeaderInSectionBlock) {
        return sectionModel.layoutReferenceSizeForHeaderInSectionBlock(collectionView, collectionViewLayout, section, dataSourceItems);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    HRCollectionSectionModel *sectionModel = [self.collectionController collectionSectionModelAtIndex:section];
    NSArray *dataSourceItems = [self.collectionController dataSourceItemsAtSection:section];
    if (sectionModel.layoutReferenceSizeForFooterInSectionBlock) {
        return sectionModel.layoutReferenceSizeForFooterInSectionBlock(collectionView, collectionViewLayout, section, dataSourceItems);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    HRCollectionSectionModel *sectionModel = [self.collectionController collectionSectionModelAtIndex:section];
    NSArray *dataSourceItems = [self.collectionController dataSourceItemsAtSection:section];
    if (sectionModel.layoutInsectForSectionAtIndexBlock) {
        return sectionModel.layoutInsectForSectionAtIndexBlock(collectionView, collectionViewLayout, section, dataSourceItems);
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    HRCollectionSectionModel *sectionModel = [self.collectionController collectionSectionModelAtIndex:section];
    NSArray *dataSourceItems = [self.collectionController dataSourceItemsAtSection:section];
    if (sectionModel.layoutMinimumInteritemSpacingAtIndexBlock) {
        return sectionModel.layoutMinimumInteritemSpacingAtIndexBlock(collectionView, collectionViewLayout, section, dataSourceItems);
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    HRCollectionSectionModel *sectionModel = [self.collectionController collectionSectionModelAtIndex:section];
    NSArray *dataSourceItems = [self.collectionController dataSourceItemsAtSection:section];
    if (sectionModel.layoutMinimumLineSpacingAtIndexBlock) {
        return sectionModel.layoutMinimumLineSpacingAtIndexBlock(collectionView, collectionViewLayout, section, dataSourceItems);
    }
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    HRCollectionSectionModel *sectionModel = [self.collectionController collectionSectionModelAtIndex:indexPath.section];
    id dataSourceItem = [self.collectionController dataSourceItemAtIndexPath:indexPath];
    if (sectionModel.willDisplayCellForItemAtIndexPathBlock) {
        sectionModel.willDisplayCellForItemAtIndexPathBlock(collectionView, cell, indexPath, dataSourceItem);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    HRCollectionSectionModel *sectionModel = [self.collectionController collectionSectionModelAtIndex:indexPath.section];
    id dataSourceItem = [self.collectionController dataSourceItemAtIndexPath:indexPath];
    if (sectionModel.didEndDisplayingCellForItemAtIndexPathBlock) {
        sectionModel.didEndDisplayingCellForItemAtIndexPathBlock(collectionView, cell, indexPath, dataSourceItem);
    }
}

@end
