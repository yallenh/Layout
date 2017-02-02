//
//  HRCollectionViewController.h
//  Layout
//
//  Created by Allen on 02/02/2017.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRCollectionSectionController.h"

@protocol HRCollectionViewControllerProtocol <NSObject>

@property (nonatomic) HRCollectionSectionController *collectionController;

@end

@interface HRCollectionViewController : UICollectionViewController
<
    HRCollectionViewControllerProtocol,
    HRCollectionSectionControllerDelegate
>

@property (nonatomic) HRCollectionSectionController *collectionController;

@end
