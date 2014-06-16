//
//  TapatalkSDK.h
//  TapatalkSDK
//
//  Created by Ta Phuoc Hai on 1/18/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//
#import "LNTapatalkSDK.h"
#import "PHLogTime.h"

@implementation LNTapatalkSDK

static ModelForum * _forum;
+ (ModelForum*)rootForum
{
    return _forum;
}

+ (void)startWithFormUrl:(NSString*)forumUrl
{
    // Init api engine
    [TapatalkAPI shareInstanceWithUrl:forumUrl];
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
        _forum = nil;
        _forum = result;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSTapatalkDidLoadRootForum object:@(YES)];
    } failureHandler:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSTapatalkDidLoadRootForum object:@(NO)];
    }];
}

@end