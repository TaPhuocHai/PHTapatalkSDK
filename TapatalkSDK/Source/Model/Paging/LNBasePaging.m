//
//  LNBasePaging.m
//  ProjectLana
//
//  Created by TAPHUOCHAI on 12/25/12.
//  Copyright (c) 2012 Project Lana. All rights reserved.
//

#import "LNBasePaging.h"

@implementation LNBasePaging

#define kPagingTopicNumber  10

- (id)init {
    if (self = [super init]) {
        _countPaging = kPagingTopicNumber;
    }
    return self;
}

- (id)initWithPaging:(int)paging {
    if (self = [self init]) {
        _countPaging = paging;
    }
    return self;
}

#pragma mark 

- (int)totalPage {
    float tempTotal = _totalCountData/(float)_countPaging;
    _totalPage = (tempTotal > (int)tempTotal) ? tempTotal + 1 : (int)tempTotal;
    return _totalPage;
}

- (int)maxIndexPageLoaded {
    return _maxIndexPageLoaded;
}

#pragma mark - 

- (BOOL)isNextPage {
    if (self.maxIndexPageLoaded < self.totalPage) {
        return YES;
    }
    return NO;
}

// abstract method
- (void)startPagingOnSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild {
}

// arrData là dữ liệu được load thêm
- (void)loadNextPageOnSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild {
}


- (void)reloadPagingOnSuccess:(void (^)(NSArray *arrData))_onSuccess onFaild:(void (^)(NSError *error))_onFaild
{
    [self startPagingOnSuccess:^(NSArray *arrData) {
        _onSuccess(arrData);
    } onFaild:^(NSError *error) {
        _onFaild(error);
    }];
}

@end
