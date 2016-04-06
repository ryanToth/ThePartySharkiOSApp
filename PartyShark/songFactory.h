//
//  songFactory.h
//  PartyShark
//
//  Created by Ri Zhao on 2016-03-10.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "songDataModel.h"
#import "AFNetworking.h"
#import "fetchData.h"

@interface songFactory : NSObject

@property (nonatomic, strong) NSMutableArray* songResultArray;
@property (nonatomic, strong) NSDictionary* songs;

typedef void (^newCompletionBlock)(BOOL success, NSMutableArray *songs, NSError *error);

- (void) gatherData : (NSString*) textbarText : (newCompletionBlock)completionBlock;
- (void) gatherNextData : (newCompletionBlock)completionBlock;
@end
