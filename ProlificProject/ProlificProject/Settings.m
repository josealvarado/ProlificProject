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

@end
