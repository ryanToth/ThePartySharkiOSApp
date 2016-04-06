//
//  NavigationManager.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-22.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//
#import <RESideMenu/RESideMenu.h>
#import "NavigationManager.h"

#import "SettingsViewController.h"

#import "MainMenuViewController.h"
#import "MainViewController.h"
#import "SearchViewController.h"


@interface NavigationManager ()

@end

@implementation NavigationManager

+ (NavigationManager* )singletonInstance {
    
    /* Create singleton instance of NavigationManager to be used everywhere */
    static dispatch_once_t once_token;
    static NavigationManager *_singletonInstance = nil;
    
    dispatch_once(&once_token, ^{
        _singletonInstance = [[NavigationManager alloc] init];
    });
    
    return _singletonInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) goToSettings {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //UIViewController *optionStory = [mainStoryboard instantiateViewControllerWithIdentifier:@"optionsView"];
    SettingsViewController* settingsVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"optionsView"];
    [self setViewControllers:@[settingsVC] animated:YES];
}

- (void) goToMainSectionWithAnimation:(BOOL)animated {
    
    [self setNavigationBarHidden:NO];
    MainViewController* mainSectionVC = [[MainViewController alloc] init];
    [self setViewControllers:@[mainSectionVC] animated:animated];
}

- (void) goToMainSection {
    [self goToMainSectionWithAnimation:YES];
}

- (void) goToSearch {
    SearchViewController* searchVC = [[SearchViewController alloc]init];
    [self setViewControllers:@[searchVC] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) leaveParty{
    leavePartyViewController *temp = [[leavePartyViewController alloc]init];
    [temp leavePartyClicked];
}




@end
