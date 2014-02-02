//
//  CVSearchViewController.m
//  pixster
//
//  Created by Dinesh Joshi on 2/2/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "CVSearchViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "SearchImage.h"
#import "ImageCell.h"

@interface CVSearchViewController ()
@property (nonatomic, strong) NSMutableArray *imageResults;
@property (nonatomic) BOOL loadingMoreContent;

@end

@implementation CVSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSLog(@"INIT!!");
    if (self) {
        self.title = @"Pixster";
        self.imageResults = [NSMutableArray array];
        NSLog(@"INIT!!");

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.title = @"Pixster";
        self.imageResults = [NSMutableArray array];
        NSLog(@"INIT!!");
        self.loadingMoreContent=NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"ImageCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UISearchDisplay delegate

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    [self.imageResults removeAllObjects];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return NO;
}


#pragma mark - UISearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    NSLog(@"Search button clicked!");

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@", [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        id results = [JSON valueForKeyPath:@"responseData.results"];
        if ([results isKindOfClass:[NSArray class]]) {
            //[self.imageResults removeAllObjects];
            //[self.imageResults addObjectsFromArray:results];
            self.imageResults = [SearchImage initWithJSONArray:results];
//            NSLog(@"%@", results);
            NSLog(@"No. of images: %d", self.imageResults.count);

//            [self.searchDisplayController.searchResultsTableView reloadData]; // TODO: change this
            [self.collectionView reloadData]; // TODO: change this
        }
    } failure:nil];
    
    [operation start];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    return YES;
}



#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.imageResults.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor whiteColor];
    ImageCell *iCell = (ImageCell *) cell;
    
    iCell.imageView.image = nil;
    
    SearchImage *img = [self.imageResults objectAtIndex:indexPath.row];
    [iCell.imageView setImageWithURL:img.imgUrl];

    
    // if cell being requested is the end of the model, load more data
    if (indexPath.row+1 >= self.imageResults.count && self.loadingMoreContent==NO) {
        

        NSLog(@"Need to load more cells...");
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@&start=%d", [self.outSearchBar.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], self.imageResults.count]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            id results = [JSON valueForKeyPath:@"responseData.results"];
            if ([results isKindOfClass:[NSArray class]]) {
                self.imageResults = [SearchImage addImagesFromJSONArray:self.imageResults addArray:results];
                NSLog(@"No. of images: %d", self.imageResults.count);
                self.loadingMoreContent=NO;
                [self.collectionView reloadData]; // TODO: change this
            }
        } failure:^( NSURLRequest *request , NSHTTPURLResponse *response , NSError *error, id JSON )
                                             {
                                                 NSLog(@"Error! %@", error);
                                             }
                                             
                                             ];
        
        [operation start];

    }
    return cell;
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchImage *img = self.imageResults[indexPath.row];
    CGSize retval = img.width > 0 ? CGSizeMake(img.width, img.height) : CGSizeMake(100, 100);
    //retval.height += 35; retval.width += 35;
    return retval;
}

//- (UIEdgeInsets)collectionView:
//(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(50, 20, 50, 20);
//}


#pragma mark – UIScrollViewDelegate

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    NSLog(@"Decelerating...");
//}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
//    if (bottomEdge >= scrollView.contentSize.height) {
//        NSLog(@"Bottom edge hit...");
//    }
//    NSLog(@"Content Offset: x = %f y = %f", targetContentOffset->x, targetContentOffset->y);
//    NSLog(@"BottomEdge = %f height = %f COff: x = %f y = %f", bottomEdge, scrollView.frame.size.height, scrollView.contentOffset.x, scrollView.contentOffset.y);
//    
//}


@end
