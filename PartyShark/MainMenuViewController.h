//
//  MainMenuViewController.h
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-22.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "NavigationStatics.h"
#import "leavePartyViewController.h"

@interface MainMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* menuItemsTable;
@property (nonatomic, strong) NSArray* menuItems;

@end
