//
//  MainViewController.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-22.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "MainViewController.h"
#import "NavigationManager.h"

@interface MainViewController ()

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.timer = [NSTimer timerWithTimeInterval:5.1f target:self selector:@selector(handlePeriodicRefresh:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    //NSTimer* interpolationTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(handleInterpolation:) userInfo:nil repeats:YES];
    //[[NSRunLoop mainRunLoop] addTimer:interpolationTimer forMode:NSDefaultRunLoopMode];
    
     
    self.currentSongView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, self.view.frame.size.width, 200 ) style:UITableViewStylePlain];
    self.currentSongView.scrollEnabled = NO;
    
    self.playlistView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height - 200) style:UITableViewStylePlain];
    self.playlistView.alwaysBounceVertical = YES;
    
    [self.view addSubview:self.currentSongView];
    [self.view addSubview:self.playlistView];
    
    self.currentSongView.delegate = self;
    self.currentSongView.dataSource = self;
    
    self.playlistView.delegate = self;
    self.playlistView.dataSource = self;

    
    
    //refresh
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.playlistView addSubview:self.refreshControl];
    
    self.playlistView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.currentSongView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Gets called twice for some reason
    [self reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self.timer invalidate];
    [self.interpolationTimer invalidate];
    
}



- (void) reloadData{
    
    [self getPlaylist];
    // [self isSongPlaying];
    
    [self.currentSongView reloadData];
    [self.playlistView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    //wrap with if authenticated function so it doesnt pop up everytime

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //SECTIONS
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //ROWS
    if (tableView == self.currentSongView) {
        
        if (self.playlistContentsArray.count == 0) return 0;
        
        return 1;
    }else {
        if (self.playlistContentsArray.count == 0) return 0;
        
        return self.playlistContentsArray.count - 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    
    UIImage *myImage = [UIImage imageNamed:@"tutorial_background_00@2x.jpg"];
    UIImage *upIcon = [UIImage imageNamed:@"up.jpg"];
    UIImage *downIcon = [UIImage imageNamed:@"down.jpg"];
    
    if (tableView == self.currentSongView) {
        //UIImage *myImage = [UIImage imageNamed:@"tutorial_background_00@2x.jpg"];
        
        NSString *identifier = @"DockCurrentSongCell";
        CurrentSongTableViewCell *cell = (CurrentSongTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"dockCurrentSongCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.delegate = self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        cell.artistLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        cell.albumLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        //If user is admin, give augmented controls
        NSString *isAdmin = [[NSUserDefaults standardUserDefaults] stringForKey:@"is_admin"];
        
        if ([isAdmin isEqualToString:@"1"]) {
        
            cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"skip song" backgroundColor:[UIColor redColor]callback:^BOOL(MGSwipeTableCell *sender) {
                //skip functionality

                NSNumber *songCode = cell.songCellCode;
                
                [self vetoSong: songCode];
                NSLog(@"skipped");
                
                return YES;
                
            }], [MGSwipeButton buttonWithTitle:@"play/pause" backgroundColor:[UIColor blueColor]callback:^BOOL(MGSwipeTableCell *sender) {
                
                //play/pause functionality
                
                NSString *isSongPlaying = [[NSUserDefaults standardUserDefaults] stringForKey:@"is_playing"];
                
                if ([isSongPlaying isEqualToString:@"1"]) {
                    [self pauseSong];
                }
                
                else {
                    [self playSong];
                }
                
                return YES;
            }]];
            
            cell.rightSwipeSettings.transition = MGSwipeTransitionDrag;
        }
        
        playlistSongDataModel *songModel = self.playlistContentsArray[indexPath.row];
        
        NSString* upvoteText = [NSString stringWithFormat:@"upvote\n\n%@", songModel.upVotes];
        NSString* downvoteText = [NSString stringWithFormat:@"downvote\n\n%@", songModel.downVotes];
        
        cell.leftButtons = @[[MGSwipeButton buttonWithTitle:upvoteText backgroundColor:[UIColor greenColor]callback:^BOOL(MGSwipeTableCell *sender) {
            
            //upvote functionality
            //get songcode from the sender
            NSNumber *songCode = cell.songCellCode;
            
            [self upvoteSong: songCode];
            
            return YES;
        }], [MGSwipeButton buttonWithTitle:downvoteText backgroundColor:[UIColor redColor]callback:^BOOL(MGSwipeTableCell *sender) {
            
            //downvote functionality
            //Get songcode from the sender
            NSNumber *songCode = cell.songCellCode;
            
            [self downvoteSong: songCode];
            
            return YES;
        }]];
        
        cell.songCellCode = songModel.playthroughCode;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CurrentSongTableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
            if (updateCell)
                [self getMoreSongInfoCurrentSong:updateCell :songModel];
        });
        
        return cell;
    }else {
        
        NSString *identifier2 = @"playlistCell";
        playlistTableViewCell *cell2 = (playlistTableViewCell *) [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell2 == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"playlistSongCell" owner:self options:nil];
            cell2 = [nib objectAtIndex:0];
        }
        
        cell2.delegate = self;
        
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //If user is admin, give augmented controls
        NSString *isAdmin = [[NSUserDefaults standardUserDefaults] stringForKey:@"is_admin"];
        
        if ([isAdmin isEqualToString:@"1"]) {
            
            cell2.rightButtons = @[[MGSwipeButton buttonWithTitle:@"remove song" backgroundColor:[UIColor redColor]callback:^BOOL(MGSwipeTableCell *sender) {
            
                //remove functionality
                //get songcode from the sender
                [self vetoSong: cell2.songCellCode];
            
                return YES;
            }]];
            cell2.rightSwipeSettings.transition = MGSwipeTransitionDrag;
        }
        
        if (indexPath.row + 1 >= self.playlistContentsArray.count) return nil;
        
        playlistSongDataModel *songModel = self.playlistContentsArray[indexPath.row + 1];
        
        NSString* upvoteText = [NSString stringWithFormat:@"upvote\n\n%@", songModel.upVotes];
        NSString* downvoteText = [NSString stringWithFormat:@"downvote\n\n%@", songModel.downVotes];
        
        cell2.leftButtons = @[[MGSwipeButton buttonWithTitle:upvoteText backgroundColor:[UIColor greenColor]callback:^BOOL(MGSwipeTableCell *sender) {
            
            //upvote functionality
            //get songcode from the sender
            NSNumber *songCode = cell2.songCellCode;
            
            [self upvoteSong: songCode];
            
            return YES;
        }], [MGSwipeButton buttonWithTitle:downvoteText backgroundColor:[UIColor redColor]callback:^BOOL(MGSwipeTableCell *sender) {
            
            //downvote functionality
            //Get songcode from the sender
            NSNumber *songCode = cell2.songCellCode;
            
            [self downvoteSong: songCode];
            
            return YES;
        }]];
        cell2.leftSwipeSettings.transition = MGSwipeTransitionDrag;
        
        NSString* displayName = [[songModel.songSuggester stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString];
        
        cell2.suggestorLabel.text = displayName;
        cell2.voteLabel.text = [NSString stringWithFormat:@"%@", songModel.netVotes];
        
        if ([songModel.netVotes doubleValue] > [@0 doubleValue])
            cell2.voteLabel.textColor = [UIColor greenColor];
        else if ([songModel.netVotes doubleValue] < [@0 doubleValue])
            cell2.voteLabel.textColor = [UIColor redColor];
        else
            cell2.voteLabel.textColor = [UIColor blueColor];
        
        cell2.songCellCode = songModel.playthroughCode;
        
        if (songModel.songTitle == nil) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            playlistTableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
            if (updateCell)
                [self getMoreSongInfoPlaylist:updateCell :songModel];
        });
        }
        
        else {
            cell2.titleLabel.text = songModel.songTitle;
            cell2.artistLabel.text = songModel.songArtist;
            cell2.artworkImage.image = songModel.albumArt;
        }
        
        return cell2;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if  (tableView == self.currentSongView){
        return 150;
    }else {
        return 80;
    }
    
}

