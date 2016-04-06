//
//  AppDelegate.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-19.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "AppDelegate.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//Navigation
#import "NavigationManager.h"
#import "MainMenuViewController.h"
#import "MainViewController.h"
#import <RESideMenu/RESideMenu.h>

// ViewControllers
#import "WalkThroughViewController.h"

// Statics
#import "SystemStatics.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    self.window                    = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen]bounds]];
    self.navManager  = [NavigationManager singletonInstance];
    MainViewController* mainVC     = [[MainViewController alloc] init];
    [self.navManager setViewControllers:@[mainVC]];
    
    MainMenuViewController* menuVC = [[MainMenuViewController alloc] init];
    self.sideMenuVC         = [[RESideMenu alloc] initWithContentViewController:self.navManager
                                                         leftMenuViewController:menuVC
                                                        rightMenuViewController:nil];
    // Customize menu
    self.sideMenuVC.panGestureEnabled        = NO;
    self.sideMenuVC.scaleBackgroundImageView = NO;
    self.sideMenuVC.scaleMenuView            = NO;
    self.sideMenuVC.contentViewShadowEnabled = YES;
    //sideMenuVC.backgroundImage          = [UIImage imageNamed:@"background"];
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"savedPartyCode"];
    //set up for persistent login
        
    
    if(savedValue){
        self.window.rootViewController = self.sideMenuVC;
        [self.navManager goToMainSection];
    }else{
        
        [self setUpTutorialScreen];
    }
    
    //customize navbarcontroller
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:250.0/255.0 green:105.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:250.0/255.0 green:105.0/255.0 blue:0.0/255.0 alpha:1.0]];
    
    NSDictionary *attributes = @{
                                 NSUnderlineStyleAttributeName: @1,
                                 NSForegroundColorAttributeName : [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                 NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:17]
                                 };
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    /*
    [self tryJoinParty: savedValue: ^(BOOL success, NSError *error){
        
        if (!success) {
            NSLog(@"%@", error);
        }
        else {
            self.window.rootViewController = self.sideMenuVC;
            [self.navManager goToMainSection];
        }
    }];
    */
    
    return true;
}

#pragma mark - ICETutorialController delegate
- (void)tutorialController:(ICETutorialController *)tutorialController scrollingFromPageIndex:(NSUInteger)fromIndex toPageIndex:(NSUInteger)toIndex {
    //NSLog(@"Scrolling from page %lu to page %lu.", (unsigned long)fromIndex, (unsigned long)toIndex);
}

- (void)tutorialControllerDidReachLastPage:(ICETutorialController *)tutorialController {
    //NSLog(@"Tutorial reached the last page.");
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnLeftButton:(UIButton *)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = NO;
    alert.backgroundType = Blur;
    

    [alert addButton:@"Create Party" validationBlock:^BOOL{
        
        return YES;
    
    } actionBlock:^{

        [self tryCreateParty:^(BOOL success, NSError *error){
            if(!success){
                NSLog(@"%@", error);
                [self shakeAlert:alert];
            }else{

                self.window.rootViewController = self.sideMenuVC;
                //change to goToSettings
                [self.navManager goToSettings];
            }
        }];
    }];

    UIColor *color = [UIColor colorWithRed:250.0/255.0 green:105.0/255.0 blue:0.0/255.0 alpha:1.0];
    [alert showCustom:self.window.rootViewController image:[UIImage imageNamed:@"Icon-40@3x.png"] color:color title:@"PartyShark" subTitle:@"" closeButtonTitle:@"Cancel" duration:0.0f];
    
    
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnRightButton:(UIButton *)sender {
    // Setup right hand nav
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.shouldDismissOnTapOutside = NO;
    alert.backgroundType = Blur;
    
    
    SCLTextView *joinField = [alert addTextField:@"Party Code"];
    joinField.keyboardType = UIKeyboardTypeNumberPad;
    
    [alert addButton:@"Join Party" validationBlock:^BOOL{
        
        if (joinField.text.length == 0)
        {
            [self shakeAlert:alert];
            [joinField becomeFirstResponder];
            return NO;
            //here check the text entered is equal to a existing partycode
        }
        
        if ([self tryJoinParty: joinField.text: ^(BOOL success, NSError *error){
            
            if (!success) {
                NSLog(@"%@", error);
                [self shakeAlert:alert];
            }
            else {
                
                self.toSavePartyCode = joinField.text;
                [[NSUserDefaults standardUserDefaults] setObject:self.toSavePartyCode forKey:@"savedPartyCode"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.window.rootViewController = self.sideMenuVC;
                [self.navManager goToMainSection];
            }
        }])
        
        return YES;
        
        return NO;
        
    } actionBlock:^{
        
        
    }];
    
    
    UIColor *color = [UIColor colorWithRed:250.0/255.0 green:105.0/255.0 blue:0.0/255.0 alpha:1.0];
    [alert showCustom:self.window.rootViewController image:[UIImage imageNamed:@"Icon-40@3x.png"] color:color title:@"PartyShark" subTitle:@"Enter Party Code to Join Party" closeButtonTitle:@"Cancel" duration:0.0f];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"closing app here");
    [[NSUserDefaults standardUserDefaults] setObject:self.toSavePartyCode forKey:@"savedPartyCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"closing app");
    [[NSUserDefaults standardUserDefaults] setObject:self.toSavePartyCode forKey:@"savedPartyCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self saveContext];
}

- (void) setUpTutorialScreen{
    
    //Tutorial Screen setup
    
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"11.png"
                                                            duration:3.0];
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"22.png"
                                                            duration:3.0];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"33.png"
                                                            duration:3.0];
    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"44.png"
                                                            duration:3.0];
    
    NSArray *tutorialLayers = @[layer1,layer2,layer3,layer4];
    
    
    ICETutorialLabelStyle *titleStyle = [[ICETutorialLabelStyle alloc] init];
    [titleStyle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
    [titleStyle setTextColor:[UIColor whiteColor]];
    [titleStyle setLinesNumber:1];
    [titleStyle setOffset:180];
    [[ICETutorialStyle sharedInstance] setTitleStyle:titleStyle];
    
    // Set the subTitles style with few properties and let the others by default.
    [[ICETutorialStyle sharedInstance] setSubTitleColor:[UIColor whiteColor]];
    [[ICETutorialStyle sharedInstance] setSubTitleOffset:150];
    
    // Init tutorial.
    self.viewController = [[ICETutorialController alloc] initWithPages:tutorialLayers
                                                              delegate:self];
    
    // Run it.
    //[self.viewController startScrolling];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
}

