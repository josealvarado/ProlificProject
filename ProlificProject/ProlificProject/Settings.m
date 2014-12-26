//
//  Settings.m
//  ProlificProject
//
//  Created by Jose Alvarado on 12/14/14.
//  Copyright (c) 2014 JoseAlvarado. All rights reserved.
//

#import "Settings.h"

@implementation Settings

+ (Settings *)instance {
    static Settings *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [Settings new];
    });
    
    return _sharedClient;
}


- (NSDictionary *)doPOST:(NSData *)jsonData url:(NSString *)url{
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonString);  // To verify the jsonString.
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    [postRequest setHTTPMethod:@"PUT"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:jsonData];
    
    NSURLResponse *response = nil;
    NSError *requestError = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&requestError];
    
    NSDictionary *returnDictionary = nil;
    
    if (requestError == nil) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"Warning, status code of response was not 200, it was %ld", (long)statusCode);
            }
        }
        
        NSError *error;
        returnDictionary = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:&error];
        if (returnDictionary) {
            NSLog(@"returnDictionary=%@", returnDictionary);
        } else {
            NSLog(@"error parsing JSON response: %@", error);
            
            NSString *returnString = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
            NSLog(@"returnString: %@", returnString);
            returnDictionary = [NSDictionary dictionaryWithObjectsAndKeys:returnString, @"parseError", nil];
        }
    } else {
        NSLog(@"NSURLConnection sendSynchronousRequest error: %@", requestError);
        returnDictionary = [NSDictionary dictionaryWithObjectsAndKeys:requestError, @"requestError", nil];
    }
    return returnDictionary;
}

- (NSDictionary *)doCurl:(NSData *)jsonData url:(NSString *)url method:(NSString *)method{
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonString);  // To verify the jsonString.
    NSLog(@"%@", url);  
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    [postRequest setHTTPMethod:method];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:jsonData];
    
    NSURLResponse *response = nil;
    NSError *requestError = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&requestError];
    
    NSDictionary *returnDictionary = nil;
    
    if (requestError == nil) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"Warning, status code of response was not 200, it was %ld", (long)statusCode);
            }
        }
        
        NSError *error;
        returnDictionary = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:&error];
        if (returnDictionary) {
            NSLog(@"returnDictionary=%@", returnDictionary);
        } else {
            NSLog(@"error parsing JSON response: %@", error);
            
            NSString *returnString = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
            NSLog(@"returnString: %@", returnString);
            returnDictionary = [NSDictionary dictionaryWithObjectsAndKeys:returnString, @"parseError", nil];
        }
    } else {
        NSLog(@"NSURLConnection sendSynchronousRequest error: %@", requestError);
        returnDictionary = [NSDictionary dictionaryWithObjectsAndKeys:requestError, @"requestError", nil];
    }
    return returnDictionary;
}
@end