-(BOOL) didRecievePlayerTransferRequest :(requestCompletionBlock)completionBlock {
    
    __block BOOL success = NO;
    
    NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@/playertransfers", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"]];
    
    NSDictionary *parameters = @{};
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    
    [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            
            NSLog(@"Error: %@", error);
            completionBlock(NO, nil, nil);
            
        } else {
            
            NSMutableArray *oldPlayerTransfersArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"transfer_requests"]];
            
            NSMutableArray *properties = [responseObject objectForKey:@"properties"];
            NSMutableArray *values = [responseObject objectForKey:@"values"];
            
            NSInteger codeIndex = [properties indexOfObject:@"code"];
            NSInteger suggesterIndex = [properties indexOfObject:@"requester"];
            
            NSMutableArray *activeTransferRequests = [[NSMutableArray alloc]init];
            
            for (int i = 0; i < values.count; i++){
                
                if (![oldPlayerTransfersArray containsObject:[values[i] objectAtIndex:codeIndex]]) {
                
                    NSMutableArray *transferRequest = [[NSMutableArray alloc] init];
                
                    NSNumber *cv = [values[i] objectAtIndex:codeIndex];
                    
                    [transferRequest addObject:[values[i] objectAtIndex:suggesterIndex]];
                    [transferRequest addObject:cv];
                
                    [activeTransferRequests addObject:transferRequest];
                }
            }
            
            if (activeTransferRequests.count != 0) {
                
                success = YES;
                completionBlock(YES, activeTransferRequests, nil);
                
            }
            else {
                success = NO;
                completionBlock(NO, nil, nil);
            }
        }
    }];
    [dataTask resume];
    
    return success;
}

