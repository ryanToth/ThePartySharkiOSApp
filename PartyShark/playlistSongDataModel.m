//
//  playlistSongDataModel.m
//  PartyShark
//
//  Created by Ryan Toth on 2016-03-13.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "playlistSongDataModel.h"

@implementation playlistSongDataModel

-(id) init{
    self = [super init];
    return self;
}

- (NSComparisonResult)compare:(playlistSongDataModel *)otherObject {
    return [self.songPosition compare:otherObject.songPosition];
}

@end