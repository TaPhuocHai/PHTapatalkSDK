//
//  PHAppDelegate.m
//  TapatalkSDK
//
//  Created by Ta Phuoc Hai on 1/18/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PHAppDelegate.h"

@implementation PHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
