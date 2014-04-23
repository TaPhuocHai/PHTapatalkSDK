//
//  LNPagingSubscribe.m
//  ProjectLana
//
//  Created by Ta Phuoc Hai on 3/15/13.
//  Copyright (c) 2013 Project Lana. All rights reserved.
//

#import "LNSubscribePaging.h"
#import "LNTapatalkSDK.h"
#import "TapatalkAPI.h"
#import "LNAccountManager.h"

@implementation LNSubscribePaging

- (id)init
{
    if (self = [super init]) {
        self.delegate = self;
    }
    return self;
}

- (id)initWithPerPage:(NSInteger)numberOfPerPage
{
    if (self = [super initWithPerPage:numberOfPerPage]) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - LNBasePagingDelegate

- (void)loadDataFrom:(NSInteger)from
                  to:(NSInteger)to
            complete:(void (^)(NSArray * data, NSInteger totalDataNumber))completeBlock
             failure:(void (^)(NSError * error))failureBlock
{
    // Check user login ?
    if (![LNAccountManager sharedInstance].isLoggedIn) {
        if (failureBlock) failureBlock([NSError errorWithDomain:@"local" code:1 userInfo:@{@"error" : @"user not login yet"}]);
        return;
    }
    
    [TapatalkAPI getSubscribeTopic:from
                           lastNum:to
                 completionHandler:^(NSArray *arrTopic, NSInteger totalTopicNum, NSError *error)
    {
        if (error) {
            // login and try againt
            [LNAccountManager autoLoginOnCompletionHander:^(ModelUser *result, NSError *error2) {
                if (error2) {
                    if(failureBlock) failureBlock(error);
                } else {
                    [TapatalkAPI getSubscribeTopic:from
                                           lastNum:to
                                 completionHandler:^(NSArray *arrTopic2, NSInteger totalTopicNum2, NSError *error3)
                    {
                        if (error2) {
                            if(failureBlock) failureBlock(error);
                        } else {
                            if (completeBlock) completeBlock(arrTopic2, totalTopicNum2);
                        }
                    }];
                }
            }];
        } else {
            if (completeBlock) completeBlock(arrTopic, totalTopicNum);
        }
    }];
}

@end
