//
//  AppDelegate.h
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-19.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "WalkthroughViewController.h"
#import "ICETutorialController.h"
#import "NavigationManager.h"
#import <RESideMenu/RESideMenu.h>
#import "SCLAlertView.h"
#import "AFNetworking.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, ICETutorialControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIWindow *onboardingWindow;
@property (strong, nonatomic) ICETutorialController *viewController;


@property (strong, nonatomic) NavigationManager *navManager;
@property (strong, nonatomic) RESideMenu *sideMenuVC;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) NSString *toSavePartyCode;
typedef void (^myCompletionBlock)(BOOL success, NSError *error);
- (void) setUpTutorialScreen;

- (BOOL) tryCreateParty :(myCompletionBlock)completionBlock;
- (BOOL) tryJoinParty: (NSString *)partyCode :(myCompletionBlock)completionBlock;
- (BOOL) userAlreadyInParty :(NSString*)partyCode :(NSString*)userID;



@end

