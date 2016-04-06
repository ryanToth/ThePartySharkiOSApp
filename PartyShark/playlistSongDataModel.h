//
//  playlistSongDataModel.h
//  PartyShark
//
//  Created by Ryan Toth on 2016-03-13.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface playlistSongDataModel : NSObject

@property (strong, nonatomic) NSString *playthroughCode;
@property (strong, nonatomic) NSString *songCode;
@property (strong, nonatomic) NSString *songAlbum;
@property (strong, nonatomic) NSString *songTitle;
@property (strong, nonatomic) NSString *songArtist;
@property (strong, nonatomic) NSString *songSuggester;
@property (nonatomic) NSNumber *songPosition;
@property (nonatomic) NSNumber *upVotes;
@property (nonatomic) NSNumber *downVotes;
@property (nonatomic) NSNumber *netVotes;
@property (nonatomic) NSNumber *songDuration;
@property (nonatomic) NSNumber *completedRatio;
@property (strong, nonatomic) UIImage  *albumArt;

- (NSComparisonResult)compare:(playlistSongDataModel *)otherObject;

@end