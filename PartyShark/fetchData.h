//
//  fetchData.h
//  PartyShark
//
//  Created by Ri Zhao on 2016-03-11.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface fetchData : NSObject

typedef void (^fetchCompletionBlock)(BOOL success, NSMutableArray *data, NSError *error);
+(fetchData*)singletonInstance;

@property (strong, nonatomic) NSString *nextString;

- (void) fetchsearchResults : (NSString*) searchText : (fetchCompletionBlock)completionBlock;
- (void) fetchMoreSearchResults : (fetchCompletionBlock)completionBlock;
@end
