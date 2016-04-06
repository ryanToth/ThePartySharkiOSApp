//
//  SearchViewController.h
//  PartyShark
//
//  Created by Ri Zhao on 2016-03-08.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "searchTableViewCell.h"
#import "SBSearchBar.h"
#import "AFNetworking.h"
#import "songFactory.h"
#import "songDataModel.h"
#import "MNMBottomPullToRefreshManager.h"

@interface SearchViewController : BaseViewController <SBSearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, MNMBottomPullToRefreshManagerClient>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MNMBottomPullToRefreshManager *refreshControl;

@property (strong, nonatomic) NSMutableArray *searchResultArray;

- (void)SBSearchBarSearchButtonClicked:(SBSearchBar *)searchBar;                     // called when keyboard search button pressed
- (void)SBSearchBarCancelButtonClicked:(SBSearchBar *)searchBar;                     // called when cancel button is pressed

- (BOOL)SBSearchBarShouldBeginEditing:(SBSearchBar *)searchBar;                      // return NO to not become first responder
- (void)SBSearchBarTextDidBeginEditing:(SBSearchBar *)searchBar;                     // called when text starts editing
- (BOOL)SBSearchBarShouldEndEditing:(SBSearchBar *)searchBar;                        // return NO to not resign first responder
- (void)SBSearchBarTextDidEndEditing:(SBSearchBar *)searchBar;

-(void) addSongToPlaylist: (searchTableViewCell*) cell :(NSIndexPath *)indexPath;
- (void) loadRefreshScroll;

@end
