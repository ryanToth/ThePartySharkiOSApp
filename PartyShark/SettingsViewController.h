//
//  SettingsViewController.h
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-22.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AFNetworking.h"
#import "settingsFactory.h"
#import "settingsDataModel.h"
#import "ActionSheetStringPicker.h"

@interface SettingsViewController : BaseViewController

@property (strong, nonatomic) settingsDataModel *settings;

@property (weak, nonatomic) IBOutlet UILabel *maxParticipantsLabel;
@property (weak, nonatomic) IBOutlet UITextField *maxParticipantsTextField;

@property (weak, nonatomic) IBOutlet UILabel *maxPlaylistSizeLabel;
@property (weak, nonatomic) IBOutlet UITextField *maxPlaylistSizeTextField;
@property (weak, nonatomic) IBOutlet UITextField *vetoRatioTextField;

@property (weak, nonatomic) IBOutlet UILabel *virtualDJLabel;
@property (weak, nonatomic) IBOutlet UISwitch *virtualDJSwitchButton;
- (IBAction)virtualDJSwitch:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *defaultRadioLabel;
@property (weak, nonatomic) IBOutlet UIButton *defaultRadioButton;
- (IBAction)defaultRadioButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *updateOptionsButton;
- (IBAction)updateOptionsButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *adminCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *adminCodeTextField;
- (IBAction)adminCodeTextFieldEdit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *adminCodeButton;
- (IBAction)adminCodeButtonPressed:(id)sender;

@property (strong, nonatomic) NSDictionary *defaultGenres;

@property(strong, nonatomic) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIButton *requestToBePlayerButton;
- (IBAction)requestToBePlayerButtonPressed:(id)sender;

typedef void (^myCompletionBlock)(BOOL success, NSError *error);



@end
