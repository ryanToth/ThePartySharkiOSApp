//
//  settingsFactory.h
//  PartyShark
//
//  Created by Ryan Toth on 2016-03-21.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "AFNetworking.h"
#import "settingsDataModel.h"

@interface settingsFactory : NSObject

@property (nonatomic, strong) settingsDataModel* settings;

typedef void (^settingsCompletionBlock)(BOOL success, settingsDataModel *settings, NSError *error);

- (void) gatherData : (settingsCompletionBlock)completionBlock;

@end
