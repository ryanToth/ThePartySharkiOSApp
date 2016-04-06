//
//  leavePartyViewController.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-03-09.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "leavePartyViewController.h"

@interface leavePartyViewController ()

@end

@implementation leavePartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leavePartyClicked{

    NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@/users/self", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"]];
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
        }
    }];
    [dataTask resume];

    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"active_player_transfer_code"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"transfer_requests"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"X-User-Code"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"savedPartyCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"admin_code"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [((AppDelegate*) [[UIApplication sharedApplication] delegate]) setUpTutorialScreen];
}


@end
