//
//  LNPagingSearch.m
//  ProjectLana
//
//  Created by Ta Phuoc Hai on 3/15/13.
//  Copyright (c) 2013 Project Lana. All rights reserved.
//

#import "LNSearchPaging.h"
#import "TapatalkAPI.h"

@implementation LNSearchPaging

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
    if (self.searchString.length == 0) {
        if (failureBlock) failureBlock([NSError errorWithDomain:@"local" code:1 userInfo:@{@"error" : @"search nil"}]);
        return;
    }
    
    [TapatalkAPI searchTopic:self.searchString
                 startNumber:from
                  lastNumber:to
                    searchId:self.searchId
           completionHandler:^(NSString *searchId, NSArray *arrTopic, NSInteger totalTopicNum, NSError *error)
    {
        if (error) {
            if (failureBlock) failureBlock(error);
            return;
        }
        
        self.searchId = searchId;
        if (completeBlock) completeBlock(arrTopic, totalTopicNum);
    } onPercent:^(float percent) {
    }];
}

@end