-(void) displayPlayerTransferRequest :(NSString*)transferID : (NSString*) username {
    
    [self.timer invalidate];
    self.timer = nil;
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = NO;
    alert.backgroundType = Blur;
    
    [alert addButton:@"Accept" validationBlock:^BOOL{ return YES; } actionBlock:^{
    
        [self acceptPlayerTransfer:transferID];
    
    }];
    
    UIColor *color = [UIColor colorWithRed:246.0/255.0 green:82.0/255.0 blue:8.0/255.0 alpha:1.0];
    
    alert.labelTitle.font = [UIFont fontWithName:@"System" size:14.0f];
    
    [alert showCustom:self image:[UIImage imageNamed:@"Icon-40@3x.png"] color:color title:@"Player Transfer Request For" subTitle:username closeButtonTitle:@"Cancel" duration:0.0f];
    
    [alert alertIsDismissed:^{
        
        NSMutableArray *newPlayerTransfersArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"transfer_requests"]];
        
        [newPlayerTransfersArray addObject:transferID];
        
        NSArray *newSavedArray = [newPlayerTransfersArray copy];
        
        [[NSUserDefaults standardUserDefaults] setObject:newSavedArray forKey:@"transfer_requests"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.timer = [NSTimer timerWithTimeInterval:5.1f target:self selector:@selector(handlePeriodicRefresh:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        
    }];
    
}

#pragma refreshcontrol

- (void)handleRefresh:(id)sender
{
    // do your refresh here...
    NSLog(@"data reloaded");
    [self reloadData];
    
    [self.currentSongView reloadData];
    [self.playlistView reloadData];
    
    [self.refreshControl endRefreshing];
}

- (void)handlePeriodicRefresh:(id)sender
{
    
    // do your refresh here...
    NSLog(@"data reloaded every 5 seconds");
    
    [self isSongPlaying];
    
    NSString *isAdmin = [[NSUserDefaults standardUserDefaults] stringForKey:@"is_admin"];
    
    if ([isAdmin isEqualToString:@"1"]) {
        
        [self didRecievePlayerTransferRequest:^(BOOL success, NSMutableArray *requests, NSError *error){
            
            if(!success){
                
                NSLog(@"%@", error);

            }else{
                
                for (int i = 0; i < requests.count; i++) {

                    NSString* displayName = [[requests[i][0] stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString];
                    
                    [self displayPlayerTransferRequest : requests[i][1] : displayName];
                }

            }
        }];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"is_playing"] isEqualToString:@"1"]) {
    
        [self reloadData];
        
        [self.currentSongView reloadData];
        [self.playlistView reloadData];
    }
}

-(void)handleInterpolation: (id)sender {
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"is_playing"] isEqualToString:@"1"] && self.playlistContentsArray.count > 0) {
        playlistSongDataModel *song = self.playlistContentsArray[0];
        double newCompletedRatio = ((([song.songDuration floatValue]*[song.completedRatio floatValue])+1)/[song.songDuration floatValue]);
        
        song.completedRatio = @(newCompletedRatio);
        
        if (newCompletedRatio >= 1) {
            [self reloadData];
            [self.playlistView reloadData];
        }
    
        [self.currentSongView reloadData];
    }
}

