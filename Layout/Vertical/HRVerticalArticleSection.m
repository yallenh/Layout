//
//  HRVerticalArticleSection.m
//  Layout
//
//  Created by Allen on 03/02/2017.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRVerticalArticleSection.h"

@implementation HRVerticalArticleSection

- (instancetype)init
{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithDataSourceItems:(NSArray *)dataSourceItems
{
    if (self = [super initWithDataSourceItems:dataSourceItems]) {
        [self setUp];
    }
    return  self;
}

- (void)setUp
{
    __weak typeof (self) weakSelf = self;
    self.registerForCellReuseIdentifierBlock = ^(UICollectionView *collectionView) {
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    };
    self.cellForItemAtIndexPathBlock = ^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath, id dataSourceItemAtIndexPath) {
        typeof (weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return nil;
        }
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
        [weakSelf setText:@"article content" onView:[cell.subviews firstObject]];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    };
    self.layoutSizeForItemAtIndexPathBlock = ^CGSize(UICollectionView *collectionView, UICollectionViewLayout *layout, NSIndexPath *indexPath, id dataSourceItemAtIndexPath) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 2 * CGRectGetHeight(collectionView.frame));
    };
    self.sectionDidSelectItemAtIndexPathBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath, id dataSourceItemAtIndexPath) {
    };
}

- (void)setText:(NSString *)text onView:(UIView *)view
{
    UILabel *label;
    if (!view.subviews.count) {
        label = [[UILabel alloc] initWithFrame:view.bounds];
        [view addSubview:label];
    } else {
        label = [view.subviews firstObject];
    }
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
}

@end
