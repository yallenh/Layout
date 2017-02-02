//
//  HRCollectionSectionModel.m
//  Layout
//
//  Created by Allen on 02/02/2017.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRCollectionSectionModel.h"
#import "HRCollectionSectionModel_private.h"

@interface HRCollectionSectionModel ()

@property (nonatomic) NSMutableArray* internalDataSourceItems;

@end

@implementation HRCollectionSectionModel

- (instancetype)initWithDataSourceItems:(NSArray *)dataSourceItems
{
    if (self = [super init]) {
        _internalDataSourceItems = [dataSourceItems mutableCopy];
    }
    return self;
}

- (NSArray *)dataSourceItems
{
    NSArray *dataSourceItems = [_internalDataSourceItems copy];
    return dataSourceItems;
}

- (NSMutableArray *)internalDataSourceItems
{
    if (!_internalDataSourceItems) {
        _internalDataSourceItems = [[NSMutableArray alloc] init];
    }
    return _internalDataSourceItems;
}

- (void)updateWithDataSourceItems:(NSArray *)dataSourceItems completion:(void (^)(BOOL finished))completion
{
    _internalDataSourceItems = [dataSourceItems mutableCopy];
    [self reloadSectionWithCompletion:completion];
}

- (void)reloadSectionWithCompletion:(void (^)(BOOL finished))completion
{
    [self.delegate collectionSection:self didWantToReloadWithCompletion:completion];
}

- (void)reloadItemsAtIndexes:(NSIndexSet *)indexes completion:(void (^)(BOOL finished))completion
{
    if (![self.delegate respondsToSelector:@selector(collectionSection:didWantToReloadItemsAtIndexes:completion:)]) {
        NSAssert(NO, @"delegate method collectionSection:didWantToReloadItemsAtIndexes:completion: was not implemented in delegate: %@", [self.delegate class]);
        return;
    }
    [self.delegate collectionSection:self didWantToReloadItemsAtIndexes:indexes completion:completion];
}

- (void)insertItemsAtIndexes:(NSIndexSet *)indexes withDataSourceItems:(NSArray *)items completion:(void (^)(BOOL finished))completion
{
    if (![self.delegate respondsToSelector:@selector(collectionSection:didWantToInsertItemsAtIndexes:completion:)]) {
        NSAssert(NO, @"delegate method collectionSection:didWantToInsertItemsAtIndexes:completion: was not implemented");
        return;
    }
    [self.internalDataSourceItems insertObjects:items atIndexes:indexes];
    [self.delegate collectionSection:self didWantToInsertItemsAtIndexes:indexes completion:completion];
}

- (void)deleteItemsAtIndexes:(NSIndexSet *)indexes completion:(void (^)(BOOL finished))completion
{
    if (![self.delegate respondsToSelector:@selector(collectionSection:didWantToDeleteItemsAtIndexes:completion:)]) {
        NSAssert(NO, @"delegate method collectionSection:didWantToDeleteItemsAtIndexes:completion: was not implemented in delegate: %@", [self.delegate class]);
        return;
    }
    [self.internalDataSourceItems removeObjectsAtIndexes:indexes];
    [self.delegate collectionSection:self didWantToDeleteItemsAtIndexes:indexes completion:completion];
}

@end
