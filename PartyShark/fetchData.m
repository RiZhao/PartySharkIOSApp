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
    NSString *searchTerm = searchText;
    
    [[[[[searchTerm stringByReplacingOccurrencesOfString: @"&" withString: @"&amp;"]
        stringByReplacingOccurrencesOfString: @"\"" withString: @"&quot;"]
       stringByReplacingOccurrencesOfString: @"'" withString: @"&#39;"]
      stringByReplacingOccurrencesOfString: @">" withString: @"&gt;"]
     stringByReplacingOccurrencesOfString: @"<" withString: @"&lt;"];
    
    searchTerm = [ searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *URLString = [NSString stringWithFormat:@"http://nreid26.xyz:3000/songs?search=%@", searchTerm];
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
            
            //NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            //NSHTTPURLResponse *httpResponse = (id)responseObject;
            NSDictionary *res = (id)responseObject;
            
            // extract specific value...
            NSMutableArray *results = [res objectForKey:@"values"];
            //NSLog(@"%@", results);
            if (results){
                completionBlock(YES, results, nil);
            }
            
            // NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [dataTask resume];
}

@end
