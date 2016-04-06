//
//  settingsFactory.m
//  PartyShark
//
//  Created by Ryan Toth on 2016-03-21.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "settingsFactory.h"

@implementation settingsFactory

-(id)init{
    self = [super init];
    
    return self;
}

- (void) gatherData : (settingsCompletionBlock)completionBlock {
    
    [self fetchSettings :^(BOOL success, settingsDataModel *data, NSError *error) {
        if (!success){
            NSLog(@"%@", error);
        }else{
            if (self.settings) {
                
                completionBlock(YES, data, nil);
                
            }else{
                completionBlock(NO, nil, nil);
            }
        }
    }];
    
}

- (void) fetchSettings : (settingsCompletionBlock)completionBlock {
    
    NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@/settings", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"]];
    
    NSDictionary *parameters = @{};
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    
    [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            //Error
            NSLog(@"Error: %@", error);
            completionBlock(NO, nil, nil);
            
        } else {
            
            self.settings = [[settingsDataModel alloc]init];
            
            self.settings.maxParticipants = [responseObject objectForKey:@"user_cap"];
            self.settings.maxPlaylistSize = [responseObject objectForKey:@"playthrough_cap"];
            self.settings.virtualDJ = [[responseObject objectForKey:@"virtual_dj"] boolValue];
            self.settings.defaultGenre = [responseObject objectForKey:@"default_genre"];
            self.settings.vetoRatio = [responseObject objectForKey:@"veto_ratio"];
            
            NSLog(@"%@ %@", response, responseObject);
            
            completionBlock(YES, self.settings, nil);
        }
    }];
    
    [dataTask resume];
}

@end