//
//  fetchData.m
//  PartyShark
//
//  Created by Ri Zhao on 2016-03-11.
//  Copyright © 2016 Ri Zhao. All rights reserved.
//

#import "fetchData.h"

@implementation fetchData

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
    
}

+(fetchData*)singletonInstance{
    
    static dispatch_once_t onceToken;
    static fetchData* singleton;
    
    dispatch_once(&onceToken, ^{
        singleton = [[fetchData alloc] init];
    });
    
    return singleton;
}

- (void) fetchsearchResults : (NSString*) searchText : (fetchCompletionBlock)completionBlock{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("MyQueue", NULL);
    dispatch_async(concurrentQueue, ^{
        
        NSString *searchTerm = searchText;
        
        [[[[[searchTerm stringByReplacingOccurrencesOfString: @"&" withString: @"&amp;"]
            stringByReplacingOccurrencesOfString: @"\"" withString: @"&quot;"]
           stringByReplacingOccurrencesOfString: @"'" withString: @"&#39;"]
          stringByReplacingOccurrencesOfString: @">" withString: @"&gt;"]
         stringByReplacingOccurrencesOfString: @"<" withString: @"&lt;"];
        
        searchTerm = [ searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        NSString *URLString = [NSString stringWithFormat:@"http://api.deezer.com/search?q=%@", searchTerm];
        
        NSDictionary *parameters = @{};
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
        
        [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
        
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                
                //Error
                completionBlock(NO, nil, error);
                NSLog(@"Error: %@", error);
                
            } else {
                
                
                NSDictionary *res = (id)responseObject;
                
                NSMutableArray *results = [res objectForKey:@"data"];
                self.nextString = [res objectForKey:@"next"];
                [[NSUserDefaults standardUserDefaults] setObject:self.nextString forKey:@"next_URL"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if (results){
                    completionBlock(YES, results, nil);
                    
                }
                
                // NSLog(@"%@ %@", response, responseObject);
            }
        }];
        [dataTask resume];
    });
}

- (void) fetchMoreSearchResults : (fetchCompletionBlock)completionBlock{
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("MyQueue", NULL);
    dispatch_async(concurrentQueue, ^{
        
        NSString *URLString = [[NSUserDefaults standardUserDefaults]
                               stringForKey:@"next_URL"];
        if (URLString){
            NSDictionary *parameters = @{};
            
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            
            NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
            
            [request setValue: [[NSUserDefaults standardUserDefaults] stringForKey:@"X_User_Code"] forHTTPHeaderField:@"X-User-Code"];
            
            NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                if (error) {
                    
                    //Error
                    completionBlock(NO, nil, error);
                    NSLog(@"Error: %@", error);
                    
                } else {
                    
                    
                    NSDictionary *res = (id)responseObject;
                    self.nextString = [res objectForKey:@"next"];
                    [[NSUserDefaults standardUserDefaults] setObject:self.nextString forKey:@"next_URL"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSMutableArray *results = [res objectForKey:@"data"];
                    
                    self.nextString = [res objectForKey:@"next"];
                    
                    if (results){
                        completionBlock(YES, results, nil);
                        
                    }
                    
                    // NSLog(@"%@ %@", response, responseObject);
                }
            }];
            
            [dataTask resume];
        }else{
            completionBlock(NO, nil, nil);
        }
    });
}

@end