-(void) swipeTableCell:(MGSwipeTableCell*) cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive
{
    NSString * str;
    switch (state) {
        case MGSwipeStateNone:
            str = @"None";
            
            self.timer = [NSTimer timerWithTimeInterval:5.1f target:self selector:@selector(handlePeriodicRefresh:) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
            //self.interpolationTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(handleInterpolation:) userInfo:nil repeats:YES];
            
            break;
        case MGSwipeStateSwippingLeftToRight:
            str = @"SwippingLeftToRight";
            
            //[self.interpolationTimer invalidate];
            [self.timer invalidate];
            self.timer = nil;
            
            break;
            
        case MGSwipeStateSwippingRightToLeft:
            str = @"SwippingRightToLeft";
            
            
            //[self.interpolationTimer invalidate];
            [self.timer invalidate];
            self.timer = nil;
            
            break;
        case MGSwipeStateExpandingLeftToRight: str = @"ExpandingLeftToRight"; break;
        case MGSwipeStateExpandingRightToLeft: str = @"ExpandingRightToLeft"; break;
    }
    
    NSLog(@"Swipe state: %@ ::: Gesture: %@", str, gestureIsActive ? @"Active" : @"Ended");
}

- (void) getPlaylist {
    
    playlistSongFactory *fetch = [[playlistSongFactory alloc]init];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("MyQueue", NULL);
    dispatch_async(concurrentQueue, ^{
        [fetch gatherData :^(BOOL success, NSMutableArray *songs, NSError *error) {
            if (!success){
                NSLog(@"%@", error);
            }else {
                self.playlistContentsArray = songs;
                
                for (int i = 0; i < self.playlistContentsArray.count; i++) {
                
                    dispatch_async(concurrentQueue, ^ {
                        
                    });
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.currentSongView reloadData];
                    [self.playlistView reloadData];
                });
            }
        }
        ];
    });
}

- (void) getMoreSongInfoPlaylist: (playlistTableViewCell*) updateCell :(playlistSongDataModel*) currentSong {
    
    playlistSongFactory *fetch = [[playlistSongFactory alloc]init];
    
    [fetch fetchExtraSongData: currentSong:^(BOOL success, playlistSongDataModel* song, NSError *error) {
        
        if (!success) {
            NSLog(@"%@", error);
        }
        else {
            updateCell.titleLabel.text = song.songTitle;
            updateCell.artistLabel.text = song.songArtist;
            updateCell.artworkImage.image = song.albumArt;
            
            currentSong.songTitle = song.songTitle;
            currentSong.songArtist = song.songArtist;
            currentSong.albumArt = song.albumArt;
        }
    }];
    
}

- (void) getMoreSongInfoCurrentSong: (CurrentSongTableViewCell*) updateCell :(playlistSongDataModel*) currentSong {
    
    playlistSongFactory *fetch = [[playlistSongFactory alloc]init];
    
    [fetch fetchExtraSongData: currentSong:^(BOOL success, playlistSongDataModel* song, NSError *error) {
        
        if (!success) {
            NSLog(@"%@", error);
        }
        else {
            updateCell.titleLabel.text = song.songTitle;
            updateCell.artistLabel.text = song.songArtist;
            updateCell.albumLabel.text = song.songAlbum;
            updateCell.albumView.image = song.albumArt;
            
            int minutes = floor(([song.songDuration floatValue]/60));
            int seconds = (int)[song.songDuration floatValue] % 60;
            
            if (seconds > 9)
                updateCell.totalDuration.text = [NSString stringWithFormat:@"%d:%d", minutes, seconds];
            else
                updateCell.totalDuration.text = [NSString stringWithFormat:@"%d:0%d", minutes, seconds];
            
            minutes = floor((([song.songDuration floatValue]*[song.completedRatio floatValue])/60));
            seconds = (int)([song.completedRatio floatValue]*[song.songDuration floatValue]) % 60;
            
            if (seconds > 9)
                updateCell.completedDuration.text = [NSString stringWithFormat:@"%d:%d", minutes, seconds];
            else
                updateCell.completedDuration.text = [NSString stringWithFormat:@"%d:0%d", minutes, seconds];
            
            currentSong.songTitle = song.songTitle;
            currentSong.songArtist = song.songArtist;
            currentSong.albumArt = song.albumArt;
            currentSong.songAlbum = song.songAlbum;
            currentSong.songDuration = song.songDuration;
            currentSong.completedRatio = song.completedRatio;
        }
    }];
    
}

