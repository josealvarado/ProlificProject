//
//  Settings.h
//  ProlificProject
//
//  Created by Jose Alvarado on 12/14/14.
//  Copyright (c) 2014 JoseAlvarado. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (strong, nonatomic) NSMutableArray *books;

+ (Settings *)instance;

- (NSDictionary *)doPOST:(NSData *)jsonData url:(NSString *)url;

- (NSDictionary *)doCurl:(NSData *)jsonData url:(NSString *)url method:(NSString *)method;

@end
