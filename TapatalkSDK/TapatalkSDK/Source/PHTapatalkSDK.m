//
//  TapatalkSDK.h
//  TapatalkSDK
//
//  Created by Ta Phuoc Hai on 1/18/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//
#import "PHTapatalkSDK.h"

@implementation PHTapatalkSDK

static ModelForum * _form;
+ (ModelForum*)rootForum
{
    return _form;
}

+ (void)didBecomeActive
{
    // Auto login to expire cookie
    [LNAccountManager autoLoginOnCompletionHander:^(ModelUser *result, NSError *error) {
        if (error) {
            NSLog(@"auto login failure : %@", error);
        } else {
            NSLog(@"auto login success");
        }
    }];
    
    // Get all forum
    [TapatalkAPI getForum:nil returnDescription:YES completionHandler:^(ModelForum *result) {
        _form = nil;
        _form = result;
    } failureHandler:^(NSError *error) {
    }];
}

@end