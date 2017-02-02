//
//  HRCollectionSectionModel_private.h
//  Layout
//
//  Created by Allen on 02/02/2017.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRCollectionSectionModel.h"

@protocol HRCollectionSectionModelDelegate <NSObject>

- (void)collectionSection:(HRCollectionSectionModel *)sectionModel didWantToReloadWithCompletion:(void (^)(BOOL finished))completion;

@optional

- (void)collectionSection:(HRCollectionSectionModel *)sectionModel didWantToReloadItemsAtIndexes:(NSIndexSet *)indexes completion:(void (^)(BOOL finished))completion;
- (void)collectionSection:(HRCollectionSectionModel *)sectionModel didWantToInsertItemsAtIndexes:(NSIndexSet *)indexes completion:(void (^)(BOOL finished))completion;
- (void)collectionSection:(HRCollectionSectionModel *)sectionModel didWantToDeleteItemsAtIndexes:(NSIndexSet *)indexes completion:(void (^)(BOOL finished))completion;

@end



@interface HRCollectionSectionModel ()

@property (nonatomic, readonly) NSArray *dataSourceItems;
@property (nonatomic, weak) id<HRCollectionSectionModelDelegate> delegate;

@end
