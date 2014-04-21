//
//  LNPagingUnreadTopic.m
//  ProjectLana
//
//  Created by Ta Phuoc Hai on 3/18/13.
//  Copyright (c) 2013 Project Lana. All rights reserved.
//

#import "LNUnreadTopicPaging.h"
#import "TapatalkAPI.h"
#import "ModelTopic.h"

@implementation LNUnreadTopicPaging

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
          completion:(void (^)(NSArray * data, NSInteger totalDataNumber))completeBlock
             failure:(void (^)(NSError * error))failureBlock
{
    // Check user login ?
    if (![LNAccountManager sharedInstance].isLoggedIn) {
        if (failureBlock) failureBlock([NSError errorWithDomain:@"local" code:1 userInfo:@{@"error" : @"user not login yet"}]);
        return;
    }
    
    [TapatalkAPI getUnreadTopicWithStartNum:from
                                    lastNum:to
                          completionHandler:^(NSArray *arrTopic, NSInteger totalTopicNum , NSError *error)
    {
        if (error) {
            if(failureBlock) failureBlock(error);
        } else {
            if (completeBlock) completeBlock(arrTopic, totalTopicNum);
        }
    } onPercent:^(float percent) {
    }];
}

@end
