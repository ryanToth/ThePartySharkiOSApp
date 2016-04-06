//
//  MainMenuViewController.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-22.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "MainMenuViewController.h"
#import "NavigationManager.h"
#import "ConfigManager.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

CGFloat const kLeftNavHeight = 340.0f;

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ConfigManager* configManager         = [ConfigManager singletonInstance];
    self.menuItems                       = [configManager navigationItems];
    self.menuItemsTable                  = [[UITableView alloc] initWithFrame:CGRectMake(20, (self.view.frame.size.height - kLeftNavHeight) / 2.0f,
                                                                                         self.view.frame.size.width, kLeftNavHeight)
                                                                        style:UITableViewStylePlain];
    self.view.backgroundColor        = [UIColor whiteColor];
    // Menu Items
    self.menuItemsTable.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    self.menuItemsTable.delegate         = self;
    self.menuItemsTable.dataSource       = self;
    self.menuItemsTable.opaque           = NO;
    self.menuItemsTable.backgroundColor  = [UIColor clearColor];
    self.menuItemsTable.backgroundView   = nil;
    self.menuItemsTable.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.menuItemsTable.bounces          = YES;
    [self.view addSubview: self.menuItemsTable];
    
    // Settings button
    UIImage* pref_icon_image = [UIImage imageNamed:@"pref_icon"];
    UIButton* btnPreferences = [[UIButton alloc] initWithFrame:CGRectMake(self.menuItemsTable.frame.origin.x, self.menuItemsTable.frame.origin.y + self.menuItemsTable.frame.size.height + 30, 60, 60)];
    [btnPreferences setImage:pref_icon_image forState:UIControlStateNormal];
    
    [btnPreferences addTarget:self action:@selector(displaySettings) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPreferences];
    
    // delegates
    self.menuItemsTable.dataSource = self;
    self.menuItemsTable.delegate   = self;

}

- (void) displaySettings {
    
    [[NavigationManager singletonInstance] goToSettings];
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark - TableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NavigationManager* navManager = [NavigationManager singletonInstance];
    leavePartyViewController *leave = [[leavePartyViewController alloc]init];
    
    switch (indexPath.row) {
        case kMainSection:
            [navManager goToMainSection];
            break;
        case kSearchSection:
            [navManager goToSearch];
            break;
        case kSettingsSection:
            [navManager goToSettings];
            break;
        case kLeavePartySection:
            [navManager leaveParty];
        default:
            break;
    }
    
    [self.sideMenuViewController hideMenuViewController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - TableViewDataDelegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.menuItems.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* cellIdentifier = @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell                                = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor                = [UIColor clearColor];
        cell.textLabel.font                 = [UIFont fontWithName:@"SourceSansPro-ExtraLight" size:21];
        cell.textLabel.textColor            = UIColorFromRGB(0xfa6900);
        cell.selectedBackgroundView         = [[UIView alloc] init];
    }
    
    cell.textLabel.text = self.menuItems[indexPath.row];
    
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
