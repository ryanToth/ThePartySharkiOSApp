//
//  DeezerPlayer.h
//  PartyShark
//
//  Created by Ryan Toth on 2016-03-24.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZRPlayer.h"
#import "DeezerConnect.h"
#import "DZRRequestManager.h"


@interface DeezerPlayer : NSObject <DeezerSessionDelegate, DZRPlayerDelegate>

@property (nonatomic, strong) DZRPlayer *player;
@property (nonatomic, strong) DZRRequestManager *manager;
@property (nonatomic, strong) id<DZRCancelable> trackRequest;

- (id)initWithConnection;
- (void)playTrackID:(NSString*)trackID;
- (void) playRadio;

@end