//
//  CVSearchViewController.h
//  pixster
//
//  Created by Dinesh Joshi on 2/2/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVSearchViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchDisplayDelegate, UISearchBarDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *outSearchBar;

@end
