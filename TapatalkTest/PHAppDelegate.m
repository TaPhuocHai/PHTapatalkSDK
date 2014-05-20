//
//  PHAppDelegate.m
//  TapatalkTest
//
//  Created by Ta Phuoc Hai on 4/14/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PHAppDelegate.h"

@implementation PHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [LNTapatalkSDK startWithFormUrl:@"http://www.webtretho.com/forum"];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [LNTapatalkSDK didBecomeActive];
    
    // Get config
    [TapatalkAPI getConfigCompletionHandler:^(NSDictionary *config, NSError *error) {
    }];
    
    // Register new user
    [TapatalkAPI registerWithEmail:@"hai.ta@webtretho.com"
                          username:@"hai.ta"
                          password:@"123456"
                 completionHandler:^(BOOL success, NSString *message, NSError *error) {
                     NSLog(@"register %@", success ? @"success" : @"failure");
                     NSLog(@"message = %@", message);
                     NSLog(@"error = %@", error);
                 }];
}

@end
