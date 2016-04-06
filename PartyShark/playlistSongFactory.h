//
//  playlistSongFactory.h
//  PartyShark
//
//  Created by Ryan Toth on 2016-03-13.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "playlistSongDataModel.h"
#import "AFNetworking.h"

@interface playlistSongFactory : NSObject

typedef void (^fetchCompletionBlock)(BOOL success, NSMutableArray *data, NSError *error);
typedef void (^aquireCompletionBlock)(BOOL success, playlistSongDataModel*, NSError *error);
@property (nonatomic, strong) NSMutableArray* songResultArray;

typedef void (^newCompletionBlock)(BOOL success, NSMutableArray *songs, NSError *error);

- (void) gatherData : (newCompletionBlock)completionBlock;
- (void) fetchExtraSongData : (playlistSongDataModel*)currentSong :(aquireCompletionBlock)completionBlock;

@end
