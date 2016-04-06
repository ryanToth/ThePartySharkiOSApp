//
//  SettingsViewController.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-22.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "SettingsViewController.h"
#import "NavigationManager.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.defaultGenres = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Classic Rock", @0,
                          @"Metal", @1,
                          @"Jazz", @2,
                          @"Country", @3,
                          @"Top Hits", @4,
                          @"Classical", @5,
                          @"Folk", @6,
                          @"Electronic", @7, nil];
    
    NSString* partyCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"];
    partyCode = [NSString stringWithFormat:@"Party Code: %@", partyCode];
    self.title = partyCode;
    
    self.maxParticipantsTextField.delegate = self;
    self.maxPlaylistSizeTextField.delegate = self;
    self.adminCodeTextField.delegate = self;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    [self getSettings];
}

- (void) getSettings {
    
    settingsFactory *fetch = [[settingsFactory alloc]init];
    dispatch_queue_t concurrentQueue = dispatch_queue_create("MyQueue", NULL);
    dispatch_async(concurrentQueue, ^{
        [fetch gatherData :^(BOOL success, settingsDataModel *set, NSError *error) {
            if (!success){
                NSLog(@"%@", error);
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.settings = set;
                    [self setSettingsValues: set];
                    
                });
            }
        }
         ];
    });
    
}

-(void)dismissKeyboard {
    [self.maxParticipantsTextField resignFirstResponder];
    [self.maxPlaylistSizeTextField resignFirstResponder];
    [self.adminCodeTextField resignFirstResponder];
    [self.vetoRatioTextField resignFirstResponder];
}

- (void) setSettingsValues : (settingsDataModel*) settings {
    
    if ([self.settings.maxParticipants isKindOfClass:[NSNull class]])
        self.maxParticipantsTextField.placeholder = @"Unlimited";
    else
        self.maxParticipantsTextField.placeholder = [NSString stringWithFormat:@"%@", settings.maxParticipants];
    
    if ([self.settings.maxPlaylistSize isKindOfClass:[NSNull class]])
        self.maxPlaylistSizeTextField.placeholder = @"Unlimited";
    else
        self.maxPlaylistSizeTextField.placeholder = [NSString stringWithFormat:@"%@", settings.maxPlaylistSize];
    
    [self.virtualDJSwitchButton setOn:settings.virtualDJ];
    
    if ([settings.defaultGenre isKindOfClass:[NSNull class]] || [settings.defaultGenre floatValue] == -1) {
        
        [self.defaultRadioButton setTitle:@"None" forState:UIControlStateNormal];
        
    }
    else {
        
        [self.defaultRadioButton setTitle:[self.defaultGenres objectForKey:settings.defaultGenre] forState:UIControlStateNormal];
        
    }
    
    self.vetoRatioTextField.placeholder = [NSString stringWithFormat:@"%@", settings.vetoRatio];
    [self.requestToBePlayerButton setHidden:TRUE];
    NSString *isAdmin = [[NSUserDefaults standardUserDefaults] stringForKey:@"is_admin"];
    
    if ([isAdmin isEqual:@"0"]) {
        
        [self.defaultRadioButton setEnabled:NO];
        [self.maxParticipantsTextField setEnabled:NO];
        [self.maxPlaylistSizeTextField setEnabled:NO];
        [self.virtualDJSwitchButton setEnabled:NO];
        [self.updateOptionsButton setEnabled:NO];
        
    }
    else {
        
        self.adminCodeTextField.placeholder = [[NSUserDefaults standardUserDefaults] stringForKey:@"admin_code"];
        [self.adminCodeTextField setEnabled:NO];
        [self.adminCodeButton setEnabled:NO];
        [self.adminCodeButton setHidden:YES];
        
        [self.defaultRadioButton setEnabled:YES];
        [self.maxParticipantsTextField setEnabled:YES];
        [self.maxPlaylistSizeTextField setEnabled:YES];
        [self.virtualDJSwitchButton setEnabled:YES];
        [self.updateOptionsButton setEnabled:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)virtualDJSwitch:(id)sender {
}

- (IBAction)updateOptionsButtonPressed:(id)sender {
    
    [self updateSettings];
    
}
- (IBAction)adminCodeTextFieldEdit:(id)sender {
    
    
    
}
- (IBAction)adminCodeButtonPressed:(id)sender {
    
    if (![self.adminCodeTextField.text isEqualToString:@""]) {
        [self promoteToAdmin];
    }
    
}

- (IBAction)defaultRadioButtonPressed:(id)sender {
    [self.maxParticipantsTextField resignFirstResponder];
    [self.maxPlaylistSizeTextField resignFirstResponder];
    [self.adminCodeTextField resignFirstResponder];
    [self.vetoRatioTextField resignFirstResponder];
    
    NSMutableArray *genres = self.defaultGenres.allValues;
    NSString *none = @"None";
    NSMutableArray *empty = [[NSMutableArray alloc]init];
    NSMutableArray *newArray = [[empty arrayByAddingObjectsFromArray:genres] mutableCopy];
    [newArray insertObject:none atIndex:0];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Choose Default Genre" rows: newArray initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue){
                                           
                                           [self.defaultRadioButton setTitle:selectedValue forState:UIControlStateNormal];
                                           
                                           if([selectedValue isEqualToString:@"None"]) {
                                               self.settings.defaultGenre = @-1;
                                           }
                                           else {
                                               self.settings.defaultGenre = [self.defaultGenres allKeysForObject:selectedValue][0];
                                           }
                                           
                                       }cancelBlock:^(ActionSheetStringPicker *picker) {
                                           
                                       } origin:sender];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // allow backspace
    if (!string.length)
    {
        return YES;
    }
    
    if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
    {
        // BasicAlert(@"", @"This field accepts only numeric entries.");
        return NO;
    }
    
    return YES;
}


