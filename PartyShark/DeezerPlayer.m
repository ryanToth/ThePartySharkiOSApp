//
//  DeezerPlayer.m
//  PartyShark
//
//  Created by Ryan Toth on 2016-03-24.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "DeezerPlayer.h"

@implementation DeezerPlayer

- (id)initWithConnection
{
    self = [super init];
    
    if (self) {
        
        DeezerConnect *connect = [[DeezerConnect alloc] initWithAppId:@"174711" andDelegate:self];
        [[DZRRequestManager defaultManager] setDzrConnect:connect];
        
        NSArray *array = [[NSArray alloc] initWithObjects:@"DeezerConnectPermissionBasicAccess", nil];
        
        [connect authorize:array];
        
        self.player = [[DZRPlayer alloc] initWithConnection:connect];
        self.player.networkType = DZRPlayerNetworkTypeWIFIAnd3G;
        
        [DZRRequestManager defaultManager].dzrConnect = connect;
        
        self.manager = [[DZRRequestManager defaultManager] subManager];
    }
    
    return self;
}

- (void)playTrackID:(NSString*)trackID
{
    [self.trackRequest cancel];
    [self.player stop];
    
    self.trackRequest = [DZRTrack
                         objectWithIdentifier:trackID
                         requestManager:self.manager
                         callback:^(DZRTrack *track, NSError *error) {
                             
                             [self.player play:track];
                             NSLog(@"asjdnsad");
                             NSLog(@"%@", error);
                             
                         }];
}

- (void)playRadio
{
    [DZRRadio                                           // 5
     objectWithIdentifier:@"3991"
     requestManager:self.manager
     callback:^(DZRObject *o, NSError *err) {
         [self.player play:o];                             // 6
     }];
}

- (void)deezerDidLogin {
    
    [self playTrackID:@"112350074"];
    
}
- (void)deezerDidNotLogin:(BOOL)cancelled {
    
    
}
- (void)deezerDidLogout {
    
    
}


@end