//Need to add server stuff when it makes sense
- (void) upvoteSong: (NSNumber*) songCode {

    NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@/playlist/%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"], songCode];
    
    NSDictionary *parameters = @{@"vote": @0};
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:parameters error:nil];
    
    [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            //Error
            NSLog(@"Error: %@", error);
            
        } else {
            
            NSLog(@"%@ %@", response, responseObject);
            [self getPlaylist];
        }
    }];
    [dataTask resume];
    
    
    
}

//Need to add server stuff when it makes sense
- (void) downvoteSong: (NSNumber*) songCode {

    NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@/playlist/%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"], songCode];
    
    NSDictionary *parameters = @{@"vote": @1};
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:parameters error:nil];
    
    [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            //Error
            NSLog(@"Error: %@", error);
            
        } else {
            
            NSLog(@"%@ %@", response, responseObject);
            [self getPlaylist];
        }
    }];
    [dataTask resume];
    
}

- (void) vetoSong: (NSString*) songCode {
    
    NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@/playlist/%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"], songCode];
    
    NSDictionary *parameters = @{};
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"DELETE" URLString:URLString parameters:parameters error:nil];
    
    [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            //Error
            NSLog(@"Error: %@", error);
            
        } else {

            NSLog(@"%@ %@", response, responseObject);
            
            [self getPlaylist];
        }
    }];
    [dataTask resume];
    
}

- (void) playSong {
    
    NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"]];
    
    NSDictionary *parameters = @{@"is_playing": @YES};
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:parameters error:nil];
    
    [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            //Error
            NSLog(@"Error: %@", error);
            
        } else {
            
            NSLog(@"%@ %@", response, responseObject);
            
            // Saves if the player is currently playing
            [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"is_playing"] forKey:@"is_playing"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
    [dataTask resume];
}

- (void) pauseSong {
    
    NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"]];
    
    NSDictionary *parameters = @{@"is_playing": @NO};
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:parameters error:nil];
    
    [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            //Error
            NSLog(@"Error: %@", error);
            
        } else {
            
            // Saves if the player is currently playing
            [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"is_playing"] forKey:@"is_playing"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    
    [dataTask resume];
}

// Can use this function when updating the playlist every 5 or so seconds to keep everything up-to-date
// Also checks to make sure if you are currently the player or not
// This function should only be used by the player

- (BOOL) isSongPlaying {
    
    NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"]];
    
    NSDictionary *parameters = @{};
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    
    [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            //Error
            NSLog(@"Error: %@", error);
            
        } else {
            
            // Saves if the player is currently playing
            [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"is_playing"] forKey:@"is_playing"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"username"] isEqualToString:[responseObject objectForKey:@"player"]]) {
                
                // You are the player
                
                [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"is_player"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            else {
                [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"is_player"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    
    [dataTask resume];
    
    return [[[NSUserDefaults standardUserDefaults] stringForKey:@"is_playing"] isEqualToString:@"1"];
}

-(void) updatePlaythroughDuration : (NSNumber*) completedRatio : (NSNumber*) songCode {
    
    NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@/playlist/%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"], songCode];
    
    NSDictionary *parameters = @{@"completed_ratio": completedRatio};
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:parameters error:nil];
    
    [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            //Error
            NSLog(@"Error: %@", error);
            
        } else {
            
            NSLog(@"%@ %@", response, responseObject);
            
            [self getPlaylist];
        }
    }];
    [dataTask resume];
    
}

-(void) acceptPlayerTransfer : (NSString*) code {
    
    NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@/playertransfers/%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"], code];
    NSDictionary *parameters = @{@"status": @1};
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:parameters error:nil];
    
    [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);

        } else {
            NSLog(@"Player transfer success");
        }
    }];
    
    [dataTask resume];
    
}



@end
