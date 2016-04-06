//
//  ConfigManager.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-01-22.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "ConfigManager.h"

@interface ConfigManager()

@property (nonatomic, strong) NSDictionary* configDictionary;

@end

@implementation ConfigManager


- (id)init{
    
    self = [super init];
    if (self) {
        _configDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"]];
    }
    
    return self;
    
}
- (NSArray*) navigationItems{
    
    return [self.configDictionary objectForKey:@"NavigationItems"];
}

+(ConfigManager*)singletonInstance{
    
    static dispatch_once_t once_token;
    static ConfigManager* _instance = nil;
    
    dispatch_once(&once_token, ^{
        _instance = [[ConfigManager alloc] init];
    });
    
    return _instance;
}
@end
