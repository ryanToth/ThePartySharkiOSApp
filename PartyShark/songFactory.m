//
//  songFactory.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-03-10.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "songFactory.h"


@implementation songFactory

-(id)init{
    self = [super init];
    
    return self;
}

- (void) gatherData : (NSString*) textbarText : (newCompletionBlock)completionBlock{
    
    NSString *searchTerm = textbarText;
    fetchData *fetch = [[fetchData alloc]init];
    [fetch fetchsearchResults:searchTerm :^(BOOL success, NSMutableArray *data, NSError *error) {
        if (!success){
            NSLog(@"%@", error);
        }else{
            self.songResultArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < data.count; i++){
                songDataModel *songModel = [[songDataModel alloc]init];
                
                self.songs = [data objectAtIndex:i];
                //song id
                //NSDictionary *songCode = [self.songs objectAtIndex:0];
                songModel.songCode =        [self.songs objectForKey:@"id"];
                //album title and album picture
                NSDictionary *album = [self.songs objectForKey:@"album"];
                NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [album objectForKey:@"cover_medium"]]];
                songModel.songAlbum =    [album objectForKey:@"title"];
                songModel.albumArt = [UIImage imageWithData: imageData];
                //song title
                songModel.songTitle =       [self.songs objectForKey:@"title"];
                //artist
                NSDictionary *artistName = [self.songs objectForKey:@"artist"];
                songModel.songArtist =      [artistName objectForKey:@"name"];
               
                [self.songResultArray addObject:songModel];
                
            }
            if (self.songResultArray) {
                completionBlock(YES, self.songResultArray, nil);
                
            }else{
                completionBlock(NO, nil, nil);
                
            }
        }
    }];
    
}

- (void) gatherNextData : (newCompletionBlock)completionBlock{
    
    fetchData *fetch = [[fetchData alloc]init];
    [fetch fetchMoreSearchResults :^(BOOL success, NSMutableArray *data, NSError *error) {
        if (!success){
            NSLog(@"%@", error);
        }else{
            self.songResultArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < data.count; i++){
                songDataModel *songModel = [[songDataModel alloc]init];
                
                self.songs = [data objectAtIndex:i];
                //song id
                //NSDictionary *songCode = [self.songs objectAtIndex:0];
                songModel.songCode =        [self.songs objectForKey:@"id"];
                //album title and album picture
                NSDictionary *album = [self.songs objectForKey:@"album"];
                NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [album objectForKey:@"cover_medium"]]];
                songModel.songAlbum =    [album objectForKey:@"title"];
                songModel.albumArt = [UIImage imageWithData: imageData];
                //song title
                songModel.songTitle =       [self.songs objectForKey:@"title"];
                //artist
                NSDictionary *artistName = [self.songs objectForKey:@"artist"];
                songModel.songArtist =      [artistName objectForKey:@"name"];
                
                [self.songResultArray addObject:songModel];
                
            }
            if (self.songResultArray) {
                completionBlock(YES, self.songResultArray, nil);
                
            }else{
                completionBlock(NO, nil, nil);
                
            }
        }
    }];
}

@end