- (BOOL) tryJoinParty:(NSString *)partyCode :(myCompletionBlock)completionBlock {
    
    __block BOOL success = NO;
    
    NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@/users", partyCode];
    NSDictionary *parameters = @{};
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            completionBlock(NO, nil);
            
        } else {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            NSDictionary *dictionary = [httpResponse allHeaderFields];
            
            // Saves that the user is NOT an admin
            [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"is_admin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // Saves that the user is NOT a player
            [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"is_player"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // Save username
            [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"username"] forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // Save the X-User-Code in device memory
            [[NSUserDefaults standardUserDefaults] setObject:[dictionary objectForKey:@"x-set-user-code"] forKey:@"X_User_Code"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // to use
            //NSString *whatever =  [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"];
            
            NSLog(@"%@ %@", response, responseObject);
            success = YES;
            completionBlock(YES, nil);
        }
    }];
    [dataTask resume];
    
    return success;
}

- (BOOL) tryCreateParty :(myCompletionBlock)completionBlock {
    
    __block BOOL success = NO;
    
    NSString *URLString = @"https://api.partyshark.tk/parties";
    NSDictionary *parameters = @{};
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            completionBlock(NO, nil);
        } else {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

            // Saves if the player is currently playing
            [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"is_playing"] forKey:@"is_playing"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // Saves the admin code
            [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"admin_code"] forKey:@"admin_code"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // Saves that the user is now an admin
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"is_admin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // Save party_code
            [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"code"] forKey:@"savedPartyCode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // Person who creates the party is the player
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"is_player"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSDictionary *dictionary = [httpResponse allHeaderFields];

            [[NSUserDefaults standardUserDefaults] setObject:[dictionary objectForKey:@"x-set-user-code"] forKey:@"X_User_Code"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"%@ %@", response, responseObject);
            success = YES;
            
            NSString *URLString = [NSString stringWithFormat:@"https://api.partyshark.tk/parties/%@/users/self",  [responseObject objectForKey:@"code"]];
            
            NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
            
            [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
            
            NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                if (error) {
                    NSLog(@"Error: %@", error);
                    completionBlock(NO, nil);
                } else {
                    
                    // Save username
                    [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"username"] forKey:@"username"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    completionBlock(YES, nil);
                    
                }
            }];
            [dataTask resume];
        }
    }];
    [dataTask resume];
    
    return success;
}

- (void) shakeAlert:(SCLAlertView *)alertView{
    
    [UIView animateWithDuration:0.1 animations:^{
        // Translate left
        CGRect frame = alertView.view.frame;
        frame.origin.x -= alertView.view.frame.size.width - 100;
        alertView.view.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            CGRect frame = alertView.view.frame;
            frame.origin.x += alertView.view.frame.size.width + alertView.view.frame.size.width - 100;
            alertView.view.frame = frame;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                
                // Translate left
                CGRect frame = alertView.view.frame;
                frame.origin.x -= (alertView.view.frame.size.width + alertView.view.frame.size.width)- 100;
                alertView.view.frame = frame;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.1 animations:^{
                    
                    // Translate to origin
                    CGRect frame = alertView.view.frame;
                    frame.origin.x += alertView.view.frame.size.width- 100;
                    alertView.view.frame = frame;
                }];
            }];
            
        }];
    }];
}

#pragma mark - Core Data stack



@end
