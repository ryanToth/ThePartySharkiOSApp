//
//  MainViewController.h
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-22.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "MGSwipeTableCell.h"
#include "MGSwipeButton.h"
#import "BaseViewController.h"
#import "CurrentSongTableViewCell.h"    
#import "playlistTableViewCell.h"
#import "AFNetworking.h"
#import "playlistSongFactory.h"
#import "playlistSongDataModel.h"


@interface MainViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *currentSongView;
@property (strong, nonatomic) UITableView *playlistView;

@property (strong, nonatomic)   NSArray *indexArray;
@property (nonatomic)           int             rowCount;

@property (strong, nonatomic) NSMutableArray *playlistContentsArray;

typedef void (^requestCompletionBlock)(BOOL success, NSMutableArray *requests, NSError *error);

@property(strong, nonatomic) NSArray *titles;
@property(strong, nonatomic) UIRefreshControl *refreshControl;

@property(strong, nonatomic) NSTimer *interpolationTimer;
@property(strong, nonatomic) NSTimer *timer;



- (void) getPlaylist;
- (void) upvoteSong: (NSNumber*) songCode;
- (void) downvoteSong: (NSNumber*) songCode;
- (void) vetoSong: (NSNumber*) songCode;

- (void) playSong;
- (void) pauseSong;
- (BOOL) isSongPlaying;

@end
