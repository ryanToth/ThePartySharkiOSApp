//
//  playlistSongFactory.m
//  PartyShark
//
//  Created by Ryan Toth on 2016-03-13.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "playlistSongFactory.h"


@implementation playlistSongFactory

-(id)init{
    self = [super init];
    
    return self;
}

- (void) gatherData : (newCompletionBlock)completionBlock{
    
    [self fetchPlaythroughs :^(BOOL success, NSMutableArray *data, NSError *error) {
        if (!success){
            NSLog(@"%@", error);
        }else{
            if (self.songResultArray) {
                
                completionBlock(YES, self.songResultArray, nil);
                
            }else{
                completionBlock(NO, nil, nil);
            }
        }
    }];
}

- (void) fetchPlaythroughs : (fetchCompletionBlock)completionBlock {
    
   NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@/playlist", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"]];
    
    NSDictionary *parameters = @{};
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    
    [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            //Error
            completionBlock(NO, nil, error);
            NSLog(@"Error: %@", error);
            
        } else {
            
            
            NSDictionary *res = (id)responseObject;
            
            NSMutableArray *properties = [res objectForKey:@"properties"];
            NSMutableArray *values = [res objectForKey:@"values"];
            
            NSInteger codeIndex = [properties indexOfObject:@"code"];
            NSInteger songCodeIndex = [properties indexOfObject:@"song_code"];
            NSInteger positionIndex = [properties indexOfObject:@"position"];
            NSInteger upvotesIndex = [properties indexOfObject:@"upvotes"];
            NSInteger downvotesIndex = [properties indexOfObject:@"downvotes"];
            NSInteger suggesterIndex = [properties indexOfObject:@"suggester"];
            NSInteger completedRatioIndex = [properties indexOfObject:@"completed_ratio"];
            
            
            self.songResultArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < values.count; i++){
                
                playlistSongDataModel *songModel = [[playlistSongDataModel alloc]init];
                
                songModel.playthroughCode = [values[i] objectAtIndex:codeIndex];
                songModel.songCode = [values[i] objectAtIndex:songCodeIndex];
                songModel.songPosition = [values[i] objectAtIndex:positionIndex];
                songModel.upVotes = [values[i] objectAtIndex:upvotesIndex];
                songModel.downVotes = [values[i] objectAtIndex:downvotesIndex];
                songModel.songSuggester = [values[i] objectAtIndex:suggesterIndex];
                songModel.netVotes = [NSNumber numberWithFloat:([songModel.upVotes floatValue] - [songModel.downVotes floatValue])];
                songModel.completedRatio = [values[i] objectAtIndex:completedRatioIndex];
                
                [self.songResultArray addObject:songModel];
            }
            
            self.songResultArray = [self.songResultArray sortedArrayUsingSelector:@selector(compare:)];
            
            completionBlock(YES, nil, nil);
            
            // NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [dataTask resume];
}



- (void) fetchExtraSongData : (playlistSongDataModel*)currentSong :(aquireCompletionBlock)completionBlock {
    
    NSString *URLString = [NSString stringWithFormat:@"http://api.deezer.com/track/%@", currentSong.songCode];
    
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

            NSDictionary *res = (id)responseObject;
            
            NSMutableArray *results = [res objectForKey:@"data"];

            //album title and album picture
            NSDictionary *album = [res objectForKey:@"album"];
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [album objectForKey:@"cover_medium"]]];
            currentSong.songAlbum =    [album objectForKey:@"title"];
            currentSong.albumArt = [UIImage imageWithData: imageData];
            //song title
            currentSong.songTitle =       [res objectForKey:@"title"];
            //artist
            NSDictionary *artistName = [res objectForKey:@"artist"];
            currentSong.songArtist =      [artistName objectForKey:@"name"];
            
            currentSong.songDuration = [res objectForKey:@"duration"];
            
            [self.songResultArray addObject:currentSong];
            
            completionBlock(YES, currentSong, nil);
            
            //NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [dataTask resume];
    
}

@end