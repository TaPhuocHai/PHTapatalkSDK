//
//  LNBasePaging.m
//  ProjectLana
//
//  Created by TAPHUOCHAI on 12/25/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import "LNBasePaging.h"

@implementation LNBasePaging

@synthesize
dataOfPage = _dataOfPage,
lastRequestPage = _lastRequestPage;

#define kPerPageDefault  10

- (id)init
{
    if (self = [super init]) {
        _perPage = kPerPageDefault;
        _dataOfPage = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithPerPage:(NSInteger)numberOfPerPage
{
    if (self = [self init]) {
        _perPage = numberOfPerPage;
    }
    return self;
}

#pragma mark - Properties

- (NSInteger)totalPage
{
    float tempTotal = _totalDataNumber/(float)_perPage;
    tempTotal = (tempTotal > (int)tempTotal) ? tempTotal + 1 : (int)tempTotal;
    return tempTotal;
}

#pragma mark -

- (void)startRequestOnComplete:(void (^)(NSArray *arrData))completeBlock
                     onFailure:(void (^)(NSError *error))failureBlock
{
    if (!self.delegate) {
        if (failureBlock) failureBlock([NSError errorWithDomain:@"local" code:1 userInfo:@{@"error" : @"delegate is nil"}]);
    }
    
    _lastRequestPage = 1;
    [self.delegate loadDataFrom:0
                             to:self.perPage - 1
                       complete:^(NSArray *data,NSInteger totalDataNumber)
    {
        _dataOfPage[@(_lastRequestPage)] = data;
        _totalDataNumber = totalDataNumber;
        if (completeBlock) completeBlock(data);
    } failure:^(NSError *error) {
        if (failureBlock) failureBlock(error);
    }];
}

- (void)loadNextPageOnComplete:(void (^)(NSArray *arrData))completeBlock
                     onFailure:(void (^)(NSError *error))failureBlock
{
    NSInteger nextPageToLoad = _lastRequestPage + 1;
    [self.delegate loadDataFrom:(nextPageToLoad - 1) * self.perPage
                             to:(nextPageToLoad * self.perPage) - 1
                       complete:^(NSArray *data, NSInteger totalDataNumber)
    {
        _lastRequestPage = nextPageToLoad;
        _dataOfPage[@(_lastRequestPage)] = data;
        if (completeBlock) completeBlock(data);
    } failure:^(NSError *error) {
        if (failureBlock) failureBlock(error);
    }];
}

#pragma mark - Clean up 

- (void)dealloc
{
    _dataOfPage = nil;
    _delegate = nil;
}

@end
