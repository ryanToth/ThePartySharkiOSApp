//
//  BaseViewController.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-22.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self setupCustomNavigationBar];
    
}

- (void) setupCustomNavigationBar{
    
    // Customize navigation bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.barStyle            = UIStatusBarStyleDefault;
    self.navigationItem.leftBarButtonItem                       = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"header_menu_icon"]
                                                                                     landscapeImagePhone:nil
                                                                                                   style:UIBarButtonItemStylePlain
                                                                                                  target:self
                                                                                                  action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem.tintColor             = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    NSString* displayName = [[[[NSUserDefaults standardUserDefaults] stringForKey:@"username"] stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString];
    
    displayName = [NSString stringWithFormat:@"%@%@", displayName, @"'s Dock"];
    
    self.title = displayName;
}

@end
