//
//  LNBasePaging.m
//  ProjectLana
//
//  Created by TAPHUOCHAI on 12/25/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import "LNBasePaging.h"

@interface LNBasePaging ()

@property(nonatomic, copy) void (^_pCompletionBlock)(NSArray *arrData);
@property(nonatomic, copy) void (^_pErrorBlock)(NSError *error);

@end

@implementation LNBasePaging

@synthesize
data = _data,
lastRequestPage = _lastRequestPage,
totalDataNumber = _totalDataNumber;

#define kPerPageDefault  10

- (id)init
{
    if (self = [super init]) {
        _perPage = kPerPageDefault;
        _data = [NSMutableArray array];
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
    self._pCompletionBlock = completeBlock;
    self._pErrorBlock = failureBlock;
    
    if (!self.delegate) {
        if (failureBlock) failureBlock([NSError errorWithDomain:@"local" code:1 userInfo:@{@"error" : @"delegate is nil"}]);
    }
    
    _lastRequestPage = 1;
    [self.delegate loadDataFrom:0
                             to:self.perPage - 1
                       complete:^(NSArray *data,NSInteger totalDataNumber)
    {
        _data = [NSMutableArray arrayWithArray:data];
        _totalDataNumber = totalDataNumber;
        if (self._pCompletionBlock)  self._pCompletionBlock(data);
        [self cleaUp];
    } failure:^(NSError *error) {
        if (self._pErrorBlock) self._pErrorBlock(error);
        [self cleaUp];
    }];
}

- (void)loadNextPageOnComplete:(void (^)(NSArray *arrData))completeBlock
                     onFailure:(void (^)(NSError *error))failureBlock
{
    self._pCompletionBlock = completeBlock;
    self._pErrorBlock = failureBlock;
    
    NSInteger nextPageToLoad = _lastRequestPage + 1;
    [self.delegate loadDataFrom:(nextPageToLoad - 1) * self.perPage
                             to:(nextPageToLoad * self.perPage) - 1
                       complete:^(NSArray *data, NSInteger totalDataNumber)
    {
        _lastRequestPage = nextPageToLoad;
        [_data addObjectsFromArray:data];
        if (self._pCompletionBlock) self._pCompletionBlock(data);
        [self cleaUp];
    } failure:^(NSError *error) {
        if (self._pErrorBlock) self._pErrorBlock(error);
        [self cleaUp];
    }];
}

- (void)cleaUp
{
    self._pCompletionBlock = nil;
    self._pErrorBlock = nil;
}

#pragma mark - Clean up 

- (void)dealloc
{
    NSLog(@"dealloc LNBasePaging");
    [self cleaUp];
    
    _data = nil;
    _delegate = nil;    
}

@end
