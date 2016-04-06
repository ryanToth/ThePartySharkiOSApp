//
//  ConfigManager.h
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-22.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigManager : NSObject

+(ConfigManager*)singletonInstance;

- (NSArray*) navigationItems;

@end