- (void) promoteToAdmin {
    
    NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@/users/self", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"]];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *value = [f numberFromString:self.adminCodeTextField.text];
    
    NSDictionary *parameters = @{@"admin_code": value};
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:parameters error:nil];
    
    [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            //Error
            NSLog(@"Error: %@", error);
            
        } else {
            
            if ([[responseObject objectForKey:@"is_admin"]  isEqual: @1]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:self.adminCodeTextField.text forKey:@"admin_code"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
            // Saves if the user is now an admin
            [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"is_admin"] forKey:@"is_admin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self setSettingsValues : self.settings];
            
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    
    [dataTask resume];
}

- (void) updateSettings {
    
    NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@/settings", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"]];
    
    //Set these to the set values
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSNumber *virtualDJ = [NSNumber numberWithBool:self.virtualDJSwitchButton.isOn];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:virtualDJ forKey:@"virtual_dj"];
    
    if (![self.maxPlaylistSizeTextField.text isEqualToString:@""]) {
        [parameters setObject:[f numberFromString:self.maxPlaylistSizeTextField.text] forKey:@"playthrough_cap"];
    }
    
    if (![self.maxParticipantsTextField.text isEqualToString:@""]) {
        [parameters setObject:[f numberFromString:self.maxParticipantsTextField.text] forKey:@"user_cap"];
    }
    
    if (![self.vetoRatioTextField.text isEqualToString:@""]) {
        [parameters setObject:[f numberFromString:self.vetoRatioTextField.text] forKey:@"veto_ratio"];
    }
    
    [parameters setObject:self.settings.defaultGenre forKey:@"default_genre"];

    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:parameters error:nil];
    
    [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            //Error
            NSLog(@"Error: %@", error);
            
        } else {
            
            self.settings.maxPlaylistSize = [responseObject objectForKey:@"playthrough_cap"];
            self.settings.maxParticipants = [responseObject objectForKey:@"user_cap"];
            self.settings.virtualDJ = [[responseObject objectForKey:@"virtual_dj"] boolValue];
            self.settings.defaultGenre = [responseObject objectForKey:@"default_genre"];
            self.settings.vetoRatio = [responseObject objectForKey:@"veto_ratio"];
            
            [self setSettingsValues : self.settings];
            
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    
    [dataTask resume];
}

- (IBAction)requestToBePlayerButtonPressed:(id)sender {
    
    NSString *isPlayer = [[NSUserDefaults standardUserDefaults] stringForKey:@"is_player"];
    
    if ([isPlayer isEqual:@"0"]) {
    
        NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@/playertransfers", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"]];
    
        NSDictionary *parameters = @{};
    
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    
        [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
    
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
            if (error) {
            
                //Error
                NSLog(@"Error: %@", error);
            
            } else {
            
                [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"code"] forKey:@"active_player_transfer_code"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            
                // NSString *test = [[NSUserDefaults standardUserDefaults] stringForKey:@"active_player_transfer_code"];
            
                [self.timer invalidate];
                self.timer = nil;
            
                self.timer = [NSTimer timerWithTimeInterval:5.0f target:self selector:@selector(pollForPlayerTransferRequest:) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
            
                NSLog(@"%@ %@", response, responseObject);
            }
        }];
    
        [dataTask resume];
    }
    
    else {
        
        // Tell the user they are already the player
        
    }
    
}

- (void)pollForPlayerTransferRequest:(id)sender
{
    // do your refresh here...
    NSLog(@"Checking for Player Transfer Request Acceptance");

    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"active_player_transfer_code"] == nil) {
        
        [self.timer invalidate];
        self.timer = nil;
        
        return;
    }
    
    [self didPlayerTransferRequestGetClosed :^(BOOL success, NSError *error) {
        
        if (success) {
            
            [self.timer invalidate];
            self.timer = nil;
        
            [self isNowPlayer];
        }
        
    }];
    
}

-(BOOL) didPlayerTransferRequestGetClosed :(myCompletionBlock)completionBlock {
    
    __block BOOL success = NO;
    
    NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@/playertransfers/%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"savedPartyCode"], [[NSUserDefaults standardUserDefaults] stringForKey:@"active_player_transfer_code"]];
    
    NSDictionary *parameters = @{};
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    
    [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            
            NSLog(@"Error: %@", error);
            completionBlock(NO, nil);
            
        } else {

            NSNumber *status = [responseObject objectForKey:@"status"];
            
            if ([status isEqual:@1]) {
                
                success = YES;
                completionBlock(YES, nil);
                
            }
            else {
                
                success = NO;
                completionBlock(NO, nil);
                
            }

        }
    }];
    [dataTask resume];
    
    return success;
}

-(void) isNowPlayer {
    
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
            
            if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"username"] isEqualToString:[responseObject objectForKey:@"player"]]) {
                
                // You are now the player
                
                [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"is_player"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"active_player_transfer_code"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // Tell the user and direct them to the dock probably
            }
            
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    
    [dataTask resume];
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.adminCodeTextField){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    
    [self.view setFrame:CGRectMake(0,-110,self.view.frame.size.width, self.view.frame.size.height)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
}


@end
