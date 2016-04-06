//
//  WalkThroughViewController.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-26.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "WalkThroughViewController.h"
#import "NavigationManager.h"
#import "SystemStatics.h"

@interface WalkThroughViewController ()

@end

@implementation WalkThroughViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton* btnGoHome = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 200, 100)];
    [btnGoHome setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnGoHome setTitle:@"Finish" forState:UIControlStateNormal];
    [btnGoHome addTarget:self action:@selector(goToAppContent) forControlEvents:UIControlEventTouchUpInside];
    btnGoHome.center = self.view.center;
    [self.view addSubview:btnGoHome];
    
    
}
- (void) goToAppContent {
    
    [[NavigationManager singletonInstance] goToMainSection];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:kUserHasOnboarded];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
