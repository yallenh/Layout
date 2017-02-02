//
//  HRVerticalStreamSection.m
//  Layout
//
//  Created by Allen on 02/02/2017.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRVerticalStreamSection.h"

@implementation HRVerticalStreamSection

- (void)setUp
{
    __weak typeof (self) weakSelf = self;
    self.registerForCellReuseIdentifierBlock = ^(UICollectionView *collectionView) {
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    };
    self.cellForItemAtIndexPathBlock = ^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath, id dataSourceItemAtIndexPath) {
        typeof (weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return nil;
        }
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
        [weakSelf setText:[NSString stringWithFormat:@"%tu - %tu", indexPath.section, indexPath.row] onView:[cell.subviews firstObject]];
        cell.backgroundColor = [@[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor blueColor]] objectAtIndex:indexPath.row % 5];
        return cell;
    };
    self.supplementaryViewForElementKindAtIndexPathBlock = ^UICollectionReusableView *(UICollectionView *collectionView, NSString *kind, NSIndexPath *indexPath, id dataSourceItemAtIndexPath) {
        typeof (weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return nil;
        }
        UICollectionReusableView *cell;
        if (kind == UICollectionElementKindSectionHeader) {
            cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
            [weakSelf setText:[NSString stringWithFormat:@"section %tu", indexPath.section] onView:cell];
            cell.backgroundColor = [UIColor lightGrayColor];
        } else {
            cell = [[UICollectionReusableView alloc] init];
        }
        return cell;
    };
    self.layoutSizeForItemAtIndexPathBlock = ^CGSize(UICollectionView *collectionView, UICollectionViewLayout *layout, NSIndexPath *indexPath, id dataSourceItemAtIndexPath) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 200.f);
    };
    self.layoutReferenceSizeForHeaderInSectionBlock = ^CGSize(UICollectionView *collectionView, UICollectionViewLayout *layout, NSUInteger section, NSArray *dataSourceItems) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 50.f);
    };
    self.sectionDidSelectItemAtIndexPathBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath, id dataSourceItemAtIndexPath) {
        NSLog(@"%@", indexPath);
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
