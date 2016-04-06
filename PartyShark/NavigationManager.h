//
//  NavigationManager.h
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-22.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLAlertView.h"
//#include "leavePartyViewController.h"

@interface NavigationManager : UINavigationController

+ (NavigationManager* )singletonInstance;


/* Settings */
- (void) goToSettings;

/*Menu Items*/
- (void) goToMainSection;
- (void) goToSearch;
- (void) goToMainSectionWithAnimation:(BOOL)animated;

- (void) leaveParty;
@end
